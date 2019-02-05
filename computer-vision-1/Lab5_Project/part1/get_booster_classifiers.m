function [classifiers] = get_booster_classifiers(data, labels)
    classifiers = cell(size(data, 1), 1);

    for i=1:size(data, 1)
       classifiers{i} = fitcensemble(data{i}, labels{i}, 'Method', 'RUSBoost',...
        'Learners', 'Tree', 'OptimizeHyperparameters', 'all', ...
        'HyperparameterOptimizationOptions', struct('Optimizer', 'bayesopt', 'Kfold', 10));
    end

end