function [pLo, mLo, pMo, mMo, pSo, mSo] = pLGN( I, varargin )
%pLGN Parvocellular Lateral Geniculate Nucleus (pLGN) simulation
%   Simulate the parvocellular lateral geniculate nucleus (pLGN) processing
%   of the input color image.
%       I:          the input RGB image
%       'display':  (optional) enabled displaying the channels

    L = I(:,:,1); % Long wavelength:   red
    M = I(:,:,2); % Middle wavelength: green
    S = I(:,:,3); % Short wavelength:  blue
    Lc = center(L);
    Mc = center(M);
    Sc = center(S);
    Ls = surround(L);
    Ms = surround(M);
    Ss = surround(S);   % TODO any reference to short surround in lit?
    
    %% Plus (p**) and minus (m**) opponency channels (p1009)
    pLo =  Lc - Ms;
    mLo = -Lc + Ms;
    pMo =  Mc - Ls;
    mMo = -Mc + Ls;
    LMs =  Ls .* Ms;
    pSo =  Sc - LMs;
    mSo = -Sc + LMs;
    if utils.do_show(varargin{:})
        utils.show_figure(1, 'pLo', pLo);
        utils.show_figure(2, 'mLo', mLo);
        utils.show_figure(3, 'pMo', pMo);
        utils.show_figure(4, 'mMo', mMo);
        utils.show_figure(5, 'pSo', pSo);
        utils.show_figure(6, 'mSo', mSo);
        utils.show_figure(7, 'LMs', LMs);
    end
end

function Ic = center( I )
    Ic = gaussian(I, 5, 2);
end

function Is = surround( I )
    Is = gaussian(I, 20, 5);
end

function filtered = gaussian( img, hsize, sigma)
    filter   = fspecial('gaussian', [hsize hsize], sigma);
    filtered = imfilter(img, filter, 'same');
end
