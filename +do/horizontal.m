function [L_horizontal, M_horizontal] = horizontal(I, config)
    L = I(:,:,1);
    M = I(:,:,2);
    L_left  = get_left(L, M, config);
    M_left  = get_left(M, L, config);
    L_right = get_right(L, M, config);
    M_right = get_right(M, L, config);
    L_horizontal = L_left + L_right;
    M_horizontal = M_left + M_right;
end

function left = get_left(on, off, config)
    % Orientation opponency..
    left_excitatory = apply_left_excitatory_filter(on, config);
    right_inhibitory = apply_right_inhibitory_filter(off, config);
    % Wavelength opponency..
    % TODO shouldn't this be minus?
    left = utils.on(left_excitatory  + right_inhibitory);
end

function right = get_right(on, off, config)
    % Orientation opponency..
    right_excitatory = apply_right_excitatory_filter(on, config);
    left_inhibitory  = apply_left_inhibitory_filter (off, config);
    % Wavelength opponency..
    % TODO shouldn't this be minus?
    right = utils.on(right_excitatory + left_inhibitory);
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