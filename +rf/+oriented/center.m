function g = center(scale, config, angle, offset)
    g = rf.utils.gaussian(                      ...
            [config.size config.size],          ...
            (config.excitation.width  * scale) ^ 2,   ...
            (config.excitation.length * scale) ^ 2,   ...
            angle, 0,                           ...
            config.excitation.weight,           ...
            offset                              ...
        );
end