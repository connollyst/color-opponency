function [R_h, G_h, B_h, Y_h] = DOHorizontal(rgb, config)
    
    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    i = (r + g + b)/3;
    
    [r_l_c, r_r_c] = left_right_center(r, config);
    [g_l_c, g_r_c] = left_right_center(g, config);
    [b_l_c, b_r_c] = left_right_center(b, config);
    [i_l_c, i_r_c] = left_right_center(i, config);
    %r_l_c = itti_normalize(r_l_c, i_l_c);
    %g_l_c = itti_normalize(g_l_c, i_l_c);
    %b_l_c = itti_normalize(b_l_c, i_l_c);
    %r_r_c = itti_normalize(r_r_c, i_r_c);
    %g_r_c = itti_normalize(g_r_c, i_r_c);
    %b_r_c = itti_normalize(b_r_c, i_r_c);
    
    [r_l_s, r_r_s] = left_right_surround(r, config);
    [g_l_s, g_r_s] = left_right_surround(g, config);
    [b_l_s, b_r_s] = left_right_surround(b, config);
    [i_l_s, i_r_s] = left_right_surround(i, config);
    %r_l_s = itti_normalize(r_l_s, i_l_s);
    %g_l_s = itti_normalize(g_l_s, i_l_s);
    %b_l_s = itti_normalize(b_l_s, i_l_s);
    %r_r_s = itti_normalize(r_r_s, i_r_s);
    %g_r_s = itti_normalize(g_r_s, i_r_s);
    %b_r_s = itti_normalize(b_r_s, i_r_s);
    
    % Combine center surround signals to obtain color opponency..
    %I = i_c - i_s;  % TODO lightness/darkness?
    R_l = utils.on(r_l_c - (g_r_s + b_r_s)/2);
    G_l = utils.on(g_l_c - (r_r_s + b_r_s)/2);
    B_l = utils.on(b_l_c - (r_r_s + g_r_s)/2);
    Y_l = utils.on((r_l_c + g_l_c)/2 - abs(r_r_s - g_r_s)/2 - b_r_s);
    
    R_r = utils.on(r_r_c - (g_l_s + b_l_s)/2);
    G_r = utils.on(g_r_c - (r_l_s + b_l_s)/2);
    B_r = utils.on(b_r_c - (r_l_s + g_l_s)/2);
    Y_r = utils.on((r_r_c + g_r_c)/2 - abs(r_l_s - g_l_s)/2 - b_l_s);
    
    % Recover all horizontal color opponency..
    R_h = R_l + R_r;
    G_h = G_l + G_r;
    B_h = B_l + B_r;
    Y_h = Y_l + Y_r;
    
    figure()
    subplot(3, 2, 1), imshow(rgb);
    %subplot(3, 2, 2), imagesc(I), colormap('gray'), title('intensity');
    subplot(3, 2, 3), imagesc(R_h), colormap('gray'), title('red');
    subplot(3, 2, 4), imagesc(G_h), colormap('gray'), title('green');
    subplot(3, 2, 5), imagesc(B_h), colormap('gray'), title('blue');
    subplot(3, 2, 6), imagesc(Y_h), colormap('gray'), title('yellow');
end

function [l_center, r_center] = left_right_center(color, config)
    l_center   = utils.on(apply_left_excitatory_filter(color, config));
    r_center   = utils.on(apply_right_excitatory_filter(color, config));
end

function [l_surround, r_surround] = left_right_surround(color, config)
    l_surround = utils.off(apply_left_inhibitory_filter(color, config));
    r_surround = utils.off(apply_right_inhibitory_filter(color, config));
end

function rgb_out = apply_left_excitatory_filter(rgb_in, config)
    filter = rf.oriented.center_middle_left(config) ...
                - rf.oriented.center_middle_right(config);
    rgb_out = apply(rgb_in, filter);
end

function rgb_out = apply_right_excitatory_filter(rgb_in, config)
    filter = rf.oriented.center_middle_right(config) ...
                - rf.oriented.center_middle_left(config);
    rgb_out = apply(rgb_in, filter);
end

function rgb_out = apply_left_inhibitory_filter(rgb_in, config)
    filter = rf.oriented.surround_middle_left(config) ...
                - rf.oriented.surround_middle_right(config);
    rgb_out = apply(rgb_in, filter);
end

function rgb_out = apply_right_inhibitory_filter(rgb_in, config)
    filter = rf.oriented.surround_middle_right(config) ...
                - rf.oriented.surround_middle_left(config);
    rgb_out = apply(rgb_in, filter);
end

function filtered = apply(img, filter)
    filtered = imfilter(img, filter, 'same');
end

function n = itti_normalize(channel, I)
% Normalize channel (r, g, or b) by I.
%   Note, unlike in Itti 1998, we itti_normalize values at low luminance also.
    n = channel./I;
end