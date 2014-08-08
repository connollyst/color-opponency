function g = right_excitatory(config)
    g = rf.utils.gaussian(                  ...
            [config.size config.size],      ...
            config.excitation.width,        ...
            config.excitation.length,       ...
            90, 0,                          ...
            config.excitation.weight,       ...
            [0 config.excitation.offset]    ...
        );
end

