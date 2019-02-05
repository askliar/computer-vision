im = imread('./images/image2.jpg');
im = im2double(im);

[Gx, Gy, im_mag, im_dir] = compute_gradient(im);
f1 = figure;
subplot(2,2,1), imshow(Gx);%, title('x gradient component');
subplot(2,2,2), imshow(Gy);%, title('y graadient component');
subplot(2,2,3), imshow(im_mag);%, title('gradient magnitude');
subplot(2,2,4), imshow(im_dir);%, title('gradient direction');
print(f1, sprintf('results/edges/edges.png'), '-dpng');
imwrite(Gx, 'results/edges/Gx.png');
imwrite(Gy, 'results/edges/Gy.png');
imwrite(im_mag, 'results/edges/Gmag.png');
imwrite(im_dir, 'results/edges/Gdir.png');


Gx_norm = normalize_minmax(Gx);
Gy_norm = normalize_minmax(Gy);
im_mag_norm = normalize_minmax(im_mag);
im_dir_norm = normalize_minmax(im_dir);

f1 = figure;
subplot(2,2,1), imshow(Gx_norm);%, title('normalized x gradient component');
subplot(2,2,2), imshow(Gy_norm);%, title('normalized y graadient component');
subplot(2,2,3), imshow(im_mag_norm);%, title('normalized gradient magnitude');
subplot(2,2,4), imshow(im_dir_norm);%, title('normalized gradient direction');
print(f1, sprintf('results/edges/edges_norm.png'), '-dpng');
imwrite(Gx_norm, 'results/edges/Gx_norm.png');
imwrite(Gy_norm, 'results/edges/Gy_norm.png');
imwrite(im_mag_norm, 'results/edges/Gmag_norm.png');
imwrite(im_dir_norm, 'results/edges/Gdir_norm.png');

%im2 = imread('./images/image2.jpg');
%im2 = im2double(im2);

log1 = compute_LoG(im, 1);
log2 = compute_LoG(im, 2);
log3 = compute_LoG(im, 3);

f2 = figure;
subplot(1,3,1), imshow(log1), title('Method 1. Laplacian of Gaussian composition');
subplot(1,3,2), imshow(log2), title('Method 2. LoG kernel');
subplot(1,3,3), imshow(log3), title('Method 3. Difference of Gaussians');
print(f1, sprintf('results/log/log_methods_norm.png'), '-dpng');

imwrite(log1, 'results/log/log1.png');
imwrite(log2, 'results/log/log2.png');
imwrite(log3, 'results/log/log3.png');


log1_norm = normalize_minmax(log1);
log2_norm = normalize_minmax(log2);
log3_norm = normalize_minmax(log3);

f2 = figure;
subplot(1,3,1), imshow(log1_norm), title('Method 1. Laplacian of Gaussian composition');
subplot(1,3,2), imshow(log2_norm), title('Method 2. LoG kernel');
subplot(1,3,3), imshow(log3_norm), title('Method 3. Difference of Gaussians');
print(f1, sprintf('results/log/log_methods.png'), '-dpng');

imwrite(log1_norm, 'results/log/log1_norm.png');
imwrite(log2_norm, 'results/log/log2_norm.png');
imwrite(log3_norm, 'results/log/log3_norm.png');

figure;
subplot(1,2,1), imshow(log1_norm), title('log');
subplot(1,2,2), imshow(im_mag_norm), title('gradient magnitude');
print(f1, sprintf('results/log/first_vs_second.png'), '-dpng');
figure
imshowpair(im_mag, log2, 'montage');
figure;
imshowpair(im_mag_norm, log2_norm, 'montage');
%imwrite(im_mag, 'results/log/magnitude.png');
%imwrite(im_mag_norm, 'results/log/magnitude_norm.png');

