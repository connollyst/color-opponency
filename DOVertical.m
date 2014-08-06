function [L_left, L_right, M_left, M_right] = DOVertical( I, varargin )

    L = I(:,:,1); % Long wavelength:   red
    M = I(:,:,2); % Middle wavelength: green
    L_left_center    = apply_left_center_filter(L);
    M_left_center    = apply_left_center_filter(M);
    L_right_center   = apply_right_center_filter(L);
    M_right_center   = apply_right_center_filter(M);
    L_left_surround  = apply_left_surround_filter(L);
    M_left_surround  = apply_left_surround_filter(M);
    L_right_surround = apply_right_surround_filter(L);
    M_right_surround = apply_right_surround_filter(M);
    
    %% Plus (p**) and minus (m**) opponency channels (p1009)
    L_left  = L_left_center  + M_right_surround;
    L_right = L_right_center + M_left_surround;
    M_left  = M_left_center  + L_right_surround;
    M_right = M_right_center + L_left_surround;
end

function I_out = apply_left_center_filter(I_in)
    filter = left_center() - right_center();
    I_out = on(gaussian(I_in, filter()));
end

function I_out = apply_right_center_filter(I_in)
    filter = right_center() - left_center();
    I_out = on(gaussian(I_in, filter()));
end

function I_out = apply_left_surround_filter(I_in)
    filter = left_surround() - right_surround();
    I_out = on(gaussian(I_in, filter()));
end

function I_out = apply_right_surround_filter(I_in)
    filter = right_surround() - left_surround();
    I_out = on(gaussian(I_in, filter()));
end

function l = left_center()
    l = customgauss([50 50], 10, 2.5, 0, 0, 10, [0 -10]);
end

function l = right_center()
    l = customgauss([50 50], 10, 2.5, 0, 0, 10, [0  10]);
end

function l = left_surround()
    l = customgauss([50 50], 10, 5, 0, 0, 3,    [0 -10]);
end

function l = right_surround()
    l = customgauss([50 50], 10, 5, 0, 0, 3,    [0  10]);
end

function filtered = gaussian(img, filter)
    filtered = imfilter(img, filter, 'same');
end

function I_on = on( I )
    I_on = I;
    I_on(I_on < 0) = 0;
end
