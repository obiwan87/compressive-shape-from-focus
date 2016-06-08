classdef ModifiedLaplacian < FocusMeasure
    %LAPM Lapalce Modified
    %   Focus measure: Modified Laplacian
    
    properties
       LinearPartsCount = 2
    end
    
    methods        
        function fm = FromLinear(~, fmcubelin, imgsize, wsize)
            meanf = fspecial('average',[wsize wsize]);

            width = imgsize(1);
            height = imgsize(2);

            fm = zeros(width, height, size(fmcubelin,1));

            for i=1:size(fm, 3)
                fmx = reshape(fmcubelin(i,:,1), width, height);                
                fmy = reshape(fmcubelin(i,:,2), width, height);
                
                fm(:,:,i) = abs(fmx) + abs(fmy);
                fm(:,:,i) = imfilter(fm(:,:,i), meanf, 'replicate');
            end
        end
        
        function [fm, fmlin] = Calculate(obj,images, wsize)                
            images = obj.readImages(images);          
            
            fm = zeros(size(images,1), size(images,2), size(images,3));
            fmlin = zeros(size(images,3), size(images,1)*size(images,2),...
                obj.LinearPartsCount);
            
            meanf = fspecial('average',[wsize wsize]);
            for i=1:size(images,3)
                M = [-1 2 -1];
                image = images(:,:,i);
                
                Lx = imfilter(image, M, 'replicate', 'conv');
                Ly = imfilter(image, M', 'replicate', 'conv');
                
                fmlin(i,:,1) = Lx(:);
                fmlin(i,:,2) = Ly(:);        
                fm(:,:,i) = imfilter(abs(Lx) + abs(Ly), meanf, 'replicate');
            end
        end
    end
    
end

