function [pos_data, pos_data_names, vocab_data, neg_data, neg_data_names] = get_data(data_dir, split, splits)
    dirs = dir(sprintf('%s/*_%s', data_dir, split));
    pos_data = {};
    pos_data_names = {};
    vocab_data = {};
    neg_data = {};
    neg_data_names = {};
    img_files = {};
    
    
    for i=1:size(dirs)
        img_dir = dirs(i);
        img_files{i} = dir(sprintf('%s/%s/*.jpg', img_dir.folder, img_dir.name));
    end
    
    for i=1:size(dirs)
        img_file = img_files{i};
        if strcmp(split, 'train')
            vocab_imgs = img_file(splits{i,1});
            data_imgs = img_file(splits{i,2});
            
            for j=1:size(vocab_imgs, 1)
                img = vocab_imgs(j);
                filename = sprintf('%s/%s', img.folder, img.name);
                img = imread(filename);
                if size(img, 3) == 1
                    img = repmat(img, [1,1,3]);
                end
                vocab_data{i,j} = img;
            end
            
            for j=1:size(data_imgs, 1)
                img = data_imgs(j);
                filename = sprintf('%s/%s', img.folder, img.name);
                img = imread(filename);
                if size(img, 3) == 1
                    img = repmat(img, [1,1,3]);
                end
                pos_data{i,j} = img;
                pos_data_names{i,j} = filename;
            end
            
            k = 3;
            idx = 1;
            for j=1:size(splits, 1)
                if i ~= j
                    file = img_files{j};
                    neg_imgs = file(splits{i, k});
                    k = k + 1;
                    for p = 1:size(neg_imgs, 1)
                        img = neg_imgs(p);
                        filename = sprintf('%s/%s', img.folder, img.name);
                        img = imread(filename);
                        if size(img, 3) == 1
                            img = repmat(img, [1,1,3]);
                        end
                        neg_data{i,idx} = img;
                        neg_data_names{i,idx} = filename;
                        idx = idx + 1;
                    end
                end
            end
        else
            for j=1:size(img_file, 1)
                filename = sprintf('%s/%s', img_file(j).folder, img_file(j).name);
                img = imread(filename);
                if size(img, 3) == 1
                    img = repmat(img, [1,1,3]);
                end
                pos_data{i,j} = img;
                pos_data_names{i,j} = filename;
            end
        end
    end
end
