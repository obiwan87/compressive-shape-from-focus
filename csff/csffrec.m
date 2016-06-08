function [ z, cz ] = csffrec( imdata, measurement, cstacksize, focusmeasure, wsize )
%CSFFREC Summary of this function goes here
%   Detailed explanation goes here

stack = imreadlist(imdata.images, @(x) x);

%% Reconstruction
lstack = reshape(stack, size(stack,1) * size(stack,2), size(stack,3));
cstack = measurement * lstack';
cstack = reshape(cstack', size(stack,1), size(stack,2), cstacksize);

%Compressed focus measure
[~, cfmlin] = focusmeasure.Calculate(cstack, wsize);

rfmlin = zeros(size(ofmlin));

for i=1:size(cfmlin,3)
    rfmlin(:,:,i) = measurement'*cfmlin(:,:,i);
end

imgsize = size(imdata.z);
imgsize = imgsize(1:2);
rfm = focusmeasure.FromLinear(rfmlin, imgsize, wsize);

%% Depthmap
[cz, ~] = sff2(rfm, 'focus', imdata.focus, 'filter', 5);
[z,  ~] = sff2(ofm, 'focus', imdata.focus, 'filter', 5);

%% Smoothing
WSize = 5;
MEANF = fspecial('average',[WSize WSize]);
cz = imfilter(cz, MEANF', 'replicate');
z = imfilter(z, MEANF', 'replicate');

end

