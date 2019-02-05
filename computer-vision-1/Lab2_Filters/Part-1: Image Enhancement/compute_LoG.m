function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        imOut = imfilter(image, fspecial('gaussian', 5, 0.5));
        imOut = imfilter(imOut, fspecial('laplacian'));
    case 2
        LoG = fspecial('log', 9, 3);
        imOut = imfilter(image, LoG);
    case 3
        g1 = fspecial('gaussian', 5, 1.6);
        g2 = fspecial('gaussian', 5, 1);
        imOut = imfilter(image, g1) - imfilter(image, g2);
end
end

