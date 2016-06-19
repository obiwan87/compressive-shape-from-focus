root_dir = '../data/img/';
results_dir = '../data/results';
path = [root_dir '%d'];

test_sets = {74, 75, 76, 77, 78, 79, 80, 81}; %{78:2:80, 79:2:81, 78:81, 74, 75, 76, 77, 78, 79, 80, 81}; 
training_sets = {74, 75, 76, 77, 78, 79, 80, 81}; %{74:2:76, 75:2:77, 74:77, 74, 75, 76, 77, 78, 79, 80, 81};

ops = {ModifiedLaplacian(), DiagonalLaplacian(), ImageCurvature(), Tenengrad(), ...
       TenengradVariance(), SteerableFilters() };

wsize = 9;
cstacksize = 6; 
results = {};
measurement_matrices = {};
timestamp = datetime('now', 'Format', 'yMMd-HHmmss');
for i=1:size(training_sets,2)
    fprintf('Training Set %d \n', i);
    training = loadimages(root_dir, training_sets{i});  
    test = loadimages(root_dir, test_sets{i});
    t = test_sets{i};
    
    for j=1:numel(ops)        
        fprintf('\t Focus Measure Operator: "%s" \n', class(ops{j}));               
        measurement = csfftrain(training, ops{j}, wsize);
        measurement_matrices{end+1} = measurement;
        for k=1:numel(test)            
            fprintf('\t\t Test Image %d of Set %d \n', k, i);
            [cz, z] = csffrec(test{k}, measurement, cstacksize, ops{j}, wsize);
            results{end+1,1} = test{k}.z;
            results{end,2} = z;
            results{end,3} = cz;
            results{end,4} = cstacksize;
            results{end,5} = wsize;
            results{end,6} = training_sets{i};
            results{end,7} = t(k);
            results{end,8} = test{k}.focus;                       
            results{end,9} = class(ops{j});
        end
    end
end

if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

variableNames = {'groundtruth', 'csff_z', 'sff_z', 'cstacksize', 'wsize', 'trainingset', 'testset', 'focus', 'fmop'};
save(fullfile(results_dir, [char(timestamp) '-exp1.mat']), 'results', 'test_sets', 'training_sets', 'measurement_matrices');

