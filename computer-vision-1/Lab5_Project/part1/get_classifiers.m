function [classifiers, best_params] = get_classifiers(data, labels, kernel_id)
    classifiers = cell(size(data, 1), 1);
    best_params = cell(size(data, 1), 1);
    for i=1:size(data, 1)
        best_classifier = svmtrain(labels{i}, data{i}, sprintf('-s 0 -t %d -q', kernel_id));
        accuracy = svmtrain(labels{i}, data{i}, sprintf('-s 0 -t %d -v 10 -q', kernel_id));
        best_accuracy = accuracy;
        best_c = 1;
        best_gamma = 1;
        best_degree = 1;
        params = 2.^(-5:1:15);
        for c_i=1:size(params,2)
            c = params(c_i);
            for gamma_i=1:size(params,2)
                gamma = params(gamma_i);
                for degree=1:10
                    accuracy = svmtrain(labels{i}, data{i},...
                        sprintf('-s 0 -t %d -c %f -g %f -v 10 -q', kernel_id, c, gamma));
                    if accuracy > best_accuracy
                        best_c = c;
                        best_gamma = gamma;
                        best_degree = degree;
                        best_classifier = svmtrain(labels{i}, data{i},...
                                sprintf('-s 0 -t %d -c %f -g %f -q', kernel_id, c, gamma));
                    end
                    if kernel_id ~= 1
                        break;
                    end
                end
                if kernel_id == 0
                    break;
                end
            end
        end
        classifiers{i} = best_classifier;
        if kernel_id == 0
            best_params{i} = [best_c];
            display(best_c);
        elseif kernel_id == 1
            best_params{i} = [best_c, best_gamma, best_degree];
            display(best_c);
            display(best_gamma);
            display(best_degree)
        elseif kernel_id == 2
            best_params{i} = [best_c, best_gamma];
            display(best_c);
            display(best_gamma);
        end
        
        
        
    end

end