classdef Identity < FocusMeasure
    %LAPM Identity
    %   Focus measure: Modified Laplacian
    
    properties
        LinearPartsCount = 1
    end
    
    methods
        function fm = FromLinear(~, fmcubelin, imgsize, wsize)
            meanf = fspecial('average',[wsize wsize]);
            
            width = imgsize(1);
            height = imgsize(2);
            
            fm = zeros(width, height, size(fmcubelin,1));
            
            for i=1:size(fm, 3)
                fm(:,:,i) = imfilter(reshape(fmcubelin(i,:,1), width, height), meanf, 'replicate');
            end
        end
        
        function [fmlin, fm] = Calculate(obj,images, wsize)
            images = obj.readImages(images);
            
            if nargout > 1
                fm = zeros(size(images,1), size(images,2), size(images,3));
            end
            
            fmlin = zeros(size(images,3), size(images,1)*size(images,2),...
                obj.LinearPartsCount);
            
            meanf = fspecial('average',[wsize wsize]);
            for i=1:size(images,3)
                image = images(:,:,i);
                
                fmlin(i,:,1) = image(:);
                
                if nargout > 1
                    fm(:,:,i) = imfilter(image, meanf, 'replicate');
                end
            end
        end
    end
    
end

