function plot_file(filepath)
    points = load(filepath);
    scatter3(points(:, 1), points(:, 2), points(:, 3), 5);
end