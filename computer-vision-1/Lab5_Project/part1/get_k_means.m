function clusters = get_k_means(vocabulary, features_array)
                                                
    clusters = cell(size(features_array, 1), size(features_array, 2));
    
    for i=1:size(features_array, 1)
        for j=1:size(features_array, 2)
            clusters{i,j} = dsearchn(vocabulary,  features_array{i,j});
        end
    end
    
end