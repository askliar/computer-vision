function [sift_values, sift_array] = get_sift_features(data, sampling, step_size, block_size)
    
    if nargin < 2
        sampling = 'regular';
    end
    
    sift_array = [];
    sift_values = cell(size(data, 1), size(data, 2));
    
    for i=1:size(data, 1)
        for j=1:size(data, 2)
            
            img = data{i,j};
            n_channels = size(img, 3);
            
            if ~strcmp(sampling, 'dense')
                if n_channels > 1
                    I_ = single(rgb2gray(img));
                else
                    I_ = single(img);
                end
                keypoints = vl_sift(I_);
            end
            
            d_temp = [];
            for channel=1:n_channels
                img_channel = img(:, :, channel);
                switch sampling
                    case 'dense'
                        img_channel = single(img_channel);
                        [~, d] = vl_dsift(img_channel, 'step', step_size, 'size', block_size);
                    otherwise
                        d = get_sift_descriptors(img_channel, keypoints);
                end
                d_temp = [d_temp, d'];
            end
            sift_values{i, j} = double(d_temp);
            sift_array = [sift_array; double(d_temp)];
        end
    end
    
    
end