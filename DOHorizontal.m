function [L_left, L_right, M_left, M_right] = DOHorizontal( I, config )
    % Long (red) wavelength orientation opponency..
    L = I(:,:,1);
    L_left_center    = apply_left_center_filter   ( L, config );
    L_left_surround  = apply_left_surround_filter ( L, config );
    L_right_center   = apply_right_center_filter  ( L, config );
    L_right_surround = apply_right_surround_filter( L, config );
    
    % Middle (green) wavelength orientation opponency..
    M = I(:,:,2);
    M_left_center    = apply_left_center_filter   ( M, config );
    M_left_surround  = apply_left_surround_filter ( M, config );
    M_right_center   = apply_right_center_filter  ( M, config );
    M_right_surround = apply_right_surround_filter( M, config );
    
    % Wavelength opponency..
    L_left  = utils.on(L_left_center  + M_right_surround);
    M_left  = utils.on(M_left_center  + L_right_surround);
    L_right = utils.on(L_right_center + M_left_surround);
    M_right = utils.on(M_right_center + L_left_surround);
end

function I_out = apply_left_center_filter(I_in, config)
    filter = rf.left_excitatory(config) - rf.right_excitatory(config);
    I_out = gaussian(I_in, filter);
end

function I_out = apply_right_center_filter(I_in, config)
    filter = rf.right_excitatory(config) - rf.left_excitatory(config);
    I_out = gaussian(I_in, filter);
end

function I_out = apply_left_surround_filter(I_in, config)
    filter = rf.left_inhibitory(config) - rf.right_inhibitory(config);
    I_out = gaussian(I_in, filter);
end

function I_out = apply_right_surround_filter(I_in, config)
    filter = rf.right_inhibitory(config) - rf.left_inhibitory(config);
    I_out = gaussian(I_in, filter);
end

function filtered = gaussian(img, filter)
    filtered = imfilter(img, filter, 'same');
end