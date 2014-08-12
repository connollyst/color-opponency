function [R, G, B, Y] = SO(I, config)

    L = I(:,:,1); % Long wavelength:   red
    M = I(:,:,2); % Middle wavelength: green
    S = I(:,:,3); % Short wavelength:  blue
    
    Lc   = center(L, config);
    Mc   = center(M, config);
    Sc   = center(S, config);
    Ls   = surround(L, config);
    Ms   = surround(M, config);
    Ss   = surround(S, config);
    
    % Combine center surround signals to obtain color opponency..
    R = utils.on(Lc - (Ms + Ss)/2);
    G = utils.on(Mc - (Ls + Ss)/2);
    B = utils.on(Sc - (Ls + Ms)/2);
    Y = utils.on((Lc + Mc)/2 - abs(Ls - Ms)/2 - Ss);
    
    figure(1), imagesc(I)
    figure(2), imagesc(R)
    figure(3), imagesc(G)
    figure(4), imagesc(B)
    figure(5), imagesc(Y)
end

function Ic = center(I, config)
    Ic = imfilter(I, rf.center(config), 'same');
end

function Is = surround(I, config)
    Is = imfilter(I, rf.surround(config), 'same');
end
