%% main function 
addpath('liblinear-2.1/matlab');
addpath('../../../matconvnet-1.0-beta23/matlab/')
names = {''};
batch_sizes = [50, 100];
epochs = [40, 80, 120];

augment_data = false;
freeze = false;

param_str = '';
if augment_data
    param_str = 'augment_';
end
if freeze
    param_str = strcat(param_str, 'freeze_');
end

%% fine-tune cnn
%if exist('data/best_finetuned_model.mat') == 0 and True
lowest_top1 = 1;
results = cell(length(names), length(batch_sizes));
for j=1:length(batch_sizes)
    for k=1:length(epochs)
        bs = struct('batchSize', batch_sizes(j));
        ep = struct('numEpochs',epochs(k));
        modelOpts = struct('modelOpts', {bs, ep});
        
        expDir = strcat('data/cnn-assignment-', ...
                    param_str, ...
                    '_bs_', int2str(batch_sizes(j)), ...
                    '_ep_', int2str(epochs(k)) ...
                )

        [net, info, expdir] = finetune_cnn(freeze, ...
                struct('expDir', expDir), ...
                {bs, ep}, augment_data...
            );
        if info.val(end).top1err < lowest_top1
           lowest_top1 = info.val(end).top1err;
           best = {net, info, expdir};

        end
        results{j, k}.trainObj = info.train(epochs(k)).objective;
        results{j, k}.trainErr = info.train(epochs(k)).top1err;
        results{j, k}.valObj   = info.val(epochs(k)).objective
        results{j, k}.valErr = info.val(epochs(k)).top1err;
            
    end
end
net = best{1};
info = best{2};
expdir = best{3};
save('data/best_finetuned_model.mat', 'net') ;
save('data/best_finetuned_info.mat', 'info') ;
%end
%% extract features and train svm

nets.resnet50 = load(fullfile('data', 'imagenet-resnet-50-dag.mat'))
nets.fine_tuned = load(fullfile('data', 'best_finetuned_model.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile('data/cnn_assignment-lenet', 'imdb-caltech.mat'));

%%
[acc, pretrain, finetune] = train_svm(nets, data);


% these loops are for printing all the results at the end
for j=1:length(batch_sizes)
    for k=1:length(epochs)
        [j, k]
        results{j, k}
    end
end




