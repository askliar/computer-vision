function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)

sobelX = [1,0,-1; 2, 0, -2; 1,0,-1];
sobelY = [1,2,1; 0, 0, 0; -1,-2,-1];

Gx = imfilter(image,sobelX);
Gy = imfilter(image,sobelY);

im_magnitude = sqrt(Gx.^2 + Gy.^2);
im_direction = atan2(Gy, Gx);

end

