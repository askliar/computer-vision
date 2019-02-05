function [data, data_labels, data_names] = get_svm_train_data(pos_hist, pos_names, neg_hist, neg_names, num_clusters)
    data = cell(size(pos_hist, 1), 1);
    data_labels = cell(size(pos_hist, 1), 1);
    data_names = cell(size(pos_hist, 1), 1);
    for i=1:size(pos_hist, 1)
        values = zeros(size(pos_hist,2) + size(neg_hist,2), num_clusters);
        labels = zeros(size(pos_hist,2) + size(neg_hist,2), 1);
        names = cell(size(pos_hist,2) + size(neg_hist,2), 1);
        for j=1:size(pos_hist,2)
            values(j, :) = pos_hist{i, j};
            names{j} = pos_names{i};
            labels(j, :) = 1;
        end
        for j=1:size(neg_hist,2)
            values(size(pos_hist,2) + j, :) = neg_hist{i, j};
            names{size(pos_hist,2) + j} = neg_names{i, j};
            labels(size(pos_hist,2) + j) = -1;
        end
        data{i} = values;
        data_labels{i} = labels;
        data_names{i} = string(names);
    end
end