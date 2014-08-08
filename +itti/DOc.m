function ABcs = DOc(A, B, c, s)
%DOC Double Opponent (Concentric)
%   A: the first opponent color channel  (R or B according to L. Itti, 1998)
%   B: the second opponent color channel (G or Y according to L. Itti, 1998)
%   c: the center scale   (2, 3, 4 according to L. Itti, 1998)
%   s: the surround scale (c + {3, 4} according to L. Itti, 1998)

    Ac = center(A, c);
    Bc = center(B, c);
    As = surround(A, s);
    Bs = surround(B, s);
    ABcs = (Ac - Bc) - (Bs - As);
    ABcs = utils.on(ABcs);  % TODO abs() in paper.. what do we want?
end

function Xc = center(X, c)
    % TODO implement
    Xc = gaussian(X, c, 2);
end

function Xs = surround(X, s)
    % TODO implement
    Xs = gaussian(X, s, 5);
end

function filtered = gaussian(img, hsize, sigma)
    filter   = fspecial('gaussian', [hsize hsize], sigma);
    filtered = imfilter(img, filter, 'same');
end
