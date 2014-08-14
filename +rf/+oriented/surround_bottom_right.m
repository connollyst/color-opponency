function g = surround_bottom_right(scale, config)
    g = fliplr(rf.oriented.surround_bottom_left(scale, config));
end