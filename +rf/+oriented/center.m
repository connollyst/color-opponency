function g = excitatory(config, angle, offset)
    g = rf.utils.gaussian(              ...
            [config.size config.size],  ...
            config.excitation.width,    ...
            config.excitation.length,   ...
            angle, 0,                   ...
            config.excitation.weight,	...
            offset                      ...
        );
end
