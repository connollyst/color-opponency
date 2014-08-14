function [wavelets, residuals] = DOo(I, config)
%DOO Double opponent (Oriented) decomposition.
    cols     = size(I, 1);
    rows     = size(I, 2);
    channels = 4;     % RGBY
    scales   = config.wave.n_scales;
    
    wavelets   = zeros(cols, rows, channels, scales, 3);
    residuals  = zeros(cols, rows, channels, scales);
    
    wavelets(:,:,:,:,1) = itti.DOHorizontal(I, config);
    wavelets(:,:,:,:,2) = itti.DODiagonal(I, config);
    wavelets(:,:,:,:,3) = itti.DOVertical(I, config);
    
    % TODO can we get residuals? what about Y?
end