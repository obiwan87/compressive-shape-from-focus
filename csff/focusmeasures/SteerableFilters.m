classdef SteerableFilters< FocusMeasure
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
                R(:,:,1) = reshape(fmcubelin(i,:,1), width, height);
                R(:,:,2) = reshape(fmcubelin(i,:,2), width, height);
                R(:,:,3) = cosd(45)*R(:,:,1)+sind(45)*R(:,:,2);
                R(:,:,4) = cosd(135)*R(:,:,1)+sind(135)*R(:,:,2);
                R(:,:,5) = cosd(180)*R(:,:,1)+sind(180)*R(:,:,2);
                R(:,:,6) = cosd(225)*R(:,:,1)+sind(225)*R(:,:,2);
                R(:,:,7) = cosd(270)*R(:,:,1)+sind(270)*R(:,:,2);
                R(:,:,7) = cosd(315)*R(:,:,1)+sind(315)*R(:,:,2);    
                
                fm(:,:,i) = imfilter(max(R,[],3), meanf, 'replicate');
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
                
                N = floor(wsize/2);
                sig = N/3;
                [x,y] = meshgrid(-N:N, -N:N);
                G = exp(-(x.^2+y.^2)/(2*sig^2))/(2*pi*sig);
                Gx = -x.*G/(sig^2);Gx = Gx/sum(Gx(:));
                Gy = -y.*G/(sig^2);Gy = Gy/sum(Gy(:));
                
                R(:,:,1) = imfilter(image, Gx, 'conv', 'replicate'); 
                F1 = R(:,:,1);
                R(:,:,2) = imfilter(image, Gy, 'conv', 'replicate'); 
                F2 = R(:,:,2);
                
                fmlin(i,:,1) = F1(:);
                fmlin(i,:,2) = F2(:);                
                
                if nargout > 1
                    R(:,:,3) = cosd(45)*R(:,:,1)+sind(45)*R(:,:,2);
                    R(:,:,4) = cosd(135)*R(:,:,1)+sind(135)*R(:,:,2);
                    R(:,:,5) = cosd(180)*R(:,:,1)+sind(180)*R(:,:,2);
                    R(:,:,6) = cosd(225)*R(:,:,1)+sind(225)*R(:,:,2);
                    R(:,:,7) = cosd(270)*R(:,:,1)+sind(270)*R(:,:,2);
                    R(:,:,7) = cosd(315)*R(:,:,1)+sind(315)*R(:,:,2);    
                    fm(:,:,i) = imfilter(max(R,[],3), meanf, 'replicate');
                end
            end
        end
    end
    
end

