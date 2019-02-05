R = im2double(imread('ball_reflectance.png'));

R_true = max(max(R(:,:,1)));
G_true = max(max(R(:,:,2)));
B_true = max(max(R(:,:,3)));
true_color = [R_true; G_true; B_true];

image_binary = double(R > 0);

S = im2double(imread('ball_shading.png'));

R_channel = image_binary(:,:,1);
G_channel = image_binary(:,:,2);
B_channel = image_binary(:,:,3);

I_orig = im2double(imread('ball.png'));

magenta_reflection = cat(3, R_channel*1, G_channel*0, B_channel*1);
I_magenta = magenta_reflection .* S;

green_reflection = cat(3, R_channel*0, G_channel*1, B_channel*0);
I_green = green_reflection .* S;

subplot(1,3,1), imshow(I_orig), title('Original image');
subplot(1,3,2), imshow(I_magenta), title('Magenta image');
subplot(1,3,3), imshow(I_green), title('Green image');