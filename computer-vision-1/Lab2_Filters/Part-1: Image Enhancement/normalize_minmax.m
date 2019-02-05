function out = normalize_minmax(img)
out = img ./ max(img(:));
%out =(img - min(img(:))) ./ (max(img(:)) - min(img(:)));
end