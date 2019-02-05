function [R, G, B] = get_color_channels(input_image)
	% helper function that seperates an image into its color channels
	R = input_image(:,:,1);
	G = input_image(:,:,2);
	B = input_image(:,:,3);
end

