function g = center_top_middle(config)
    g = rf.oriented.center(                 ...
            config,                         ...
            0,                              ...
            [-config.excitation.offset 0]   ...
        );
end