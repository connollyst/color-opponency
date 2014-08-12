function [L_diagonal, M_diagonal] = DODiagonal(I, config)
    % Long (red) wavelength orientation opponancy..
    L = I(:,:,1);
    L_top_left_center       = apply_top_left_center_filter      (L, config);
    L_top_right_center      = apply_top_right_center_filter     (L, config);
    L_top_left_surround     = apply_top_left_surround_filter    (L, config);
    L_top_right_surround    = apply_top_right_surround_filter   (L, config);
    L_bottom_left_center    = apply_bottom_left_center_filter   (L, config);
    L_bottom_right_center   = apply_bottom_right_center_filter  (L, config);
    L_bottom_left_surround  = apply_bottom_left_surround_filter (L, config);
    L_bottom_right_surround = apply_bottom_right_surround_filter(L, config);
    
    % Middle (green) wavelength orientation opponancy..
    M = I(:,:,2);
    M_top_left_center       = apply_top_left_center_filter      (M, config);
    M_top_right_center      = apply_top_right_center_filter     (M, config);
    M_top_left_surround     = apply_top_left_surround_filter    (M, config);
    M_top_right_surround    = apply_top_right_surround_filter   (M, config);
    M_bottom_left_center    = apply_bottom_left_center_filter   (M, config);
    M_bottom_right_center   = apply_bottom_right_center_filter  (M, config);
    M_bottom_left_surround  = apply_bottom_left_surround_filter (M, config);
    M_bottom_right_surround = apply_bottom_right_surround_filter(M, config);
    
    % Wavelength opponancy..
    L_top_left     = utils.on(L_top_left_center     + M_bottom_right_surround);
    L_top_right    = utils.on(L_top_right_center    + M_bottom_left_surround);
    M_top_left     = utils.on(M_top_left_center     + L_bottom_right_surround);
    M_top_right    = utils.on(M_top_right_center    + L_bottom_left_surround);
    L_bottom_left  = utils.on(L_bottom_left_center  + M_top_right_surround);
    L_bottom_right = utils.on(L_bottom_right_center + M_top_left_surround);
    M_bottom_left  = utils.on(M_bottom_left_center  + L_top_right_surround);
    M_bottom_right = utils.on(M_bottom_right_center + L_top_left_surround);
    
    % Combine diagonals..
    L_diagonal = L_top_left + L_top_right + L_bottom_right + L_bottom_left;
    M_diagonal = M_top_left + M_top_right + M_bottom_right + M_bottom_left;
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
    filtered = imfilter(img, filter, 'same');
end