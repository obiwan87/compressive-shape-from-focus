%% test compression with "manual" pca
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'PCA');
image = imread(fullfile(pathname, filename));

if size(image,3) > 1
    image = rgb2gray(image);    
end
image = imresize(image, [256, 256]);
image = im2double(image);

m = mean(image);
centered = bsxfun(@minus,image,m);

covimage = centered * centered';
[V,D] = eig(covimage);
V = V(:,end:-1:1);

ncomp = 20;
finaldata = V(:,1:ncomp)'*centered;

recovered = V(:,1:ncomp)*finaldata + repmat(m,size(image,1),1);


figure
MSE = immse(recovered, image);

subplot(1,2,1), subimage(image), title('Original');
subplot(1,2,2), subimage(recovered), title('Recovered');

axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 
1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.5, 1,sprintf('\\bf MSE %f', MSE),'HorizontalAlignment' ...
,'center','VerticalAlignment', 'top')


%% test with MATLAB PCA
coeff = pca(image);
finaldata = coeff(:,1:ncomp)'*centered';
recovered = coeff(:,1:ncomp)*finaldata + repmat(m',1,size(image,1));
recovered = recovered';

figure
MSE = immse(recovered, image);

subplot(1,2,1), subimage(image), title('Original');
subplot(1,2,2), subimage(recovered), title('Recovered');

% and then, type:
axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 
1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.5, 1,sprintf('\\bf MSE %f', MSE),'HorizontalAlignment' ...
,'center','VerticalAlignment', 'top')
