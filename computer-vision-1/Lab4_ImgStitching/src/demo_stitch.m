function stitched_image = demo_stitch(img1, img2)
    [f1, f2, matches, ~] = keypoint_matching(img1, img2);
    
    confidence = 0.99;
    
    [M, T] = ransac(f1, f2, matches, confidence);
    [~, new_x_grid, new_y_grid] = transform_image(img1, M, T);
    stitched_image = stitch_images(img2, img1, new_x_grid, new_y_grid, T);
    
    figure; clf;
    subplot(2,2,1), imshow(img2), title('Original image');
    subplot(2,2,2), imshow(img1), title('Image to be transformed');
    subplot(2,2,3:4), imshow(stitched_image), title('Stitched image');
    
end