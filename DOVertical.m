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
    L_top    = utils.on(L_top_center    + M_bottom_surround);
    M_top    = utils.on(M_top_center    + L_bottom_surround);
    L_bottom = utils.on(L_bottom_center + M_top_surround);
    M_bottom = utils.on(M_bottom_center + L_top_surround);
end

function I_out = apply_top_center_filter(I_in, config)
    filter = rf.top_excitatory(config) - rf.bottom_excitatory(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_center_filter(I_in, config)
    filter = rf.bottom_excitatory(config) - rf.top_excitatory(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_top_surround_filter(I_in, config)
    filter = rf.top_inhibitory(config) - rf.bottom_inhibitory(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_surround_filter(I_in, config)
    filter = rf.bottom_inhibitory(config) - rf.top_inhibitory(config);
    I_out = gaussian(I_in, filter());
end

function filtered = gaussian(img, filter)
    filtered = imfilter(img, filter, 'same');
end