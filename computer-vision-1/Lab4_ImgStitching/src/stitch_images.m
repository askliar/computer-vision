function [stitched_image] = stitch_images(target_image, old_image, x_grid, y_grid, T)
    n_channels = size(old_image, 3);
    
    % if T coordinate is negative, we have to shift original image 
    % otherwise, we have to shift transformed image (we use x_neg_shift and y_neg_shift for these)
    % depending on T, we can define size of the final image for each coordinate as following:
    % if T is negative, size of the final image would be size of target image
    % if T is positive, size of the final image would be a maximum coordinate of the transformed image
    if T(1) < 0
        x_neg_shift = round(abs(T(1))) + 1;
        x_size = size(target_image, 2);
    else
        x_neg_shift = 0;
        x_size = max(max(x_grid));
    end

    if T(2) < 0
        y_neg_shift = round(abs(T(2))) + 1;
        y_size = size(target_image, 1);
    else
        y_neg_shift = 0;
        y_size = max(max(y_grid));
    end
    
    stitched_image = zeros(y_size, x_size, n_channels);

    for y = 1:size(old_image, 1)
        for x = 1:size(old_image, 2)
            p_y = y_grid(y, x);
            p_x = x_grid(y, x);
            if (y_neg_shift + p_y) > 0 && (x_neg_shift + p_x) > 0
                % project points from the old image to the final image space
                stitched_image(y_neg_shift + p_y, x_neg_shift + p_x, :) = old_image(y, x, :);
            end
        end
    end
    
    for y = 1:size(target_image, 1)
        for x = 1:size(target_image, 2)
            % project points from the target image to the final image space
            stitched_image(y_neg_shift + y, x_neg_shift + x, :) = target_image(y, x, :);
        end
    end
    
    stitched_image = interpolate(stitched_image);
end