function [R, G, B, Y] = SO(rgb, config)

    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    i = (r + g + b)/3;
    
    r_c = center(r, config);
    g_c = center(g, config);
    b_c = center(b, config);
    i_c = center(i, config);
    r_c = normalize(r_c, i_c);
    g_c = normalize(g_c, i_c);
    b_c = normalize(b_c, i_c);
    
    r_s = surround(r, config);
    g_s = surround(g, config);
    b_s = surround(b, config);
    i_s = surround(i, config);
    r_s = normalize(r_s, i_s);
    g_s = normalize(g_s, i_s);
    b_s = normalize(b_s, i_s);
    
    % Combine center surround signals to obtain color opponency..
    I = i_c - i_s;  % TODO lightness/darkness?
    R = utils.on(r_c - (g_s + b_s)/2);
    G = utils.on(g_c - (r_s + b_s)/2);
    B = utils.on(b_c - (r_s + g_s)/2);
    Y = utils.on((r_c + g_c)/2 - abs(r_s - g_s)/2 - b_s);
    
    figure()
    subplot(3, 2, 1), imshow(rgb);
    subplot(3, 2, 2), imagesc(I), colormap('gray'), title('intensity');
    subplot(3, 2, 3), imagesc(R), colormap('gray'), title('red');
    subplot(3, 2, 4), imagesc(G), colormap('gray'), title('green');
    subplot(3, 2, 5), imagesc(B), colormap('gray'), title('blue');
    subplot(3, 2, 6), imagesc(Y), colormap('gray'), title('yellow');
end

function Ic = center(I, config)
    Ic = gaussian(I, rf.center(config));
end

function Is = surround(I, config)
    Is = gaussian(I, rf.surround(config));
end

function filtered = gaussian(img, filter)
    % Add padding
    pad_cols = ceil(size(img,1)/2);
    pad_rows = ceil(size(img,2)/2);
    padded   = padarray(img, [pad_cols, pad_rows], 'symmetric','both');
    % Apply filter
    padded_filtered = imfilter(padded, filter, 'same');
    % Remove padding
    cols = pad_cols+1:pad_cols+size(img,1);
    rows = pad_rows+1:pad_rows+size(img,2);
    filtered = padded_filtered(cols,rows);
end

function n = normalize(channel, I)
% Normalize channel (r, g, or b) by I.
%   Note, unlike in Itti 1998, we normalize values at low luminance also.
    n = channel./I;
end