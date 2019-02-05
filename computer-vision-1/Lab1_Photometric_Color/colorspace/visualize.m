function visualize(input_image, image_name)

if ~exist('results', 'dir')
    mkdir('results')
end

num_channels = size(input_image, 3);

gcf = figure;
if num_channels ~= 1
    subplot(1,num_channels+1,1), imshow(input_image), title('Original image');
    for i = 1:num_channels
        subplot(1,num_channels+1, i+1), imshow(input_image(:,:,i)), title(sprintf('Channel%d',i));
    end
else
    subplot(1,1,1), imshow(input_image), title('Original image (grayscale, so only 1 channel)');
end

print(gcf, sprintf('results/%s.png', image_name), '-dpng');

end


