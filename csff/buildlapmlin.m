function [ fm3 ] = buildlapmlin( fmx, fmy, imgsize, WSize )
%BUILDLAPMLIN Summary of this function goes here
%   Detailed explanation goes here
MEANF = fspecial('average',[WSize WSize]);

width = imgsize(1);
height = imgsize(2);

fm3 = zeros(width, height, size(fmx,2));

for i=1:size(fm3, 3)
    fmx2 = reshape(fmx(:,i), width, height);
    %fmx2 = imfilter(fmx2, MEANF, 'replicate');
    
    fmy2 = reshape(fmy(:,i), width, height);
    %fmy2 = imfilter(fmy2, MEANF, 'replicate');
    
    fm3(:,:,i) = abs(fmx2) + abs(fmy2);
    fm3(:,:,i) = imfilter(fm3(:,:,i), MEANF, 'replicate');
end

end

