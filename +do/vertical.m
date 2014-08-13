function [L_vertical, M_vertical] = vertical(I, config)
    L = I(:,:,1);
    M = I(:,:,2);
    L_top    = get_top(L, M, config);
    M_top    = get_top(M, L, config);
    L_bottom = get_bottom(L, M, config);
    M_bottom = get_bottom(M, L, config);
    L_vertical = L_top + L_bottom;
    M_vertical = M_top + M_bottom;
end

function top = get_top(on, off, config)
    top_center      = apply_top_center_filter(on, config);
    bottom_surround = apply_bottom_surround_filter(off, config);
    % Wavelength opponency..
    % TODO shouldn't this be minus?
    top = utils.on(top_center    + bottom_surround);
end

function bottom = get_bottom(on, off, config)
    % Orientation opponency..
    bottom_center = apply_bottom_center_filter(on, config);
    top_surround  = apply_top_surround_filter(off, config);
    % Wavelength opponency..
    % TODO shouldn't this be minus?
    bottom = utils.on(bottom_center + top_surround);
end

function I_out = apply_top_center_filter(I_in, config)
    filter = rf.oriented.center_top_middle(config)      ...
                - rf.oriented.center_bottom_middle(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_center_filter(I_in, config)
    filter = rf.oriented.center_bottom_middle(config)   ...
                - rf.oriented.center_top_middle(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_top_surround_filter(I_in, config)
    filter = rf.oriented.surround_top_middle(config)    ...
                - rf.oriented.surround_bottom_middle(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_surround_filter(I_in, config)
    filter = rf.oriented.surround_bottom_middle(config) ...
                - rf.oriented.surround_top_middle(config);
    I_out = gaussian(I_in, filter());
end

function filtered = gaussian(img, filter)
    filtered = imfilter(img, filter, 'same');
end