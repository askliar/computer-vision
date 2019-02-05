I = im2double(imread('awb.jpg'));


R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

illum = squeeze(sum(sum(I))/(size(I, 1) * size(I, 2)));
scale = sum(illum)/3;
R = R * scale/ illum(1);
G = G * scale / illum(2);
B = B * scale / illum(3);

output_image = cat(3, R, G, B);

subplot(1,2,1), imshow(I), title('Original image');
subplot(1,2,2), imshow(output_image), title('AWB image');

if ~exist('results', 'dir')
    mkdir('results')
end


print(gcf, sprintf('results/%s.png', 'awb_orig'), '-dpng');


