function [H, r, c] = harris_corner_detector(I, K, sigma, threshold, N)
    I = im2double(rgb2gray(I));
    
    G = fspecial('gaussian', [K K], sigma);
    [Gx,Gy] = gradient(G);
    
    Ix = imfilter(I, Gx, 'replicate','same',  'conv');
    Iy = imfilter(I, Gy, 'replicate','same',  'conv');
    
    A = imfilter(Ix .^ 2 , G, 'replicate','same',  'conv');
    B = imfilter(Ix .* Iy , G, 'replicate','same',  'conv');
    C = imfilter(Iy .^ 2 , G, 'replicate','same',  'conv');
    
    H = ((A.*C) - (B.^2)) - 0.04*((A + C).^2); 

    % heuristic for scaling threshold depending on the values in the image 
	threshold = abs(mean(mean(H)))*threshold; 
    window = 2*N+1;
    % replace every element in a window with the max element of that window
    max_elements = ordfilt2(abs(H),window^2,ones(window));
    % create boolean mask for cornerness
    H = (H == max_elements) & (H > threshold);
    [r, c] = find(H);
    
    %figure;
    %subplot(121), imshow(Ix / max(max(Ix))), title('Ix');
    %subplot(122), imshow(Iy / max(max(Iy))), title('Iy');
end
