
im = im2double(imread('./images/image1.jpg'));
gauss = im2double(imread('./images/image1_gaussian.jpg'));
salt = im2double(imread('./images/image1_saltpepper.jpg'));
psnr_salt = myPSNR(im, salt)
psnr_gauss = myPSNR(im, gauss)

%figure;
%subplot(1,3,1), imshow(im), title('Original Image');
%subplot(1,3,2), imshow(gauss), title(strcat('PSNR = ',num2str(psnr_gauss)));
%subplot(1,3,3), imshow(salt), title(strcat('PSNR = ',num2str(psnr_salt)));
noise_names = [{'gauss'}, {'salt'}];
noise_imgs(:,:,1) = gauss;
noise_imgs(:,:,2) = salt;
kern_sizes = [3, 5, 7];
fil_types = [{'box'}, {'median'}];


for noise_type=1:length(noise_names)
    for kern_size=1:length(kern_sizes)
        for fil_type=1:length(fil_types)
            denoised_arr(noise_type, kern_size, fil_type, :, :) = denoise(noise_imgs(:,:, noise_type), fil_types{fil_type}, kern_sizes(kern_size));
            denoised = squeeze(denoised_arr(noise_type, kern_size, fil_type, :, :));
            psnr_arr(noise_type, kern_size, fil_type) = myPSNR(im, denoised);
            imwrite(denoised, strcat('results/denoise/', noise_names{noise_type}, '_',fil_types{fil_type}, num2str(kern_sizes(kern_size)), '.png'));
        end
    end
end
psnr_arr(1, : ,1)
psnr_arr(1, : ,2)
psnr_arr(2, : ,1)
psnr_arr(2, : ,2)
%for noise_type =1:length(noise_names)
%    psnr_arr(noise_type, :, :)
%end

sigmas = [0.25, 0.5, 1, 2, 3, 5];
for i=1:length(sigmas)
    sigma = sigmas(i);
    gaussResults(i, :, :) = denoise(gauss, 'gaussian', 3, sigma);
    denoised = squeeze(gaussResults(i, : ,:));
    imwrite(denoised, strcat('results/denoise/gauss_gauss3_', num2str(sigma), '.png'));
    psnrArrayGauss(i) = myPSNR(im, denoised);
end
psnrArrayGauss
