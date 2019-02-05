function [output_image] = rgb2grays(input_image, method)
[R, G, B] = getColorChannels(input_image);

% converts an RGB into grayscale by using 4 different methods
% lightness method
if strcmp(method, 'lightness')
    output_image = (max(max(R, G), B) + min(min(R, G), B)) ./ 2;
% average method
elseif strcmp(method, 'average')
    output_image = (R + G + B) ./ 3;
% luminosity method
elseif strcmp(method, 'luminosity')
    output_image =  0.21*R + 0.72*G + 0.07*B;
% built-in MATLAB function 
elseif strcmp(method, 'matlab')
    output_image = rgb2gray(input_image);
end
end

