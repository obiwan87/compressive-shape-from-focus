function [fmx, fmy, fm] = fmeasurecube(imlist, WSize, varargin)      
    MEANF = fspecial('average',[WSize WSize]);
    
    if iscell(imlist)
        image = imread(imlist{1});
        P = numel(imlist);
    else 
        image = imlist(:,:,1);       
        P = size(imlist, 3);
    end
     
    M = size(image,1);
    N = size(image,2);
    
    
    fmx = zeros(P,M*N);
    fmy = zeros(P,M*N);
    fm = zeros(M,N,P);
    for i=1:P
        if iscell(imlist)
            image = imread(imlist{i});
        else 
            image = imlist(:,:,i);
        end
                
        [Lx, Ly] = lapmlin(im2double(image));
                
        fmx(i,:) = Lx(:);
        fmy(i,:) = Ly(:);        
        fm(:,:,i) = imfilter(abs(Lx) + abs(Ly), MEANF, 'replicate');
    end
end