function show_figure(index, name, I)
%SHOW_FIGURE Summary of this function goes here
%   Detailed explanation goes here
    f = figure(index);
    set(f, 'name', name);
    set(f, 'Color', [1 1 1]);
    imagesc(I);
end

