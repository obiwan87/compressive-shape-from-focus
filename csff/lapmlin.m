function [ Lx,  Ly ] = lapmlin( Image)
%LAMPLIN Returns the linear part of LAPM-Filter
M = [-1 2 -1];
Lx = imfilter(Image, M, 'replicate', 'conv');
Ly = imfilter(Image, M', 'replicate', 'conv');

end

 