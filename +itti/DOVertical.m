function [R_v, G_v, B_v, Y_v] = DOVertical(rgb, config)
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        [r_t_c, r_b_c] = top_bottom_center(r, scale, config);
        [g_t_c, g_b_c] = top_bottom_center(g, scale, config);
        [b_t_c, b_b_c] = top_bottom_center(b, scale, config);

        [r_t_s, r_b_s] = top_bottom_surround(r, scale, config);
        [g_t_s, g_b_s] = top_bottom_surround(g, scale, config);
        [b_t_s, b_b_s] = top_bottom_surround(b, scale, config);

        % Combine center surround signals to obtain color opponency..
        R_t = utils.on(r_t_c - (g_b_s + b_b_s)/2);
        G_t = utils.on(g_t_c - (r_b_s + b_b_s)/2);
        B_t = utils.on(b_t_c - (r_b_s + g_b_s)/2);
        Y_t = utils.on((r_t_c + g_t_c)/2 - abs(r_b_s - g_b_s)/2 - b_b_s);

        R_b = utils.on(r_b_c - (g_t_s + b_t_s)/2);
        G_b = utils.on(g_b_c - (r_t_s + b_t_s)/2);
        B_b = utils.on(b_b_c - (r_t_s + g_t_s)/2);
        Y_b = utils.on((r_b_c + g_b_c)/2 - abs(r_t_s - g_t_s)/2 - b_t_s);

        % Consolidate to get all vertical color opponency..
        % TODO average? sum?
        R_v = max(R_t, R_b);
        G_v = max(G_t, G_b);
        B_v = max(B_t, B_b);
        Y_v = max(Y_t, Y_b);

        figure(1)
        subplot(2, 2, 1), imshow(R_v), title('red');
        subplot(2, 2, 2), imshow(G_v), title('green');
        subplot(2, 2, 3), imshow(B_v), title('blue');
        subplot(2, 2, 4), imshow(Y_v), title('yellow');
        waitforbuttonpress;
    end
end

function [t_center, b_center] = top_bottom_center(color, scale, config)
    t_center   = utils.on(apply_top_center_filter(color, scale, config));
    b_center   = utils.on(apply_bottom_center_filter(color, scale, config));
end

function [t_surround, b_surround] = top_bottom_surround(color, scale, config)
    t_surround = utils.off(apply_top_surround_filter(color, scale, config));
    b_surround = utils.off(apply_bottom_surround_filter(color, scale, config));
end

function I_out = apply_top_center_filter(color, scale, config)
    filter = rf.oriented.center_top_middle(scale, config)      ...
                - rf.oriented.center_bottom_middle(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_bottom_center_filter(color, scale, config)
    filter = rf.oriented.center_bottom_middle(scale, config)   ...
                - rf.oriented.center_top_middle(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_top_surround_filter(color, scale, config)
    filter = rf.oriented.surround_top_middle(scale, config)    ...
                - rf.oriented.surround_bottom_middle(scale, config);
    I_out = gaussian(color, filter());
end

function I_out = apply_bottom_surround_filter(color, scale, config)
    filter = rf.oriented.surround_bottom_middle(scale, config) ...
                - rf.oriented.surround_top_middle(scale, config);
    I_out = gaussian(color, filter());
end

function filtered = gaussian(img, filter)
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