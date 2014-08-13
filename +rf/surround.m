function g = surround(config)
    g = fspecial('gaussian',                                ...
            [config.surround.size config.surround.size],    ...
            config.surround.sigma                           ...
        ) * 0.95;   % Lennie & Haake
end