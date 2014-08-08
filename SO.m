function [Lon, Loff, Mon, Moff, Son, Soff] = SO(I, config)
%SO Lateral Geniculate Nucleus (LGN) single-opponent (SO) transformation.
%   Transforms the input image in a manner inspired by the single-opponent
%   cells identified in the parvocellular and koniocellular lateral
%   geniculate nucleus (pLGN).
%   Reference: Chalupa & Werner The Visual Neurosciences, Vol 2, p1009
%       I:      the input RGB image
%       config: struct array of algorithm configuration

    L   = I(:,:,1); % Long wavelength:   red
    M   = I(:,:,2); % Middle wavelength: green
    S   = I(:,:,3); % Short wavelength:  blue
    
    Lc  = center(L, config);
    Mc  = center(M, config);
    Sc  = center(S, config);
    Ls  = surround(L, config);
    Ms  = surround(M, config);
    LMs = Ls .* Ms;
    % Note: no S-surround in biology
    
    % Residuals account for information not in centers & surrounds
    Lr = L - Lc - Ls;
    Mr = M - Mc - Ms;
    Sr = S - Sc;
    
    % Combine center surround signals to obtain color opponency..
    Lon  = utils.on( Lc - Ms);
    Loff = utils.on(-Lc + Ms);
    Mon  = utils.on( Mc - Ls);
    Moff = utils.on(-Mc + Ls);
    Son  = utils.on( Sc - LMs);
    Soff = utils.on(-Sc + LMs);
    if utils.do_show(config)
        utils.show_figure(1, 'Lon',  Lon);
        utils.show_figure(2, 'Loff', Loff);
        utils.show_figure(3, 'Mon',  Mon);
        utils.show_figure(4, 'Moff', Moff);
        utils.show_figure(5, 'Son',  Son);
        utils.show_figure(6, 'Soff', Soff);
    end
end

function Ic = center(I, config)
    Ic = imfilter(I, rf.center(config), 'same');
end

function Is = surround(I, config)
    Is = imfilter(I, rf.surround(config), 'same');
end
