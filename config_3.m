function config = config_3
    config.size              = 50;
    config.center.size       = 5;
    config.center.sigma      = 2;
    config.surround.size     = 20;
    config.surround.sigma    = 5;
    config.excitation.weight = 0.5;
    config.excitation.length = 1;
    config.excitation.width  = 0.5;
    config.excitation.offset = 5;
    config.inhibition.weight = 0.5;
    config.inhibition.length = 1;
    config.inhibition.width  = 0.5;
    config.inhibition.offset = 5;
    config.wave.n_scales     = 2;
end