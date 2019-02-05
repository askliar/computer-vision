function G = gauss2D( sigma , kernel_size )
    half = floor(kernel_size/2);
    x = zeros(kernel_size);
    for i=1:kernel_size
        for j=1:kernel_size
            x(i,j) = (half - i+1)^2 + (half- j+1)^2;
        end
    end
    x;
    G = exp(- x / (2*sigma^2) ) / (sigma*sqrt(2*pi));
    G = G / sum(G(:));
end
