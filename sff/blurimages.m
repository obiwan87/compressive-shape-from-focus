root_dir = '../data/img/';
path = '../data/img/%d';

focus = linspace(sqrt(0.03), sqrt(0.25), 100);
focus = focus .* focus;

d = pwd;

imds = imageDatastore('../data/textures/');
imds.ReadFcn = @(x) im2double(imresize(imread(x), [360 360]));
textures = imds.readall;

shapes = {'sphere', 'plane'};

for j=2:numel(textures)
    texmap = textures{j}; 
    fprintf('Blurring Texture %d \n', j);
    for i=1:numel(shapes)    
        t = dir(root_dir);
        matches = regexp({t(logical([t.isdir])).name}, '[0-9]+', 'match');
        folder = max(str2double(func.foldl(matches, {}, @(x,y) {x{:} y{:}})))+1;    
        p = sprintf(path, folder); 
        
               
        mkdir(p);
        imdata = simblur(texmap, focus, p, 'shape', shapes{i}, 'zlimits', [0.05 0.11]);
        save(fullfile(p, 'imdata.mat'), 'imdata'); %, 'z', 'cz');
        
        %fprintf('(%d) MSE: %2.3f\n', paths(i), immse(imdata.z, cz));
        cd(root_dir);
        zip(sprintf('%d.zip', folder), sprintf('%d',folder));
        cd(d);
    end
end