function [ images ] = loadimages( root_dir, folders )
%LOADIMAGES Summary of this function goes here
%   Detailed explanation goes here

images = cell(size(folders));

for i=1:numel(folders)
    p = fullfile(root_dir, num2str(folders(i)));
    load(fullfile(p,'imdata.mat'));
    images{i} = imdata;
end

clear imdata

end