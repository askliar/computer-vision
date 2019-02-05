function [new_image, new_x_grid, new_y_grid] = transform_image(image, M, T)
    [m, n, n_channels] = size(image);
    
    x_grid = meshgrid(1:n,1:m);
    y_grid = meshgrid(1:m,1:n)';
    
    % apply affine transformation to x_grid and y_grid
    new_x_grid = int16(M(1,1) .* x_grid + M(1, 2) .* y_grid + T(1));
    new_y_grid = int16(M(2,1) .* x_grid + M(2, 2) .* y_grid + T(2));
    
    min_x = min(min(new_x_grid));
    min_y = min(min(new_y_grid));
    
    % shift x and y coordinates for plotting purposes,
    % making x and y grid initial coordinates start from (1,1)
    shifted_x_grid = new_x_grid + (1 - min_x);
    shifted_y_grid = new_y_grid + (1 - min_y);
    
    % find max_x and max_y to get size of the final image
    max_x = max(max(shifted_x_grid));
    max_y = max(max(shifted_y_grid));

    new_image = zeros(max_y, max_x, n_channels);
    
    for y = 1:m
        for x = 1:n
            % project points from the old image to the new image space
            new_image(shifted_y_grid(y, x), shifted_x_grid(y, x), :) = image(y, x, :);
        end
    end
    
    new_image = interpolate(new_image);
end