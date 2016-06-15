root_dir = '../data/img/';
results_dir = '../data/results';

datasets = loadimages(root_dir, 74:81);
stacksizes = unique([5:2:100 100]);
cstacksizes = 2:6;

results2 = {};
wsize = 9;
for i=1:numel(datasets)
    imdata = datasets{i};
    
    err = zeros(numel(stacksizes), 1);
    for j=1:numel(stacksizes)
        subset = unique(round(1:(100/stacksizes(j)):100));
        z = sff(imdata.images(subset), 'focus', imdata.focus(subset), 'fmeasure', 'LAPM', 'nhsize', wsize);
        err(j) = immse(z, imdata.z);
    end
    
    results2{end+1,1} = err;
    
    err = zeros(numel(cstacksizes), 1);
    m = csfftrain(imdata, ModifiedLaplacian(), 9);
    for j=1:numel(cstacksizes)
        cz = csffrec(imdata,m,cstacksizes(j),ModifiedLaplacian(),9);
        err(j) = immse(cz, imdata.z);        
    end
    results2{end,2} = err;
end

save(fullfile(results_dir, [char(timestamp) '-exp2.mat']), 'results2');
