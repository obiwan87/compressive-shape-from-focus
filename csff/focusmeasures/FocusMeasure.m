classdef (Abstract) FocusMeasure < handle
    %FOCUSMEASURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        LinearPartsCount
    end
    
    methods (Abstract, Access=public)
        fm = FromLinear(fmcubelin, imgsize, wsize)
        [fmlin, fm] = Calculate(images, wsize)        
    end
    
    methods (Access=protected) 
        function images = readImages(~, imlist) 
            if iscell(imlist)
                image = imread(imlist{1});
                P = numel(imlist);
                
                images = zeros([size(image) P]);
                images(:,:,1) = image;
                
                for i=2:P
                    images(:,:,i) = mat2gray(imread(imlist{i}));
                end            
            else 
                images = imlist;
            end
        end
    end
    
end

