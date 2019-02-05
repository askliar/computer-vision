function G = gauss1D( sigma , kernel_size )
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    x = 1:kernel_size;
    x = x - floor(kernel_size/2) - 1;
    
    G = exp(- x.^2 / (2*sigma^2) ) / (sigma*sqrt(2*pi));
    G = G / sum(G);
end
