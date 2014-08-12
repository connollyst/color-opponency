function g = surround_bottom_right(config)
    g = fliplr(rf.oriented.surround_bottom_left(config));
end