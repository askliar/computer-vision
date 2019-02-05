function gcf = demo_matching_points(img1, img2)

    N = 50;

    [f1, f2, matches_all, ~] = keypoint_matching(img1, img2);
    
    sample = randsample(size(matches_all, 2), N);
    matches = matches_all(:, sample);

    gcf = figure; clf;
    
    imshowpair(img1, img2, 'montage');
    axis image off;

    xa = f1(1,matches(1,:));
    xb = f2(1,matches(2,:)) + size(img1,2);
    ya = f1(2,matches(1,:));
    yb = f2(2,matches(2,:));

    hold on;
    h = line([xa; xb], [ya; yb]);
    set(h,'linewidth', 1, 'color', 'r');

    vl_plotframe(f1(:,matches(1,:)));
    f2(1,:) = f2(1,:) + size(img1,2);
    vl_plotframe(f2(:,matches(2,:)));
    axis image off;
    
end