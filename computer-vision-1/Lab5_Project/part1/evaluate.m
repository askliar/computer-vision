function [predicted_labels, accuracy, decision_values] = evaluate(test_data, test_labels, classifiers)
    predicted_labels = cell(size(test_labels, 1), 1);
    decision_values = cell(size(test_labels, 1), 1);
    predicted_accuracy = zeros(size(test_labels, 1), 1);
    for i=1:size(test_labels, 1)
        classifier = classifiers{i};
        labels = test_labels{i};
        [predicted_label, accuracy, decision_value] = svmpredict(labels, test_data, classifier);
        predicted_labels{i} = predicted_label;
        decision_values{i} = decision_value;
        predicted_accuracy(i) = accuracy(1);
    end
    accuracy = mean(predicted_accuracy);
end