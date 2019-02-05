function [net, info, expdir] = finetune_cnn(freeze, varargin)

%% Define options
run(fullfile(fileparts(mfilename('fullpath')), ...
  '..', '..', '..', 'matconvnet-1.0-beta23', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet' ;
[opts, varargin2] = vl_argparse(opts, varargin{1}) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin2] = vl_argparse(opts, varargin2) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin2) ;
if ~isfield(opts.train, 's'), opts.train.gpus = []; end;

opts.train.gpus = [];
opts.augment_data = varargin{3};

%% update model

net = update_model(freeze, varargin{2});
varargin = varargin{1};
%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB() ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y, opts.augment_data) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch, augment_data)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;

if rand > 0.5 
    images = fliplr(images);
end
if augment_data
    res = rand;
    if rand >= 0.8
        % in this way, we rotate by up top 45 degrees (2*(rand - 0.5)) 
        % has values between 0 and 1 since we know already rand is >= 0.5
        images = imrotate(images, 2*(rand - 0.5)*20);
    end

    if rand >=0.5
        % zero mean and 0.01 standard deviation for the noise
       images = imnoise(images, 'gaussian', 0, 0.01);
    end

    if rand >= 0.5
        % density parameter, around 5% of pixels will be affected
       images = imnoise(images, 'salt & pepper', 0.05);
    end
end
end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB()
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};


%% TODO: Implement your loop here, to create the data structure described in the assignment
sets = [];
labels = [];

num_imgs = 1
for i=1:length(splits)
    %disp('iiii')
    for j=1:length(classes)
        %disp('jjjj')
        folder_name = strjoin(strcat(classes(j), '_', splits(i)));
        fname = strcat('../Caltech4/ImageSets/', folder_name, '.txt');
        a = textread(fname, '%s');
        for k=1:length(a)
            img = im2double(imread(strcat('../Caltech4/ImageData/', strjoin(a(k)), '.jpg')));
            disp(strcat('../Caltech4/ImageData/', strjoin(a(k)), '.jpg'));
            if length(size(img)) < 3
               continue 
            end
            data(:, :, :, num_imgs) = imresize(img, [32, 32]);
            %data(:, :, :, num_imgs) = vl_imreadjpeg(strcat('../Caltech4/ImageData/', strjoin(a(k)), '.jpg'), 'Resize', [32,32])
            labels = [labels j];
            sets = [sets i];
            num_imgs = num_imgs + 1;
        end
    end    
end
data = single(data);

images = struct('data', data, 'labels', labels, 'set', sets);
meta = struct('set', {splits}, 'classes', {classes});
imdb = struct('images', images, 'meta', meta);

%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = data ;
imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
