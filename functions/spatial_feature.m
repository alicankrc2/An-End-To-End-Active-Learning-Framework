function [fimage] = spatial_feature(img,r,eps)
%SPATIAL_FEATURE Summary of this function goes here
%   Detailed explanation goes here
bands=size(img,3);
fimage = zeros (size(img,1),size(img,2),1*bands);
for i=1:bands
    fimage(:,:,i)=RF(img(:,:,i),r,eps,3,img(:,:,i));
end
