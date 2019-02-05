close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

%% SphereGray5 NoShadowTrick

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = './photometrics_images/SphereGray5/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
[h, w, n] = size(image_stack);  
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV);
%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization

fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, 'average');

%% Display
gcf = show_results(albedo, normals, SE);
% print(gcf, sprintf('results/SphereGray5_albedo_normals_noshadowtrick.png'), '-dpng');

gcf = show_model(albedo, height_map);
% print(gcf, sprintf('results/SphereGray5_albedo_heightmap_noshadowtrick.png'), '-dpng');

%% Face ShadowTrick
[image_stack, scriptV] = load_face_images('./photometrics_images/yaleB02_filtered/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true);
%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));
%% compute the surface height
height_types = ["column", "row", "average"];

for i = 1:length(height_types)
    height_map = construct_surface( p, q, height_types(i));
    display(height_types(i));
    gcf = show_results(albedo, normals, SE);
%     print(gcf, sprintf('results/Faces_albedo_normals_shadowtrick.png'), '-dpng');

    gcf = show_model(albedo, height_map);
%     print(gcf, sprintf('results/Faces_albedo_heightmap_%s_shadowtrick.png', height_types(i)), '-dpng');
end

%% Color monkey normalized
% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = './photometrics_images/MonkeyColor/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack_R, scriptV] = load_syn_images(image_dir, 1);
[image_stack_G, ~] = load_syn_images(image_dir, 2);
[image_stack_B, ~] = load_syn_images(image_dir, 3);
[h, w, n] = size(image_stack_R);  
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo_R, normals_R] = estimate_alb_nrm(image_stack_R, scriptV, true);
[albedo_G, normals_G] = estimate_alb_nrm(image_stack_G, scriptV, true);
[albedo_B, normals_B] = estimate_alb_nrm(image_stack_B, scriptV, true);

normals = (normals_R + normals_G + normals_B)/3;
normals = normals ./ vecnorm(normals, 2, 3);
albedo = cat(3, albedo_R, albedo_G, albedo_B);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization

fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, 'average');

%% Display
gcf = show_results(albedo, normals, SE);
% print(gcf, sprintf('results/ColorMonkey_albedo_normals_norm.png'), '-dpng');

gcf = show_model(albedo, height_map);
% print(gcf, sprintf('results/ColorMonkey_albedo_heightmap_norm.png'), '-dpng');
