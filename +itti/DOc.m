function ABcs = DOc(A, B, c, s, w)
%DOC Double Opponent (Concentric)
%   A: the first opponent color channel  (R or B according to L. Itti, 1998)
%   B: the second opponent color channel (G or Y according to L. Itti, 1998)
%   c: the center scale   (2, 3, 4 according to L. Itti, 1998)
%   s: the surround scale (c + {3, 4} according to L. Itti, 1998)
%   w: the weight (not used by Itti) translates to the Gaussian sigma for
%      both center and surround. Useful values tend to be around 5 to 10.
    Ac = center(A, c, w);
    Bc = center(B, c, w);
    As = surround(A, s, w);
    Bs = surround(B, s, w);
    ABcs = abs((Ac - Bc) - (Bs - As));
end

function Xc = center(X, c, w)
    Xc = gaussian(X, c^2, w);
end

function Xs = surround(X, s, w)
    Xs = gaussian(X, s^2, w);
end

function filtered = gaussian(img, hsize, sigma)
    filter   = fspecial('gaussian', [hsize hsize], sigma);
    filtered = imfilter(img, filter, 'same');
end