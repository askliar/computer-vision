function demo_lucas_kanade(I1, I2)
    gcf = figure;
    imshow(I1);
    hold on;
    [c, r, v_x, v_y] = lucas_kanade(I1, I2);
    quiver(c, r, v_x, v_y);
end