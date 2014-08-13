function [R_d, G_d, B_d, Y_d] = DODiagonal(rgb, config)

    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    i = (r + g + b)/3;
    
    [r_tl_c, r_tr_c, r_br_c, r_bl_c] = centers(r, config);
    [g_tl_c, g_tr_c, g_br_c, g_bl_c] = centers(g, config);
    [b_tl_c, b_tr_c, b_br_c, b_bl_c] = centers(b, config);
    [i_tl_c, i_tr_c, i_br_c, i_bl_c] = centers(i, config);
    
    [r_tl_s, r_tr_s, r_br_s, r_bl_s] = surrounds(r, config);
    [g_tl_s, g_tr_s, g_br_s, g_bl_s] = surrounds(g, config);
    [b_tl_s, b_tr_s, b_br_s, b_bl_s] = surrounds(b, config);
    [i_tl_s, i_tr_s, i_br_s, i_bl_s] = surrounds(i, config);
    
    % Combine center surround signals to obtain color opponency..
    % TOP LEFT
    R_tl = utils.on(r_tl_c - (g_br_s + b_br_s)/2);
    G_tl = utils.on(g_tl_c - (r_br_s + b_br_s)/2);
    B_tl = utils.on(b_tl_c - (r_br_s + g_br_s)/2);
    Y_tl = utils.on((r_tl_c + g_tl_c)/2 - abs(r_br_s - g_br_s)/2 - b_br_s);
    % TOP RIGHT
    R_tr = utils.on(r_tr_c - (g_bl_s + b_bl_s)/2);
    G_tr = utils.on(g_tr_c - (r_bl_s + b_bl_s)/2);
    B_tr = utils.on(b_tr_c - (r_bl_s + g_bl_s)/2);
    Y_tr = utils.on((r_tr_c + g_tr_c)/2 - abs(r_bl_s - g_bl_s)/2 - b_bl_s);
    % BOTTOM RIGHT
    R_br = utils.on(r_br_c - (g_tl_s + b_tl_s)/2);
    G_br = utils.on(g_br_c - (r_tl_s + b_tl_s)/2);
    B_br = utils.on(b_br_c - (r_tl_s + g_tl_s)/2);
    Y_br = utils.on((r_br_c + g_br_c)/2 - abs(r_tl_s - g_tl_s)/2 - b_tl_s);
    % BOTTOM LEFT
    R_bl = utils.on(r_bl_c - (g_tr_s + b_tr_s)/2);
    G_bl = utils.on(g_bl_c - (r_tr_s + b_tr_s)/2);
    B_bl = utils.on(b_bl_c - (r_tr_s + g_tr_s)/2);
    Y_bl = utils.on((r_bl_c + g_bl_c)/2 - abs(r_tr_s - g_tr_s)/2 - b_tr_s);
    
    % Consolidate to get all diagonal color opponency..
    R_d = R_tl + R_tr + R_br + R_bl;
    G_d = G_tl + G_tr + G_br + G_bl;
    B_d = B_tl + B_tr + B_br + B_bl;
    Y_d = Y_tl + Y_tr + Y_br + Y_bl;
    
    figure()
    subplot(3, 2, 1), imshow(rgb);
    %subplot(3, 2, 2), imagesc(I_d), colormap('gray'), title('intensity');
    subplot(3, 2, 3), imshow(R_d), colormap('gray'), title('red');
    subplot(3, 2, 4), imshow(G_d), colormap('gray'), title('green');
    subplot(3, 2, 5), imshow(B_d), colormap('gray'), title('blue');
    subplot(3, 2, 6), imshow(Y_d), colormap('gray'), title('yellow');
end

function [tlc, trc, brc, blc] = centers(color, config)
% Returns the top & bottom by left & right centers.
    tlc = apply_top_left_center_filter      (color, config);
    trc = apply_top_right_center_filter     (color, config);
    blc = apply_bottom_left_center_filter   (color, config);
    brc = apply_bottom_right_center_filter  (color, config);
end

function [tls, trs, brs, bls] = surrounds(color, config)
% Returns the top & bottom by left & right surrounds.
    tls = apply_top_left_surround_filter    (color, config);
    trs = apply_top_right_surround_filter   (color, config);
    bls = apply_bottom_left_surround_filter (color, config);
    brs = apply_bottom_right_surround_filter(color, config);
end

function I_out = apply_top_left_center_filter(I_in, config)
    filter = rf.oriented.center_top_left(config) ...
                - rf.oriented.center_bottom_right(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_top_right_center_filter(I_in, config)
    filter = rf.oriented.center_top_right(config) ...
                - rf.oriented.center_bottom_left(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_right_center_filter(I_in, config)
    filter = rf.oriented.center_bottom_right(config) ...
                - rf.oriented.center_top_left(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_left_center_filter(I_in, config)
    filter = rf.oriented.center_bottom_left(config) ...
                - rf.oriented.center_top_right(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_top_left_surround_filter(I_in, config)
    filter = rf.oriented.surround_top_left(config) ...
                - rf.oriented.surround_bottom_right(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_top_right_surround_filter(I_in, config)
    filter = rf.oriented.surround_top_right(config) ...
                - rf.oriented.surround_bottom_left(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_right_surround_filter(I_in, config)
    filter = rf.oriented.surround_bottom_right(config) ...
                - rf.oriented.surround_top_left(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_left_surround_filter(I_in, config)
    filter = rf.oriented.surround_bottom_left(config) ...
                - rf.oriented.surround_top_right(config);
    I_out = gaussian(I_in, filter());
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