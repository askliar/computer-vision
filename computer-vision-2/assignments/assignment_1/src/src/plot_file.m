function plot_file(filepath)
    points = load(filepath);
    points = points.points;
    fscatter3(points(:,1),points(:,2),points(:,3),1:size(points,1));
end