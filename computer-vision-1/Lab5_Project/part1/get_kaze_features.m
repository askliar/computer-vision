function [kaze_values, kaze_array] = get_kaze_features(data)
    kaze_array = [];
    kaze_values = cell(size(data, 1), size(data, 2));
    
    for i=1:size(data, 1)
        for j=1:size(data, 2)
            
            img = data{i,j};
            n_channels = size(img, 3);
            if n_channels > 1
                 I_ = rgb2gray(img);
                 keypoints = detectKAZEFeatures(I_);
            else
                 keypoints = detectKAZEFeatures(img);
            end
            
            
            d_all = [];
            d_temp = [];
            for channel=1:n_channels
                img_channel = img(:, :, channel);
                d = extractFeatures(img_channel, keypoints, 'Method', 'KAZE');
                d_temp = [d_temp, d];
            end
            
            kaze_values{i, j} = double(d_temp);
            kaze_array = [kaze_array; double(d_temp)];
        end
    end
    
    
end