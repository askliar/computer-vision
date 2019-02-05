function visual_vocabulary = get_k_means_vocabulary(vocabulary_features, num_clusters)
    [~, visual_vocabulary] = kmeans(vocabulary_features, num_clusters);
end
