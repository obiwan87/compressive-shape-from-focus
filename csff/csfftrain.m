function [ measurement ] = csfftrain( imdata, cstacksize, focusmeasure, wsize )
%CSFFTRAIN Summary of this function goes here
%   Detailed explanation goes here

%% Training
stack = imreadlist(imdata.images, @(x) x);
[~, ofmlin] = focusmeasure.Calculate(stack, wsize);

% Reshape linear parts such that each part contributes to more variables
od = reshape(ofmlin, size(ofmlin,1), size(ofmlin,2) * size(ofmlin,3));
[centered, ~] = center(od);
[coeff, ~] = pca(od);

measurement = coeff(:,1:cstacksize)'*centered';


end

