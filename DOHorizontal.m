function [L_horizontal, M_horizontal] = DOHorizontal(I, config)
    % Long (red) wavelength orientation opponency..
    L = I(:,:,1);
    L_left_excitatory  = apply_left_excitatory_filter (L, config);
    L_left_inhibitory  = apply_left_inhibitory_filter (L, config);
    L_right_excitatory = apply_right_excitatory_filter(L, config);
    L_right_inhibitory = apply_right_inhibitory_filter(L, config);
    
    % Middle (green) wavelength orientation opponency..
    M = I(:,:,2);
    M_left_excitatory  = apply_left_excitatory_filter (M, config);
    M_left_inhibitory  = apply_left_inhibitory_filter (M, config);
    M_right_excitatory = apply_right_excitatory_filter(M, config);
    M_right_inhibitory = apply_right_inhibitory_filter(M, config);
    
    % Wavelength opponency..
    L_left  = utils.on(L_left_excitatory  + M_right_inhibitory);
    M_left  = utils.on(M_left_excitatory  + L_right_inhibitory);
    L_right = utils.on(L_right_excitatory + M_left_inhibitory);
    M_right = utils.on(M_right_excitatory + L_left_inhibitory);
    
    % Recover all horizontal color opponency..
    L_horizontal = L_left + L_right;
    M_horizontal = M_left + M_right;
end

function I_out = apply_left_excitatory_filter(I_in, config)
    filter = rf.oriented.center_middle_left(config) ...
                - rf.oriented.center_middle_right(config);
    I_out = apply(I_in, filter);
end

function I_out = apply_right_excitatory_filter(I_in, config)
    filter = rf.oriented.center_middle_right(config) ...
                - rf.oriented.center_middle_left(config);
    I_out = apply(I_in, filter);
end

function I_out = apply_left_inhibitory_filter(I_in, config)
    filter = rf.oriented.surround_middle_left(config) ...
                - rf.oriented.surround_middle_right(config);
    I_out = apply(I_in, filter);
end

function I_out = apply_right_inhibitory_filter(I_in, config)
    filter = rf.oriented.surround_middle_right(config) ...
                - rf.oriented.surround_middle_left(config);
    I_out = apply(I_in, filter);
end

function filtered = apply(img, filter)
    filtered = imfilter(img, filter, 'same');
end