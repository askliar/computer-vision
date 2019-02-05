% %% Harris corner detection
K = 3;
sigma = 1;
threshold = 400;
N = 5;

I = imread('person_toy/00000001.jpg');
demo_harris(I, K, sigma, threshold, N);

I = imrotate(I, 90);
demo_harris(I, K, sigma, threshold, N);

sigma = 1;
threshold = 10;

I = imread('pingpong/0000.jpeg');
demo_harris(I, K, sigma, threshold, N);


%% Lucas-Kanade optical flow estimation

I1 = imread('synth1.pgm');
I2 = imread('synth2.pgm');

demo_lucas_kanade(I1, I2);

%% Tracking using Harris corner detection and Lukas-Canade optical flow estimation
K = 3;
sigma = 1;
threshold = 10;
N = 5;

visible = false;
tracking('pingpong', K, sigma, threshold, N, 'jpeg', visible);
implay('results/pingpong.avi');

sigma = 1;
threshold = 400;

tracking('person_toy', K, sigma, threshold, N, 'jpg', visible);
implay('results/person_toy.avi');
