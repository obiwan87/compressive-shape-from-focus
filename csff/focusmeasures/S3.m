classdef S3 < FocusMeasure
    %S3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        LinearPartsCount = 0;
    end
    
    methods
        function fm = FromLinear(obj, fmcubelin, imgsize, wsize)
            fm = 0;
        end
        function [fmlin, fm] = Calculate(obj,images, wsize)                
            images = obj.readImages(images);          
            
            if nargout > 1
                fm = zeros(size(images,1), size(images,2), size(images,3));
            end
            
            fmlin = 0;
            for i=1:size(images,3)            
                image = images(:,:,i);
                
                if nargout > 1
                    [~,~,s3] = s3_map(mat2gray(image)*255,false);
                    fm(:,:,i) = s3;
                end
            end
        end
    end
    
end

