function [means,covariances,priors] = get_gmm_vocabulary(vocabulary_features, num_clusters)
        data = vocabulary_features';
        % Run KMeans to pre-cluster the data
        [initMeans, assignments] = vl_kmeans(vocabulary_features', num_clusters, ...
            'Algorithm','Lloyd', ...
            'MaxNumIterations',5);

        initCovariances = zeros(size(vocabulary_features', 1), num_clusters);
        initPriors = zeros(1, num_clusters);

        % Find the initial means, covariances and priors
        for i=1:num_clusters
            vocabulary_temp = vocabulary_features';
            data_k = vocabulary_temp(:,assignments==i);
            initPriors(i) = size(data_k,2) / num_clusters;

            if size(data_k,1) == 0 || size(data_k,2) == 0
                initCovariances(:,i) = diag(cov(vocabulary_features));
            else
                initCovariances(:,i) = diag(cov(data_k'));
            end
        end

        % Run EM starting from the given parameters
        [means,covariances,priors] = vl_gmm(vocabulary_features', num_clusters, ...
            'initialization','custom', ...
            'InitMeans',initMeans, ...
            'InitCovariances',initCovariances, ...
            'InitPriors',initPriors);
end