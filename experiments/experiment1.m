root_dir = '../data/img/';
results_dir = '../data/results';
path = [root_dir '%d'];

training_sets = {74:2:76, 75:2:77, 74:77};
test_sets = {78:2:80, 79:2:81, 78:81}; 

ops = {ModifiedLaplacian(), DiagonalLaplacian(), ImageCurvature(), Tenengrad(), ...
       TenengradVariance(), SteerableFilters()};

wsize = 9;
cstacksize = 6; 
results = {};
timestamp = datetime('now', 'Format', 'yMMd-HHmmss');
for i=1:size(training_sets,2)
    fprintf('Training Set %d \n', i);
    for j=1:numel(ops)
        fprintf('\t Focus Measure Operator: "%s" \n', class(ops{j}));
        training = loadimages(root_dir, training_sets{i});         
        measurement = csfftrain(training, ops{j}, wsize);
        
        test = loadimages(root_dir, test_sets{i});
        for k=1:numel(test)            
            fprintf('\t\t Test Image %d of Set %d \n', k, i);
            [cz, z] = csffrec(test{k}, measurement, cstacksize, ops{j}, wsize);
            results{end+1,1} = training{i}.z;
            results{end,2} = z;
            results{end,3} = cz;
            results{end,4} = measurement;
            results{end,5} = cstacksize;
            results{end,6} = wsize;
            results{end,7} = training_sets{i};
            results{end,8} = i;
            results{end,9} = test{k};
            results{end,10} = class(ops{j});
        end
    end
end

if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

save(fullfile(results_dir, [char(timestamp) '-exp1.mat']), 'results');

