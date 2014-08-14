function [R, G, B, Y] = SO(rgb, config)

    rgb = im2double(rgb);
    
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);
    
    for scale=1:config.wave.n_scales
        r_c = center(r, scale, config);
        g_c = center(g, scale, config);
        b_c = center(b, scale, config);

        r_s = surround(r, scale, config);
        g_s = surround(g, scale, config);
        b_s = surround(b, scale, config);

        % Combine center surround signals to obtain color opponency..
        R = utils.on(r_c - (g_s + b_s)/2);
        G = utils.on(g_c - (r_s + b_s)/2);
        B = utils.on(b_c - (r_s + g_s)/2);
        Y = utils.on((r_c + g_c)/2 - abs(r_s - g_s)/2 - b_s);

        figure(1)
        subplot(2, 2, 1), imshow(R), title('red');
        subplot(2, 2, 2), imshow(G), title('green');
        subplot(2, 2, 3), imshow(B), title('blue');
        subplot(2, 2, 4), imshow(Y), title('yellow');
        waitforbuttonpress;
    end
end

function Ic = center(I, scale, config)
    Ic = gaussian(I, rf.center(scale, config));
end

function Is = surround(I, scale, config)
    Is = gaussian(I, rf.surround(scale, config));
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