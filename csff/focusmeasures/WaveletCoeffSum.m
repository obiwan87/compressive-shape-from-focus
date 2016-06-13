classdef WaveletCoeffSum < FocusMeasure
    %TENENGRAD Tenengrad (Krotkov86)
    
    properties
       LinearPartsCount = 3
    end
    
    methods        
        function fm = FromLinear(~, fmcubelin, imgsize, wsize)
            meanf = fspecial('average',[wsize wsize]);

            width = imgsize(1);
            height = imgsize(2);

            fm = zeros(width, height, size(fmcubelin,1));

            for i=1:size(fm, 3)
                H = reshape(fmcubelin(i,:,1), width, height);                
                V = reshape(fmcubelin(i,:,2), width, height);
                D = reshape(fmcubelin(i,:,3), width, height);
                
                fm(:,:,i) = imfilter(abs(H) + abs(V) + abs(D), meanf, 'replicate');
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
                
               [C,S] = wavedec2(image, 1, 'db6');
               H = wrcoef2('h', C, S, 'db6', 1);   
               V = wrcoef2('v', C, S, 'db6', 1);   
               D = wrcoef2('d', C, S, 'db6', 1);      
               
               fmlin(i,:,1) = H(:);
               fmlin(i,:,2) = V(:);
               fmlin(i,:,3) = D(:);
                
                if nargout > 1
                    fm(:,:,i) = imfilter( abs(H) + abs(V) + abs(D), meanf, 'replicate');
                end
            end
        end
    end
end