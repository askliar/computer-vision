function [img] = pad_image(image, padding)
	fr = repmat(image(1, :), padding, 1);
    lr = repmat(image(end, :), padding, 1);
    fc = repmat(image(:, 1), 1, padding);
    lc = repmat(image(:, end), 1, padding);
    tl = repelem(image(1,1), padding, padding);
    tr = repelem(image(1,end), padding, padding);
    bl = repelem(image(end,1), padding, padding);
    br = repelem(image(end,end), padding, padding);
    img = [tl, fr, tr; fc, image, lc; bl, lr, br];
end