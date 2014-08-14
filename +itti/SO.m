function [R, G, B, Y] = SO(rgb, config)

    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    r_c = center(r, config);
    g_c = center(g, config);
    b_c = center(b, config);
    
    r_s = surround(r, config);
    g_s = surround(g, config);
    b_s = surround(b, config);
    
    % Combine center surround signals to obtain color opponency..
    R = utils.on(r_c - (g_s + b_s)/2);
    G = utils.on(g_c - (r_s + b_s)/2);
    B = utils.on(b_c - (r_s + g_s)/2);
    Y = utils.on((r_c + g_c)/2 - abs(r_s - g_s)/2 - b_s);
    
    figure()
    subplot(4, 2, 1), imshow(rgb);
    subplot(4, 2, 5), imshow(R), colormap('gray'), title('red');
    subplot(4, 2, 6), imshow(G), colormap('gray'), title('green');
    subplot(4, 2, 7), imshow(B), colormap('gray'), title('blue');
    subplot(4, 2, 8), imshow(Y), colormap('gray'), title('yellow');
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