function [ PSNR ] = myPSNR( orig_image, approx_image )
[n, m] = size(orig_image);
diff = (orig_image - approx_image).^2;
mse = sum(diff(:)) / (m * n);
Imax = double(max(orig_image(:)));
PSNR = 20*log10(Imax / sqrt(mse));
end

