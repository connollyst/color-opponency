function [R_h, G_h, B_h, Y_h] = DOHorizontal(rgb, config)
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        [r_l_c, r_r_c] = left_right_center(r, scale, config);
        [g_l_c, g_r_c] = left_right_center(g, scale, config);
        [b_l_c, b_r_c] = left_right_center(b, scale, config);

        [r_l_s, r_r_s] = left_right_surround(r, scale, config);
        [g_l_s, g_r_s] = left_right_surround(g, scale, config);
        [b_l_s, b_r_s] = left_right_surround(b, scale, config);

        % Combine center surround signals to obtain color opponency..
        R_l = utils.on(r_l_c - (g_r_s + b_r_s)/2);
        G_l = utils.on(g_l_c - (r_r_s + b_r_s)/2);
        B_l = utils.on(b_l_c - (r_r_s + g_r_s)/2);
        Y_l = utils.on((r_l_c + g_l_c)/2 - abs(r_r_s - g_r_s)/2 - b_r_s);

        R_r = utils.on(r_r_c - (g_l_s + b_l_s)/2);
        G_r = utils.on(g_r_c - (r_l_s + b_l_s)/2);
        B_r = utils.on(b_r_c - (r_l_s + g_l_s)/2);
        Y_r = utils.on((r_r_c + g_r_c)/2 - abs(r_l_s - g_l_s)/2 - b_l_s);

        % Consolidate to get all horizontal color opponency..
        % TODO average? sum?
        R_h = max(R_l, R_r);
        G_h = max(G_l, G_r);
        B_h = max(B_l, B_r);
        Y_h = max(Y_l, Y_r);

        figure(1)
        subplot(2, 2, 1), imshow(R_h), title('red');
        subplot(2, 2, 2), imshow(G_h), title('green');
        subplot(2, 2, 3), imshow(B_h), title('blue');
        subplot(2, 2, 4), imshow(Y_h), title('yellow');
        waitforbuttonpress;
    end
end

function [l_center, r_center] = left_right_center(color, scale, config)
    l_center   = utils.on(apply_left_excitatory_filter(color, scale, config));
    r_center   = utils.on(apply_right_excitatory_filter(color, scale, config));
end

function [l_surround, r_surround] = left_right_surround(color, scale, config)
    l_surround = utils.off(apply_left_inhibitory_filter(color, scale, config));
    r_surround = utils.off(apply_right_inhibitory_filter(color, scale, config));
end

function rgb_out = apply_left_excitatory_filter(color, scale, config)
    filter = rf.oriented.center_middle_left(scale, config) ...
                - rf.oriented.center_middle_right(scale, config);
    rgb_out = apply(color, filter);
end

function rgb_out = apply_right_excitatory_filter(color, scale, config)
    filter = rf.oriented.center_middle_right(scale, config) ...
                - rf.oriented.center_middle_left(scale, config);
    rgb_out = apply(color, filter);
end

function rgb_out = apply_left_inhibitory_filter(color, scale, config)
    filter = rf.oriented.surround_middle_left(scale, config) ...
                - rf.oriented.surround_middle_right(scale, config);
    rgb_out = apply(color, filter);
end

function rgb_out = apply_right_inhibitory_filter(color, scale, config)
    filter = rf.oriented.surround_middle_right(scale, config) ...
                - rf.oriented.surround_middle_left(scale, config);
    rgb_out = apply(color, filter);
end

function filtered = apply(img, filter)
    % Add padding
    pad_cols = ceil(size(img,1)/2);
    pad_rows = ceil(size(img,2)/2);
    padded   = padarray(img, [pad_cols, pad_rows], 'symmetric','both');
    % Apply filter
    padded_filtered = imfilter(padded, filter, 'same');
    % Remove padding
    cols = pad_cols+1:pad_cols+size(img,1);
    rows = pad_rows+1:pad_rows+size(img,2);
    filtered = padded_filtered(cols,rows);
end