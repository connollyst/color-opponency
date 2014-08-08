function [L_left, L_right, M_left, M_right] = DOHorizontal( I, config )
    % Long (red) wavelength orientation opponency..
    L = I(:,:,1);
    L_left_excitatory  = apply_left_excitatory_filter(  L, config );
    L_left_inhibitory  = apply_left_inhibitory_filter(  L, config );
    L_right_excitatory = apply_right_excitatory_filter( L, config );
    L_right_inhibitory = apply_right_inhibitory_filter( L, config );
    
    % Middle (green) wavelength orientation opponency..
    M = I(:,:,2);
    M_left_excitatory  = apply_left_excitatory_filter(  M, config );
    M_left_inhibitory  = apply_left_inhibitory_filter(  M, config );
    M_right_excitatory = apply_right_excitatory_filter( M, config );
    M_right_inhibitory = apply_right_inhibitory_filter( M, config );
    
    % Wavelength opponency..
    L_left  = utils.on(L_left_excitatory  + M_right_inhibitory);
    M_left  = utils.on(M_left_excitatory  + L_right_inhibitory);
    L_right = utils.on(L_right_excitatory + M_left_inhibitory);
    M_right = utils.on(M_right_excitatory + L_left_inhibitory);
end

function I_out = apply_left_excitatory_filter(I_in, config)
    filter = rf.left_excitatory(config) - rf.right_excitatory(config);
    I_out = apply(I_in, filter);
end

function I_out = apply_right_excitatory_filter(I_in, config)
    filter = rf.right_excitatory(config) - rf.left_excitatory(config);
    I_out = apply(I_in, filter);
end

function I_out = apply_left_inhibitory_filter(I_in, config)
    filter = rf.left_inhibitory(config) - rf.right_inhibitory(config);
    I_out = apply(I_in, filter);
end

function I_out = apply_right_inhibitory_filter(I_in, config)
    filter = rf.right_inhibitory(config) - rf.left_inhibitory(config);
    I_out = apply(I_in, filter);
end

function filtered = apply(img, filter)
    filtered = imfilter(img, filter, 'same');
end