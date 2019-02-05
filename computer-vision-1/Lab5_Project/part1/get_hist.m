function histograms = get_hist(clusters, vocab_size)
    histograms = cell(size(clusters, 1), size(clusters, 2));
    
    for i=1:size(clusters,1)
        for j=1:size(clusters,2)
            data = clusters{i,j};
            histograms{i,j} = histcounts(data, 1:vocab_size+1, 'Normalization', 'probability');
        end
    end
end