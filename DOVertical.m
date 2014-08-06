function [L_top, L_bottom, M_top, M_bottom] = DOVertical( I, config )
    % Long (red) wavelength orientation opponancy..
    L = I(:,:,1);
    L_top_center      = apply_top_center_filter     ( L, config );
    L_top_surround    = apply_top_surround_filter   ( L, config );
    L_bottom_center   = apply_bottom_center_filter  ( L, config );
    L_bottom_surround = apply_bottom_surround_filter( L, config );
    
    % Middle (green) wavelength orientation opponancy..
    M = I(:,:,2);
    M_top_center      = apply_top_center_filter     ( M, config );
    M_top_surround    = apply_top_surround_filter   ( M, config );
    M_bottom_center   = apply_bottom_center_filter  ( M, config );
    M_bottom_surround = apply_bottom_surround_filter( M, config );
    
    % Wavelength opponancy..
    L_top    = on(L_top_center    + M_bottom_surround);
    M_top    = on(M_top_center    + L_bottom_surround);
    L_bottom = on(L_bottom_center + M_top_surround);
    M_bottom = on(M_bottom_center + L_top_surround);
end

function I_out = apply_top_center_filter(I_in, config)
    filter = top_center(config) - bottom_center(config);
    I_out = on(gaussian(I_in, filter()));
end

function I_out = apply_bottom_center_filter(I_in, config)
    filter = bottom_center(config) - top_center(config);
    I_out = on(gaussian(I_in, filter()));
end

function I_out = apply_top_surround_filter(I_in, config)
    filter = top_surround(config) - bottom_surround(config);
    I_out = on(gaussian(I_in, filter()));
end

function I_out = apply_bottom_surround_filter(I_in, config)
    filter = bottom_surround(config) - top_surround(config);
    I_out = on(gaussian(I_in, filter()));
end

function l = top_center(config)
    l = customgauss( ...
        [config.size config.size], ...
        config.excitation.width, ...
        config.excitation.length, ...
        0, 0, ...
        config.excitation.weight, ...
        [-config.excitation.offset 0]);
end

function l = bottom_center(config)
    l = customgauss( ...
        [config.size config.size], ...
        config.excitation.width, ...
        config.excitation.length, ...
        0, 0, ...
        config.excitation.weight, ...
        [config.excitation.offset 0]);
end

function l = top_surround(config)
    l = customgauss( ...
        [config.size config.size], ...
        config.inhibition.width, ...
        config.inhibition.length, ...
        0, 0, ...
        config.inhibition.weight, ...
        [-config.inhibition.offset 0]);
end

function l = bottom_surround(config)
    l = customgauss( ...
        [config.size config.size], ...
        config.inhibition.width, ...
        config.inhibition.length, ...
        0, 0, ...
        config.inhibition.weight, ...
        [config.inhibition.offset 0]);
end

function filtered = gaussian(img, filter)
    filtered = imfilter(img, filter, 'same');
end

function I_on = on( I )
    I_on = I;
    I_on(I_on < 0) = 0;
end
