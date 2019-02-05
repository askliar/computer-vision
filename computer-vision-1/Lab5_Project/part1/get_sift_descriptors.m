function [descriptors] = get_sift_descriptors(img, keypoints)
    I_ = vl_imsmooth(im2double(img), sqrt(keypoints(3)^2 - 0.5^2)) ;
    [Ix, Iy] = vl_grad(I_) ;
    mod = sqrt(Ix.^2 + Iy.^2) ;
    ang = atan2(Iy,Ix) ;
    grd = shiftdim(cat(3,mod,ang),2) ;
    grd = single(grd) ;
    descriptors = vl_siftdescriptor(grd, keypoints);
end