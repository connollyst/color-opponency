function g = center_bottom_right(scale, config)
    g = fliplr(rf.oriented.center_bottom_left(scale, config));
end