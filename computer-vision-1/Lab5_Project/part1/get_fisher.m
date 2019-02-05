function fisher_data = get_fisher(means, covariances, priors, features_array)
                                                
    fisher_data = cell(size(features_array, 1), size(features_array, 2));
    
    for i=1:size(features_array, 1)
        for j=1:size(features_array, 2)
            fisher_data{i,j} = vl_fisher(features_array{i,j}', means, covariances, priors, 'Normalized')';
        end
    end
    
end