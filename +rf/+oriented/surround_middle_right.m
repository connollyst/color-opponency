function g = surround_middle_right(scale, config)
    g = fliplr(rf.oriented.surround_middle_left(scale, config));
end