classdef DiagonalLaplacian < FocusMeasure
    %LAPM Lapalce Modified
    %   Focus measure: Modified Laplacian
    
    properties
       LinearPartsCount = 4
    end
    
    methods        
        function fm = FromLinear(~, fmcubelin, imgsize, wsize)
            meanf = fspecial('average',[wsize wsize]);

            width = imgsize(1);
            height = imgsize(2);

            fm = zeros(width, height, size(fmcubelin,1));

            for i=1:size(fm, 3)
                F1 = reshape(fmcubelin(i,:,1), width, height);                
                F2 = reshape(fmcubelin(i,:,2), width, height);
                F3 = reshape(fmcubelin(i,:,3), width, height);
                F4 = reshape(fmcubelin(i,:,4), width, height);
                
                fm(:,:,i) = imfilter(abs(F1) + abs(F2) + abs(F3) + abs(F4), meanf, 'replicate');
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
            M1 = [-1 2 -1];
            M2 = [0 0 -1;0 2 0;-1 0 0]/sqrt(2);
            M3 = [-1 0 0;0 2 0;0 0 -1]/sqrt(2);
          
            for i=1:size(images,3)
                
                image = images(:,:,i);
                
                F1 = imfilter(image, M1, 'replicate', 'conv');
                F2 = imfilter(image, M2, 'replicate', 'conv');
                F3 = imfilter(image, M3, 'replicate', 'conv');
                F4 = imfilter(image, M1', 'replicate', 'conv');
                
                fmlin(i,:,1) = F1(:);
                fmlin(i,:,2) = F2(:);        
                fmlin(i,:,3) = F3(:);        
                fmlin(i,:,4) = F4(:);        
                if nargout > 1
                    fm(:,:,i) = imfilter(abs(F1) + abs(F2) + abs(F3) + abs(F4), meanf, 'replicate');
                end
            end
        end
    end
    
end

