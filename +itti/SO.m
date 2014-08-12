function [R, G, B, Y] = SO(img, config)

    img = im2double(img);
    
    L = img(:,:,1); % Long wavelength:   red
    M = img(:,:,2); % Middle wavelength: green
    S = img(:,:,3); % Short wavelength:  blue
    I = (L + M + S)/3;
    
    
    Lc = center(L, config);
    Mc = center(M, config);
    Sc = center(S, config);
    Ic = center(I, config);
    Lc = normalize(Lc, Ic);
    Mc = normalize(Mc, Ic);
    Sc = normalize(Sc, Ic);
    
    Ls = surround(L, config);
    Ms = surround(M, config);
    Ss = surround(S, config);
    Is = surround(I, config);
    Ls = normalize(Ls, Is);
    Ms = normalize(Ms, Is);
    Ss = normalize(Ss, Is);
    
    % Combine center surround signals to obtain color opponency..
    I = Ic - Is;
    R = utils.on(Lc - (Ms + Ss)/2);
    G = utils.on(Mc - (Ls + Ss)/2);
    B = utils.on(Sc - (Ls + Ms)/2);
    Y = utils.on((Lc + Mc)/2 - abs(Ls - Ms)/2 - Ss);
    
    figure()
    subplot(3, 2, 1), imshow(img);
    subplot(3, 2, 2), imagesc(I), colormap('gray'), title('intensity');
    subplot(3, 2, 3), imagesc(R), colormap('gray'), title('red');
    subplot(3, 2, 4), imagesc(G), colormap('gray'), title('green');
    subplot(3, 2, 5), imagesc(B), colormap('gray'), title('blue');
    subplot(3, 2, 6), imagesc(Y), colormap('gray'), title('yellow');
end

function Ic = center(I, config)
    Ic = imfilter(I, rf.center(config), 'same');
end

function Is = surround(I, config)
    Is = imfilter(I, rf.surround(config), 'same');
end

function n = normalize(channel, I)
% Normalize channel (r, g, or b) by I.
%   Note, unlike in Itti 1998, we normalize values at low luminance also.
    n = channel./I;
end