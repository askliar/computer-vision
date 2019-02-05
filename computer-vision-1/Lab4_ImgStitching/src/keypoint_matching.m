function [f1, f2, matches, scores] = keypoint_matching(I1, I2)

    if size(I1, 3) > 1
        I1 = rgb2gray(I1);
    end
    if size(I2, 3) > 1
        I2 = rgb2gray(I2);
    end
    
    I1 = single(I1);
    I2 = single(I2);
    
    [f1, d1] = vl_sift(I1);
    [f2, d2] = vl_sift(I2);
    [matches, scores] = vl_ubcmatch(d1, d2);
end