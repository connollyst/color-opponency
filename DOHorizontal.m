function [L_left, L_right, M_left, M_right] = DOHorizontal( I, config )
    % Long (red) wavelength orientation opponancy..
    L = I(:,:,1);
    L_left_center    = apply_left_center_filter   ( L, config );
    L_left_surround  = apply_left_surround_filter ( L, config );
    L_right_center   = apply_right_center_filter  ( L, config );
    L_right_surround = apply_right_surround_filter( L, config );
    
    % Middle (green) wavelength orientation opponancy..
    M = I(:,:,2);
    M_left_center    = apply_left_center_filter   ( M, config );
    M_left_surround  = apply_left_surround_filter ( M, config );
    M_right_center   = apply_right_center_filter  ( M, config );
    M_right_surround = apply_right_surround_filter( M, config );
    
    % Wavelength opponancy..
    L_left  = on(L_left_center  + M_right_surround);
    M_left  = on(M_left_center  + L_right_surround);
    L_right = on(L_right_center + M_left_surround);
    M_right = on(M_right_center + L_left_surround);
end

function I_out = apply_left_center_filter(I_in, config)
    filter = left_center(config) - right_center(config);
    I_out = gaussian(I_in, filter);
end

function I_out = apply_right_center_filter(I_in, config)
    filter = right_center(config) - left_center(config);
    I_out = gaussian(I_in, filter);
end

function I_out = apply_left_surround_filter(I_in, config)
    filter = left_surround(config) - right_surround(config);
    I_out = gaussian(I_in, filter);
end

function I_out = apply_right_surround_filter(I_in, config)
    filter = right_surround(config) - left_surround(config);
    I_out = gaussian(I_in, filter);
end

function l = left_center(config)
    l = customgauss( ...
        [config.size config.size], ...
        config.excitation.width, ...
        config.excitation.length, ...
        90, 0, ...
        config.excitation.weight, ...
        [0 -config.excitation.offset]);
end

function l = right_center(config)
    l = customgauss( ...
        [config.size config.size], ...
        config.excitation.width, ...
        config.excitation.length, ...
        90, 0, ...
        config.excitation.weight, ...
        [0 config.excitation.offset]);
end

function l = left_surround(config)
    l = customgauss( ...
        [config.size config.size], ...
        config.inhibition.width, ...
        config.inhibition.length, ...
        90, 0, ...
        config.inhibition.weight, ...
        [0 -config.inhibition.offset]);
end

function l = right_surround(config)
    l = customgauss( ...
        [config.size config.size], ...
        config.inhibition.width, ...
        config.inhibition.length, ...
        90, 0, ...
        config.inhibition.weight, ...
        [0 config.inhibition.offset]);
end

function filtered = gaussian(img, filter)
    filtered = imfilter(img, filter, 'same');
end

function I_on = on( I )
    I_on = I;
    I_on(I_on < 0) = 0;
end
