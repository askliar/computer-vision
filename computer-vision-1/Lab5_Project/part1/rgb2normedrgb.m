function [output_image] = rgb2normedrgb(input_image)
    % converts an RGB image into normalized rgb
    [R, G, B] = get_color_channels(input_image);
    output_image = cat(3, R./(R+G+B), G./(R+G+B), B./(R+G+B));
end

