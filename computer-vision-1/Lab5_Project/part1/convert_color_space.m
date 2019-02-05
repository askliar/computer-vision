function [new_image] = convert_color_space(input_image, colorspace)
    if size(input_image, 3) > 1
        if strcmp(colorspace, 'opponent')
            new_image = rgb2opponent(input_image);
        elseif strcmp(colorspace, 'rgb')  
            new_image = rgb2normedrgb(input_image);
        elseif strcmp(colorspace, 'hsv')   
            new_image = rgb2hsv(input_image);
        elseif strcmp(colorspace, 'ycbcr')
            new_image = rgb2ycbcr(input_image);
        elseif strcmp(colorspace, 'gray')
            new_image = rgb2gray(input_image);
        else
        % if user inputs an unknow colorspace just notify and do not plot anything
            fprintf('Error: Unknown colorspace type [%s]...\n',colorspace);
            new_image = input_image;
        end
    else
        new_image = input_image;
    end

end