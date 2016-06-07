%% Load image data
rng(0)

%% Non-Linear axial shift
% |focus| was set to be quadratic interpolation between |0.05 m| and |0.5 m|.
figure
subplot(1,2,1)
scatter(1:numel(imdata.focus),imdata.focus);
title('Axial Shift of the Focal Stack');
xlabel('Stack Sample');
ylabel('Axial Shift in m');

subplot(1,2,2)
subimage(imread(imdata.images{1}));

%% Parameters and values and original Image Stack
% |cstacksize| indicates the size of the compressed focal stack.
% |stack| is the complete image stack, whereas lstack is just a
% 2D-representation of |stack|. In this case, I was using a stack of 61
% images and a linear focus shift of 5 - 50 cm

cstacksize = 12; 
stack = imreadlist(imdata.images, @(x) x);
lstack = reshape(stack, size(stack,1) * size(stack,2), size(stack,3));

%% Calculate Focus Measure in each direction separately
% |fmeasurecube| returns a data-cube of the linear parts of LAPM in 
% x and y (|ofmx| and |ofmy| respectively). |9| here indicates the Window
% Size of the Mean Filter applied to the sum of absolutes, after the 
% convolution with [-1 2 -1] in x and y. The result is returned in |ofm|.

[ofmx, ofmy, ofm] = fmeasurecube(stack, 9);
imgsize = size(ofm);
imgsize = imgsize(1:2);
imgcount = size(ofm,3);

%% PCA
% I'm not sure if this is right. Although linear, adding the two filters 
% might induce data loss (?). |center()| just centeres the data by
% subtracting the mean from each dimension.

od = [ofmx ofmy];
[centered, m] = center(od);
[coeff, score] = pca(od);

%% Measurement Matrix and Compressed Focal Stack
% 
measurement = coeff(:,1:cstacksize)'*centered';
cstack = measurement * lstack';
cstack = reshape(cstack', size(stack,1), size(stack,2), cstacksize);

%% Reconstruct Filters
% |fmeasurecube| is again used to compute the filters in each direction:
% this time on the compressed focal stack. Using the transposed measurement 
% matrix, I try to recover the original filters. |buildlapmlin| caluclates
% the actual LAPM focus measure, by adding the sums of absolutes.

[cfmx, cfmy, cfm] = fmeasurecube(cstack, 9);
rfmx = measurement'*cfmx;
rfmy = measurement'*cfmy;
rfm = buildlapmlin(rfmx', rfmy', imgsize, 9);

%% Compressive SFF
% |sff2| is a modified version of Pertuz' |sff| , which accepts a Focus
% Measure Cube, instead of an image list.
WSize = 5;
MEANF = fspecial('average',[WSize WSize]);
[cz, cr] = sff2(rfm, 'focus', imdata.focus, 'filter', 5);
cz = imfilter(cz, MEANF', 'replicate');

%% Compare with original SFF
[z, r] = sff2(ofm, 'focus', imdata.focus, 'filter', 5);
z = imfilter(z, MEANF', 'replicate');

%% Display Results
showresult(imcrop(z,imdata.ROI),imcrop(cz, imdata.ROI),imcrop(imdata.z, imdata.ROI));
