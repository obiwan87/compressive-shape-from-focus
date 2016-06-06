function [ limages ] = lincomb3d( images, lincombs )
%LINCOMB3D returns a linear combination of images according to lincombs
%Returns a datacube of lineraly combined images according to the matrix 
%lincombs
%

limages = zeros( size(images,1), size(images,2) , size(lincombs,2));
for i=1:size(lincombs, 2)
   for j=1:size(lincombs, 1)
       limages(:,:,i) = limages(:,:,i) + lincombs(j,i) * im2double(images(:,:,j));
   end
end


end

