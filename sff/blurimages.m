texmap = imread('C:/Users/thesp/home/uni/bildauswertung und -fusion/matlab/defocus/texture1.tif');

root_dir = '../data/img/';
t = dir(root_dir);
matches = regexp({t(logical([t.isdir])).name}, '[0-9]+', 'match');
folder = max(str2double(func.foldl(matches, {}, @(x,y) {x{:} y{:}})))+1;

focus = linspace(sqrt(0.03), sqrt(0.25), 100);
focus = focus .* focus;
path = '../data/img/%d';
shapes = {'sphere', 'plane', 'cos', 'plane_squared'};
first = folder;
paths = first:(first + numel(shapes) - 1);

d = pwd;

for i=1:numel(paths)
    p = sprintf(path, paths(i)); 
    mkdir(p);
    imdata = simblur(texmap, focus, p, 'shape', shapes{i}, 'zlimits', [0.05 0.11]);
    reconstruct
    save(fullfile(p, 'imdata.mat'), 'imdata', 'z', 'cz');
    fprintf('(%d) MSE: %2.3f\n', paths(i), immse(imdata.z, cz));
    cd(root_dir);
    zip(sprintf('%d.zip', paths(i)), sprintf('%d', paths(i)));
    cd(d);
end
