function new_image = interpolate(img)

    [m, n, n_channels] = size(img);
    intersection_coords = sum(img, 3);
    
    % get only black points
    zero_coords = find(intersection_coords == 0);
    [I,J] = ind2sub([m,n], zero_coords);

    % color mask for final image
    % using a mask, because otherwise, when we do in-place replacement,
    % at some point, image would just be copying the last pixels, because
    % they won't be just empty thus black anymore
    new_image_mask = zeros(m, n, n_channels);
    for i=1:length(I)
        y = I(i);
        x = J(i);
        % get a window around target pixel
        window = img(max(y-2, 1):min(y+2, m), max(x-2, 1):min(x+2, n), :);
        % replace pixel value with the mean of the window
        new_image_mask(y, x,:) = mean(mean(window));
    end
    
    % put image mask to the final image
    new_image = img + new_image_mask;

end