function imsavelist( root_dir, images )
%IMSAVELIST Summary of this function goes here
%   Detailed explanation goes here

for i=1:numel(images)
    p = fullfile(root_dir, sprintf('%d.tiff', i));
    imwrite(images{i}, p);
end

end

