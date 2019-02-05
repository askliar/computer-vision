addpath('liblinear-2.1/matlab');
%addpath('matconvnet-1.0-beta23/matlab/')
nets.fine_tuned = load(fullfile('data', 'best_finetuned_model.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load('data/cnn_assignment-lenet/imdb-caltech.mat');


nets.pre_trained.layers{end}.type = 'softmax'; % change from softmaxloss
nets.fine_tuned.layers{end}.type = 'softmax'; % change from softmaxloss

result_pretrain = vl_simplenn(nets.pre_trained, data.images.data);
activations_pretrain = squeeze(result_pretrain(end-3).x);

result_finetuned = vl_simplenn(nets.fine_tuned, data.images.data);
activations_finetuned = squeeze(result_finetuned(end-3).x);

tsne_pretrain = tsne(activations_pretrain');
tsne_finetuned = tsne(activations_finetuned');

figure;
gscatter(tsne_finetuned(:, 1), tsne_finetuned(:, 2), data.images.labels);
legend(data.meta.classes);

figure;
gscatter(tsne_pretrain(:, 1), tsne_pretrain(:, 2), data.images.labels);
legend(data.meta.classes);
