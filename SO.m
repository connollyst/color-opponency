function [Lon, Loff, Mon, Moff, Son, Soff, Ion, Ioff] = SO(I, config)
%SO Lateral Geniculate Nucleus (LGN) single-opponent (SO) transformation.
%   Transforms the input image in a manner inspired by the single-opponent
%   cells identified in the lateral geniculate nucleus (LGN). The LGN can
%   be subdivided into three independent pathways: the parvocellular
%   (long vs medium wavelength opponency), koniocellular (short vs long &
%   medium wavelength opponency), and magnocellular (brightness vs darkness
%   opponency). All are considered here.
%   
%   Reference:
%       Chalupa & Werner The Visual Neurosciences, Vol 2, p1008 & p1009
%   
%   Parameters:
%       I:      the input RGB image
%       config: struct array of algorithm configuration
%
%   Output:
%       Lon:    incremental long wavelength response (~redness)
%       Loff:   decremental long wavelength response (~greeness)
%       Mon:    incremental medium wavelength response (~redness)
%       Moff:   decremental medium wavelength response (~greeness)
%       Son:    incremental short wavelength response (~blueness)
%       Soff:   decremental short wavelength response (~yellowness)
%       Ion:    incremental intensity response (~brightness)
%       Ioff:   decremental intensity response (~darkness)

    L = I(:,:,1); % Long wavelength:   red
    M = I(:,:,2); % Middle wavelength: green
    S = I(:,:,3); % Short wavelength:  blue
    
    Lc   = center(L, config);
    Mc   = center(M, config);
    Sc   = center(S, config);
    Ls   = surround(L, config);
    Ms   = surround(M, config);
    Ss   = surround(S, config);
    LMs  = (Ls .* Ms) / 2;
    LMSc = (Lc .* Mc .* Sc) / 3;
    LMSs = (Ls .* Ms .* Ss) / 3;
    % Note: no S-surround in biology
    
    % Combine center surround signals to obtain color opponency..
    Lon  = utils.on( Lc - Ms);
    Loff = utils.on(-Lc + Ms);
    Mon  = utils.on( Mc - Ls);
    Moff = utils.on(-Mc + Ls);
    Son  = utils.on( Sc - LMs);
    Soff = utils.on(-Sc + LMs);
    Ion  = utils.on( LMSc - LMSs);
    Ioff = utils.on(-LMSc + LMSs);
    if utils.do_show(config)
        utils.show_figure(1, 'Lon',  Lon);
        utils.show_figure(2, 'Loff', Loff);
        utils.show_figure(3, 'Mon',  Mon);
        utils.show_figure(4, 'Moff', Moff);
        utils.show_figure(5, 'Son',  Son);
        utils.show_figure(6, 'Soff', Soff);
        utils.show_figure(7, 'Ion',  Ion);
        utils.show_figure(8, 'Ioff', Ioff);
    end
end

function Ic = center(I, config)
    Ic = imfilter(I, rf.center(config), 'same');
end

function Is = surround(I, config)
    Is = imfilter(I, rf.surround(config), 'same');
end
