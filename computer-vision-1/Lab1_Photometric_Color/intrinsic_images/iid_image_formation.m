R = im2double(imread('ball_reflectance.png'));
S = im2double(imread('ball_shading.png'));
I_orig = im2double(imread('ball.png'));
I_re = R .* S;

subplot(2,3,2), imshow(I_orig), title('Original image');
subplot(2,3,4), imshow(R), title('Reflection');
subplot(2,3,5), imshow(S), title('Shading');
subplot(2,3,6), imshow(I_re), title('Reconstructed image');
