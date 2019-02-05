function [x, y, v_x, v_y] = lucas_kanade(im1, im2, points)
    if size(im1, 3) > 1
        im1 = rgb2gray(im1);
        im2 = rgb2gray(im2);
    end
    im1 = im2double(im1);
    im2 = im2double(im2);
    
    % if no interest points are given, distribute them evenly in windows of
    % size 15x15
    if nargin < 3
        [m1,n1] = size(im1); 
        R = floor(m1/15) * floor(n1/15);
        points = zeros(R, 2);
        for i = 1:15:m1-14
            for j = 1:15:n1-14
                real_pos = floor(i/15) * floor(m1/15) + ceil(j/15);
                points(real_pos, :) = [i+7, j+7];
            end
        end
    else
        R = size(points, 1);
        
        % pad image for making windows all of the same size
        im1 = pad_image(im1, 7);
        im2 = pad_image(im2, 7);
        
    end
    
    It_m = im1 - im2;
    [Gx, Gy] = imgradientxy(im1);
    
     v_x = zeros(R, 1);
     x = zeros(R, 1);
     v_y = zeros(R, 1);
     y = zeros(R, 1);
    
    for idx = 1:length(points)
       i = points(idx, 1);
       j = points(idx, 2);
       
       if nargin == 3
           % change points values to account for padding
           i = i + 7;
           j = j + 7;
       end
       
       dx = Gx(i-7:i+7, j-7:j+7);
       dy = Gy(i-7:i+7, j-7:j+7);
       % form matrix A and vector b
       A = [dx(:) dy(:)];
       b = reshape(It_m(i-7:i+7, j-7:j+7), [15*15, 1]);
       
       % calculate velocities
       nu = pinv(A'*A) * A' * b; 

       v_x(idx) = nu(1); 
       y(idx) = points(idx, 1);
       v_y(idx) = nu(2);
       x(idx) = points(idx, 2);
       
    end
end
