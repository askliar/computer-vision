function splits = split_train_data(data_dir, num_vocab, num_train, num_neg, num_classes)
    dirs = dir(sprintf('%s/*_train', data_dir));
    
    image_lists = cell(size(dirs, 1), 1);
    splits = cell(size(dirs, 1), 1 + num_classes);
    
    for i=1:size(dirs)
        dir_size = size(dir(sprintf('%s/%s/*.jpg', dirs(i).folder, dirs(i).name)), 1);
        
        image_list = 1:dir_size;
        image_list = image_list(randperm(size(image_list, 2)));
        
        splits{i, 1} = image_list(1:num_vocab);
        splits{i, 2} = image_list(num_vocab+1:num_vocab+num_train);
        image_lists{i} = image_list(num_vocab+1:end);
    end

    for i=1:size(dirs)
        k = 3;
        for j = 1:num_classes
            if i ~= j
               splits{i, k} = randsample(image_lists{j}, num_neg);
               k = k + 1;
            end
        end
    end

end