classdef Tenengrad < FocusMeasure
    %TENENGRAD Tenengrad (Krotkov86)
    
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
                
                fm(:,:,i) = fmx.^2 + fmy.^2;
                fm(:,:,i) = imfilter(fm(:,:,i), meanf, 'replicate');
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
            sx = fspecial('sobel');
            
            for i=1:size(images,3)            
                image = images(:,:,i);
                
                Gx = imfilter(image, sx, 'replicate', 'conv');
                Gy = imfilter(image, sx', 'replicate', 'conv');
                
                fmlin(i,:,1) = Gx(:);
                fmlin(i,:,2) = Gy(:);        
                
                if nargout > 1
                    fm(:,:,i) = imfilter(Gx.^2 + Gy.^2, meanf, 'replicate');
                end
            end
        end
    end
end

