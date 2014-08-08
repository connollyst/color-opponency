function g = left_inhibitory(config)
    g = rf.utils.gaussian(                  ...
            [config.size config.size],      ...
            config.inhibition.width,        ...
            config.inhibition.length,       ...
            90, 0,                          ...
            config.inhibition.weight,       ...
            [0 -config.inhibition.offset]   ...
        ) * 0.2;
end
