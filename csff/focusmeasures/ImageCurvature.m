classdef ImageCurvature < FocusMeasure
    %CURV Image Curvature (Helmli2001)
     properties
       LinearPartsCount = 4
    end
    
    methods        
        function fm = FromLinear(obj, fmcubelin, imgsize, wsize)
            width = imgsize(1);
            height = imgsize(2);
            
            meanf = fspecial('average',[wsize wsize]);
            fm = zeros(width, height, size(fmcubelin,1));
            
            for i=1:size(fm,3)
                FM = abs(fmcubelin(i,:,1));                
                for j=2:obj.LinearPartsCount
                    FM = FM + abs(fmcubelin(i,:,j));
                end
                fm(:,:,i) = imfilter(reshape(FM, width, height),meanf, ...
                    'replicate');
            end
        end
        
        function [fm, fmlin] = Calculate(obj,images, wsize)    
            meanf = fspecial('average',[wsize wsize]);
            images = obj.readImages(images); 
            
            M1 = [-1 0 1;-1 0 1;-1 0 1];
            M2 = [1 0 1;1 0 1;1 0 1];
            
            fm = zeros(size(images,1), size(images,2), size(images,3));
            fmlin = zeros(size(images,3), size(images,1)*size(images,2),...
                obj.LinearPartsCount);            
            
            for i=1:size(images,3)                
                image = images(:,:,i);
                
                P0 = imfilter(image, M1, 'replicate', 'conv')/6;
                P1 = imfilter(image, M1', 'replicate', 'conv')/6;
                P2 = 3*imfilter(image, M2, 'replicate', 'conv')/10 ...
                    -imfilter(image, M2', 'replicate', 'conv')/5;
                P3 = -imfilter(image, M2, 'replicate', 'conv')/5 ...
                    +3*imfilter(image, M2, 'replicate', 'conv')/10;
                
                
                fmlin(i,:,1) = P0(:);
                fmlin(i,:,2) = P1(:);
                fmlin(i,:,3) = P2(:);
                fmlin(i,:,4) = P3(:);                
                
                FM = abs(P0) + abs(P1) + abs(P2) + abs(P3);
                FM = imfilter(FM, meanf, 'replicate');          
                
                fm(:,:,i) = FM;
            end           
        end
    end
end

