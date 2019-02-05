function [predicted_labels, accuracy, decision_values] = evaluate_booster(test_data, test_labels, classifiers)
    predicted_labels = cell(size(test_labels, 1), 1);
    decision_values = cell(size(test_labels, 1), 1);
    predicted_accuracy = zeros(size(test_labels, 1), 1);
    for i=1:size(test_labels, 1)
        classifier = classifiers{i};
        labels = test_labels{i};
        [predicted_label, decision_value] = predict(classifier, test_data);
        predicted_labels{i} = predicted_label;
        decision_values{i} = decision_value(:, 1);
        performance = classperf(test_labels, predicted_label);
        predicted_accuracy(i) = performance.CorrectRate;
    end
    accuracy = mean(predicted_accuracy);
end