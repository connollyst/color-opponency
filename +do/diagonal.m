function [P_diagonal, S_diagonal] = diagonal(P, S, config)
% 
%   
%   Parameters
%       P: primary color channel
%       S: secondary (opponent) color channel
%
%   Output
%       P_diagonal: the diagonal double opponent components
%       S_diagonal: the diagonal double opponent components

    % Orientation opponency..
    [P_tlc, P_tls, P_trc, P_trs, P_brc, P_brs, P_blc, P_bls] = center_surround(P, config);
    [S_tlc, S_tls, S_trc, S_trs, S_brc, S_brs, S_blc, S_bls] = center_surround(S, config);
    % Wavelength opponency..
    P_tl = utils.on(P_tlc + S_brs);
    P_tr = utils.on(P_trc + S_bls);
    P_bl = utils.on(P_blc + S_trs);
    P_br = utils.on(P_brc + S_tls);
    S_tl = utils.on(S_tlc + P_brs);
    S_tr = utils.on(S_trc + P_bls);
    S_bl = utils.on(S_blc + P_trs);
    S_br = utils.on(S_brc + P_tls);
    % Combine diagonals..
    P_diagonal = P_tl + P_tr + P_br + P_bl;
    S_diagonal = S_tl + S_tr + S_br + S_bl;
end

function [tlc, tls, trc, trs, brc, brs, blc, bls] = center_surround(color, config)
% Returns the top & bottom by left & right, center surrounds.
    tlc = apply_top_left_center_filter      (color, config);
    trc = apply_top_right_center_filter     (color, config);
    tls = apply_top_left_surround_filter    (color, config);
    trs = apply_top_right_surround_filter   (color, config);
    blc = apply_bottom_left_center_filter   (color, config);
    brc = apply_bottom_right_center_filter  (color, config);
    bls = apply_bottom_left_surround_filter (color, config);
    brs = apply_bottom_right_surround_filter(color, config);
end

function I_out = apply_top_left_center_filter(I_in, config)
    filter = rf.oriented.center_top_left(config) ...
                - rf.oriented.center_bottom_right(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_top_right_center_filter(I_in, config)
    filter = rf.oriented.center_top_right(config) ...
                - rf.oriented.center_bottom_left(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_right_center_filter(I_in, config)
    filter = rf.oriented.center_bottom_right(config) ...
                - rf.oriented.center_top_left(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_left_center_filter(I_in, config)
    filter = rf.oriented.center_bottom_left(config) ...
                - rf.oriented.center_top_right(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_top_left_surround_filter(I_in, config)
    filter = rf.oriented.surround_top_left(config) ...
                - rf.oriented.surround_bottom_right(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_top_right_surround_filter(I_in, config)
    filter = rf.oriented.surround_top_right(config) ...
                - rf.oriented.surround_bottom_left(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_right_surround_filter(I_in, config)
    filter = rf.oriented.surround_bottom_right(config) ...
                - rf.oriented.surround_top_left(config);
    I_out = gaussian(I_in, filter());
end

function I_out = apply_bottom_left_surround_filter(I_in, config)
    filter = rf.oriented.surround_bottom_left(config) ...
                - rf.oriented.surround_top_right(config);
    I_out = gaussian(I_in, filter());
end

function filtered = gaussian(img, filter)
    filtered = imfilter(img, filter, 'same');
end