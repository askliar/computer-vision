% addpath to the libsvm toolbox
% addpath('liblinear-2.1/matlab');
addpath('libsvm-3.22/matlab');

run('vlfeat/toolbox/vl_setup');

if ~exist(sprintf('%s/data', '.'), 'dir')
    mkdir(sprintf('%s/data', '.'))
end 

if ~exist(sprintf('%s/data/html', '.'), 'dir')
    mkdir(sprintf('%s/data/html', '.'))
end 

data_dir = sprintf('%s/Caltech4/ImageData', '../');
nums_train = [50 ; 100 ; 150];
nums_neg = [50 ; 100 ; 150];
clusters = [400 ; 800 ; 1600 ; 2000 ; 4000];
colorspaces = {'RGB'; 'opponent'; 'rgb'; 'hsv'; 'ycbcr'; 'gray'};
kernels = {'linear'; 'polynomial'; 'rbf'};

disp('start');

num_vocab = 250;
num_train_idx = 1;
num_neg_idx = 1;
cluster_idx = 1;
colorspace_idx = 6;

num_train = nums_train(num_train_idx);
num_neg = nums_neg(num_neg_idx);
num_clusters = clusters(cluster_idx);
colorspace = colorspaces{colorspace_idx};

num_classes = 4;

splits = split_train_data(data_dir, num_vocab, num_train, num_neg, num_classes);
[pos_train_data, pos_train_names, vocab_data, neg_train_data, neg_train_names] = get_data(data_dir, 'train', splits);
[test_data, test_data_names] = get_data(data_dir, 'test');

pos_train_data = change_data_color_space(pos_train_data, colorspace);
vocab_data = change_data_color_space(vocab_data, colorspace);
neg_train_data = change_data_color_space(neg_train_data, colorspace);
test_data = change_data_color_space(test_data, colorspace);

disp('got data');

[~, vocab_sift] = get_kaze_features(vocab_data);

pos_train_kaze_values = get_kaze_features(pos_train_data);
neg_train_kaze_values = get_kaze_features(neg_train_data);
test_kaze_values = get_kaze_features(test_data);

disp('got kaze features');

[means,covariances,priors] = get_gmm_vocabulary(vocab_sift, num_clusters);

pos_fisher_vectors = get_fisher(means, covariances, priors, pos_train_kaze_values);
neg_fisher_vectors = get_fisher(means, covariances, priors, neg_train_kaze_values);
test_fisher_vectors = get_fisher(means, covariances, priors, test_kaze_values);

disp('got fisher vectors');

[data, labels, ~] = get_svm_train_data(pos_fisher_vectors, pos_train_names, neg_fisher_vectors, neg_train_names, size(pos_fisher_vectors{1,1}, 2));
[test_data, test_labels, test_names] = get_svm_test_data(test_fisher_vectors, test_data_names, size(test_fisher_vectors{1, 1}, 2));

disp('got svm data');

classifiers = get_booster_classifiers(data, labels);

disp('got classifiers');

[~, accuracy, decision_values] = evaluate_booster(test_data, test_labels, classifiers);
[mAP, mAP_data, ~, ordered_names] = mean_average_precision(test_labels, test_names, decision_values);

disp('calculated mAP');

fprintf('mAP: %f\n', mAP);
fprintf('Accuracy: %f\n', accuracy);

html =  generate_html(ordered_names, mAP, mAP_data, num_vocab, num_train,...
                    num_neg, num_clusters, 'Bonus',...
                    colorspace, 'None', 'None');
file_name = sprintf('%s/data/html/%d_%d_%d_%s_%s_%s_%d_%d.html', '.', num_train, num_neg, num_clusters, sift_method, colorspace, kernel, sift_step, sift_size);
fid = fopen(file_name,'wt');
fprintf(fid, '%s', html);
fclose(fid);

disp('end');




% data = load('data/data.mat');
% data = data.data;
% 
% labels = load('data/labels.mat');
% labels = labels.labels;
% 
% test_data = load('data/test_data.mat');
% test_data = test_data.test_data;
% 
% test_labels = load('data/test_labels.mat');
% test_labels = test_labels.test_labels;

