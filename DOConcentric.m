function [a, b] = DOConcentric( I, varargin )
%pLGN Parvocellular Lateral Geniculate Nucleus (pLGN) simulation
%   Simulate the parvocellular lateral geniculate nucleus (pLGN) processing
%   of the input color image.
%       I:          the input RGB image
%       'display':  (optional) enabled displaying the channels

    L = I(:,:,1); % Long wavelength:   red
    M = I(:,:,2); % Middle wavelength: green
    Lc = center(L);
    Mc = center(M);
    Ls = surround(L);
    Ms = surround(M);
    
    %% Plus (p**) and minus (m**) opponency channels (p1009)
    a =  Lc - Mc + Ms - Ls;
    b = -Lc + Mc - Ms + Ls;
    
    figure(1), imagesc(a);
    figure(2), imagesc(b);
    
    figure(10), surf(fspecial('gaussian', [ 5  5], 2));
    figure(11), surf(fspecial('gaussian', [20 20], 5));
    
    figure(20), surf(customgauss([5 5], 2, 2, 0, 0, 1, [0 0]));
    figure(21), surf(customgauss([20 20], 5, 5, 0, 0, 1, [0 0]));
end

function Ic = center( I )
    %Ic = gaussian(I, 5, 2);
    Ic = apply_filter(I, customgauss([5 5], 2, 2, 0, 0, 1, [0 0]));
end

function Is = surround( I )
    %Is = gaussian(I, 20, 5);
    Is = apply_filter(I, customgauss([20 20], 5, 5, 0, 0, 1, [0 0]));
end

function filtered = gaussian(I, hsize, sigma)
    filter   = fspecial('gaussian', [hsize hsize], sigma);
    filtered = apply_filter(I, filter);
end

function filtered = apply_filter(I, filter)
    filtered = imfilter(I, filter, 'same');
end