function [data, data_labels, data_names] = get_svm_test_data(test_hist, test_names, num_clusters)
    data_size = size(test_hist, 1) * size(test_hist, 2);
    data_labels = cell(size(test_hist, 1), 1);
    data_names = cell(data_size, 1);
    data = zeros(data_size, num_clusters);
    
    for i=1:size(test_hist, 1)
        for j=1:size(test_hist, 2)
            data((i-1) * size(test_hist,2) + j, :) = test_hist{i, j};
            data_names{(i-1) * size(test_hist,2) + j} = test_names{i, j};
        end
        labels = ones(data_size, 1) * -1;
        labels((i-1)*size(test_hist,2) + 1 : i*size(test_hist,2)) = 1;
        data_labels{i} = labels;
    end
    data = data;
    data_names = string(data_names);
end