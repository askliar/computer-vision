function transformed_image = demo_transform(img1, img2)


    [f1, f2, matches, ~] = keypoint_matching(img1, img2);
    
    confidence = 0.99;
    [M, T] = ransac(f1, f2, matches, confidence);
    [transformed_image, ~, ~] = transform_image(img1, M, T);
    
    figure; clf;
    imshow(transformed_image);
    
end