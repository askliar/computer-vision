function demo_harris(I, K, sigma, threshold, N)
    [~, r, c] = harris_corner_detector(I, K, sigma, threshold, N);
    gcf = figure;
    imshow(I);
    hold on;
    
    s = scatter(c, r, 20, 'r');
    s.LineWidth = 0.6;
    s.MarkerEdgeColor = 'r';
    s.MarkerFaceColor = [1 0 0];
end