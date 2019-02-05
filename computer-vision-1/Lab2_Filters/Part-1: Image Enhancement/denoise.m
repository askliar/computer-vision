function [ imOut ] = denoise( image, kernel_type, varargin)
n = varargin{1};
switch kernel_type
    case 'box'
        imOut = imboxfilt(image, n);
    case 'median'
        imOut = medfilt2(image, [n, n]);
    case 'gaussian'
        kernel = gauss2D(varargin{2}, n);
        imOut = imfilter(image, kernel);
end
end
