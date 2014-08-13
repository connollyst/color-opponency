function I_off = off( I )
    I_off = I;
    I_off(I_off > 0) = 0;   % remove all positive values
    I_off = abs(I_off);     % flip negative values to positive
end