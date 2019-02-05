function [new_data] = change_data_color_space(data, colorspace)
    new_data = cell(size(data, 1), size(data, 2));
    if strcmp(colorspace, 'RGB')
        new_data = data;
        return;
    end
    for i=1:size(data, 1)
        for j=1:size(data, 2)
            img = data{i,j};
            if nargin == 2
                img = convert_color_space(img, colorspace);
            end
            new_data{i, j} = img;
        end
    end
            
end