function [ z, cz ] = csffrec( imdata, measurement, cstacksize, focusmeasure, wsize )
%CSFFREC Summary of this function goes here
%   Detailed explanation goes here

m = measurement(1:cstacksize,:);

stack = imreadlist(imdata.images, @(x) x);
imgsize = size(imdata.z);

%% Reconstruction
lstack = reshape(stack, size(stack,1) * size(stack,2), size(stack,3));
cstack = m * lstack';
cstack = reshape(cstack', size(stack,1), size(stack,2), cstacksize);

%Compressed focus measure
cfmlin = focusmeasure.Calculate(cstack, wsize);

%Original Stack Size x Image Size x Linear Parts 
rfmlin = zeros(size(m,2), imgsize(1)*imgsize(2), focusmeasure.LinearPartsCount);

for i=1:size(cfmlin,3)
    rfmlin(:,:,i) = m'*cfmlin(:,:,i);
end

rfm = focusmeasure.FromLinear(rfmlin, imgsize, wsize);
[~, ofm] = focusmeasure.Calculate(stack, wsize);
%% Depthmap
[cz, ~] = sff2(rfm, 'focus', imdata.focus, 'filter', 5);
[z,  ~] = sff2(ofm, 'focus', imdata.focus, 'filter', 5);

%% Smoothing
WSize = 5;
MEANF = fspecial('average',[WSize WSize]);
cz = imfilter(cz, MEANF', 'replicate');
z = imfilter(z, MEANF', 'replicate');

end

