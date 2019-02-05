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
sift_methods = {'regular'; 'dense'};
sift_steps = [5 ; 10 ; 15];
sift_sizes = [3 ; 5 ; 7 ; 10];
colorspaces = {'RGB'; 'opponent'; 'rgb'; 'hsv'; 'ycbcr'; 'gray'};
kernels = {'linear'; 'polynomial'; 'rbf'};

disp('start');

num_vocab = 250;
num_train_idx = 1;
num_neg_idx = 1;
cluster_idx = 1;
sift_idx = 1;
colorspace_idx = 1;

num_train = nums_train(num_train_idx);
num_neg = nums_neg(num_neg_idx);
num_clusters = clusters(cluster_idx);
sift_method = sift_methods{sift_idx};
colorspace = colorspaces{colorspace_idx};

if strcmp(sift_method, 'dense')
    sift_step_idx = 1;
    sift_step = sift_steps(sift_step_idx);
    sift_size_idx = 1;
    sift_size = sift_sizes(sift_size_idx);
else
    sift_step = sift_steps(1);
    sift_size = sift_sizes(1);
end

num_classes = 4;

splits = split_train_data(data_dir, num_vocab, num_train, num_neg, num_classes);
[pos_train_data, pos_train_names, vocab_data, neg_train_data, neg_train_names] = get_data(data_dir, 'train', splits);
[test_data, test_data_names] = get_data(data_dir, 'test');

pos_train_data = change_data_color_space(pos_train_data, colorspace);
vocab_data = change_data_color_space(vocab_data, colorspace);
neg_train_data = change_data_color_space(neg_train_data, colorspace);
test_data = change_data_color_space(test_data, colorspace);

disp('got data');

[~, vocab_sift] = get_sift_features(vocab_data);

pos_train_sift_values = get_sift_features(pos_train_data, sift_method, sift_step, sift_size);
neg_train_sift_values = get_sift_features(neg_train_data, sift_method, sift_step, sift_size);
test_sift_values = get_sift_features(test_data, sift_method, sift_step, sift_size);

disp('got sift features');

visual_vocabulary = get_k_means_vocabulary(vocab_sift, num_clusters);

pos_clusters = get_k_means(visual_vocabulary, pos_train_sift_values);
neg_clusters = get_k_means(visual_vocabulary, neg_train_sift_values);
test_clusters = get_k_means(visual_vocabulary, test_sift_values);

disp('got clusters');

pos_hist = get_hist(pos_clusters, num_clusters);
neg_hist = get_hist(neg_clusters, num_clusters);
test_hist = get_hist(test_clusters, num_clusters);

disp('got histograms');

[data, labels, ~] = get_svm_train_data(pos_hist, pos_train_names, neg_hist, neg_train_names, num_clusters);
[test_data, test_labels, test_names] = get_svm_test_data(test_hist, test_data_names, num_clusters);

disp('got svm data');

save(sprintf('%s/data/%d_%d_%d_%s_%s_%d_%d_data.mat', '.', num_train, num_neg, num_clusters, sift_method, colorspace, sift_step, sift_size), 'data');
save(sprintf('%s/data/%d_%d_%d_%s_%s_%d_%d_labels.mat', '.', num_train, num_clusters, sift_method, colorspace, sift_step, sift_size), 'labels');

save(sprintf('%s/data/%d_%d_%d_%s_%s_%d_%d_test_data.mat', '.', num_train, num_neg, num_clusters, sift_method, colorspace, sift_step, sift_size), 'test_data');
save(sprintf('%s/data/%d_%d_%d_%s_%s_%d_%d_test_labels.mat', '.', num_train, num_neg, num_clusters, sift_method, colorspace, sift_step, sift_size), 'test_labels');

disp('saved data');

for kernel_idx=1:size(kernels)
    kernel = kernels{kernel_idx};
    [classifiers, best_params] = get_classifiers(data, labels, kernel_idx - 1);
    save(sprintf('%s/data/%d_%d_%d_%s_%s_%s_%d_%d_classifiers.mat', '.', num_train, num_neg, num_clusters, sift_method, colorspace, kernel, sift_step, sift_size), 'classifiers');

    disp('got classifiers');

    [~, accuracy, decision_values] = evaluate(test_data, test_labels, classifiers);
    [mAP, mAP_data, ~, ordered_names] = mean_average_precision(test_labels, test_names, decision_values);
    disp('calculated mAP');

    fprintf('Kernel: %s\n', kernel);
    fprintf('mAP: %f\n', mAP);
    fprintf('Accuracy: %f\n', accuracy);

    html =  generate_html(ordered_names, mAP, mAP_data, num_vocab, num_train,...
                        num_neg, num_clusters, sift_method,...
                        colorspace, kernel, best_params, sift_step, sift_size);
    file_name = sprintf('%s/data/html/%d_%d_%d_%s_%s_%s_%d_%d.html', '.', num_train, num_neg, num_clusters, sift_method, colorspace, kernel, sift_step, sift_size);
    fid = fopen(file_name,'wt');
    fprintf(fid, '%s', html);
    fclose(fid);
end



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

