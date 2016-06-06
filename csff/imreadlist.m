function [ images ] = imreadlist( imagefiles, readFcn )
%IMREADLIST reads a list of equally sized images 
%   Detailed explanation goes here

if nargin < 2
    readFcn = @(x) x;
end
nfiles = length(imagefiles);    % Number of files found
firstimage = readFcn(imread(imagefiles{1}));

images = zeros(size(firstimage,1),size(firstimage,2),nfiles);
for i=1:nfiles   
   currentfilename = imagefiles{i};
   currentimage = readFcn(imread(currentfilename));
   images(:,:,i) = currentimage;
end
end

