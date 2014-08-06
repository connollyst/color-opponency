function [L_top, L_bottom, M_top, M_bottom] = DOHorizontal( I, varargin )

    L = I(:,:,1); % Long wavelength:   red
    M = I(:,:,2); % Middle wavelength: green
    L_top_center      = apply_top_center_filter(L);
    M_top_center      = apply_top_center_filter(M);
    L_bottom_center   = apply_bottom_center_filter(L);
    M_bottom_center   = apply_bottom_center_filter(M);
    L_top_surround    = apply_top_surround_filter(L);
    M_top_surround    = apply_top_surround_filter(M);
    L_bottom_surround = apply_bottom_surround_filter(L);
    M_bottom_surround = apply_bottom_surround_filter(M);
    
    %% Plus (p**) and minus (m**) opponency channels (p1009)
    L_top    = on(L_top_center  + M_bottom_surround);
    L_bottom = on(L_bottom_center + M_top_surround);
    M_top    = on(M_top_center  + L_bottom_surround);
    M_bottom = on(M_bottom_center + L_top_surround);
end

function I_out = apply_top_center_filter(I_in)
    filter = top_center() - bottom_center();
    I_out = gaussian(I_in, filter);
end

function I_out = apply_bottom_center_filter(I_in)
    filter = bottom_center() - top_center();
    I_out = gaussian(I_in, filter);
end

function I_out = apply_top_surround_filter(I_in)
    filter = top_surround() - bottom_surround();
    I_out = gaussian(I_in, filter);
end

function I_out = apply_bottom_surround_filter(I_in)
    filter = bottom_surround() - top_surround();
    I_out = gaussian(I_in, filter);
end

function l = top_center()
    l = customgauss([20 20], 3, 2.5, 90, 0, 10, [-5 0]);
end

function l = bottom_center()
    l = customgauss([20 20], 3, 2.5, 90, 0, 10, [ 5 0]);
end

function l = top_surround()
    l = customgauss([20 20], 3,   5, 90, 0,  5, [-5 0]);
end

function l = bottom_surround()
    l = customgauss([20 20], 3,   5, 90, 0,  5, [ 5 0]);
end

function filtered = gaussian(img, filter)
    filtered = imfilter(img, filter, 'same');
end

function I_on = on( I )
    I_on = I;
    I_on(I_on < 0) = 0;
end
