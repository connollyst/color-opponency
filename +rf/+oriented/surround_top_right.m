function g = surround_top_right(scale, config)
    g = fliplr(rf.oriented.surround_top_left(scale, config));
end