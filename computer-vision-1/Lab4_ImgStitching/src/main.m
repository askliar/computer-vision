%% install vlfeat and remove all figures
% run('vlfeat/toolbox/vl_setup');

close all;
clear all;

%% boat keypoint matching

img1 = im2double(imread('../imgs/boat1.pgm'));
img2 = im2double(imread('../imgs/boat2.pgm'));
gcf = demo_matching_points(img1, img2);
% saveas(gcf, '../results/boat_keypoint_matching.jpg')

%% bus keypoint matching

img1 = im2double(imread('../imgs/left.jpg'));
img2 = im2double(imread('../imgs/right.jpg'));
gcf = demo_matching_points(img1, img2);
% saveas(gcf, '../results/bus_keypoint_matching.jpg')

%% boat image transformation (right to left)
   
img1 = im2double(imread('../imgs/boat2.pgm'));
img2 = im2double(imread('../imgs/boat1.pgm'));
transformed_image = demo_transform(img1, img2);
% imwrite(transformed_image, '../results/boat_right_left_transformation.jpg');

%% boat image transformation (left to right)

img1 = im2double(imread('../imgs/boat1.pgm'));
img2 = im2double(imread('../imgs/boat2.pgm'));
transformed_image = demo_transform(img1, img2);
% imwrite(transformed_image, '../results/boat_left_right_transformation.jpg');

%% bus image transformation (right to left)
   
img1 = im2double(imread('../imgs/right.jpg'));
img2 = im2double(imread('../imgs/left.jpg'));
transformed_image = demo_transform(img1, img2);
% imwrite(transformed_image, '../results/bus_right_left_transformation.jpg');

%% bus image transformation (left to right)

img1 = im2double(imread('../imgs/left.jpg'));
img2 = im2double(imread('../imgs/right.jpg'));
transformed_image = demo_transform(img1, img2);
% imwrite(transformed_image, '../results/bus_left_right_transformation.jpg');

%% boat image stitching (right to left)

img1 = im2double(imread('../imgs/boat2.pgm'));
img2 = im2double(imread('../imgs/boat1.pgm'));
stitched_image = demo_stitch(img1, img2);
% imwrite(stitched_image, '../results/boat_right_left_stitching.jpg');

%% boat image stitching (left to right)

img1 = im2double(imread('../imgs/boat1.pgm'));
img2 = im2double(imread('../imgs/boat2.pgm'));
stitched_image = demo_stitch(img1, img2);
% imwrite(stitched_image, '../results/boat_left_right_stitching.jpg');

%% bus image stitching (right to left)

img1 = im2double(imread('../imgs/right.jpg'));
img2 = im2double(imread('../imgs/left.jpg'));
stitched_image = demo_stitch(img1, img2);
% imwrite(stitched_image, '../results/bus_right_left_stitching.jpg');

%% bus image stitching (left to right)

img1 = im2double(imread('../imgs/left.jpg'));
img2 = im2double(imread('../imgs/right.jpg'));
stitched_image = demo_stitch(img1, img2);
% imwrite(stitched_image, '../results/bus_left_right_stitching.jpg');