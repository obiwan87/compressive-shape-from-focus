function [ measurement ] = csfftrain( images, focusmeasure, wsize )
%CSFFTRAIN Summary of this function goes here
%   Detailed explanation goes here

%% Training

%TODO: Multiple datasets: just stack together the linear parts along their
%columns (dim = 2)

if(~iscell(images)) 
    images = {images};
end

imgsize = size(images{1}.z);
imgcount = numel(images{1}.images);
area = imgsize(1)*imgsize(2);

ofmlin = zeros(imgcount, area*numel(images), focusmeasure.LinearPartsCount);

for i=1:numel(images)
    imdata = images{i};
    stack = imreadlist(imdata.images, @(x) x);
    fmlin = focusmeasure.Calculate(stack, wsize);
    ofmlin(:,((i-1)*area + 1):(i*area),:) = fmlin;
end
% Reshape linear parts such that each part contributes to more variables
od = reshape(ofmlin, size(ofmlin,1), size(ofmlin,2) * size(ofmlin,3));
[centered, ~] = center(od);
[coeff, ~] = pca(od);

measurement = coeff'*centered';


end

