G1 = gauss1D(2, 5);
G2 = gauss2D(2, 5);

im1 = imread('./images/image1.jpg');
im2 = imread('./images/image1_gaussian.jpg');

c2 = imfilter(im2, G2);
imshowpair(im2, c2, 'montage');