texmap = imread('C:\Users\thesp\home\uni\bildauswertung und -fusion\matlab\defocus\texture1.tif');

focus = linspace(sqrt(0.02), 1.00, 100);
focus = focus .* focus;

path = 'C:\Users\thesp\home\uni\bildauswertung und -fusion\data\img\12';
mkdir(path);
imdata = simblur(texmap, focus, path, 'shape', 'plane');

save(fullfile(path, 'imdata.mat'), 'imdata');
 
path = 'C:\Users\thesp\home\uni\bildauswertung und -fusion\data\img\13';
mkdir(path);
imdata = simblur(texmap, focus, path, 'shape', 'sphere');
 
save(fullfile(path, 'imdata.mat'), 'imdata');