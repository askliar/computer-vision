function [mAP_total, mAP_values, sorted_labels, sorted_names] = mean_average_precision(true_labels,...
                                                            data_names,...
                                                            decision_values)
    mAP_values = zeros(size(true_labels, 1), 1);
    sorted_labels = cell(size(true_labels, 1), 1);
    sorted_names = cell(size(true_labels, 1), 1);
    
    num_classes = size(true_labels, 1);
    num_images = size(true_labels{1}, 1)/num_classes;
    
    for i=1:size(true_labels, 1)
        predicted_label = true_labels{i};
        decision_value = decision_values{i};
        [~,I] = sort(decision_value, 'descend');
        sorted_label = predicted_label(I);
        sorted_name = data_names(I);
        sorted_labels{i} = sorted_label;
        sorted_names{i} = sorted_name;
        sorted_label(sorted_label == -1) = 0;
        mean_precision = 0;
        for j=1:size(true_labels{1}, 1)
            mean_precision = mean_precision + (sum(sorted_label(1:j))*sorted_label(j)/j);
        end
        mAP_value= mean_precision/num_images;
        mAP_values(i) = mAP_value;
    end
    
    mAP_total = mean(mAP_values);
end