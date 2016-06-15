function [ z ] = depthmapshape( shape, im_size, zlimits)
%DEPTHMAPSHAPE Summary of this function goes here
%   Detailed explanation goes here

z0 = zlimits(1);
z1 = zlimits(2);

switch shape
    case 'plane'
        x = linspace(0, 0.5, im_size(2));
        y = linspace(0, 0.5, im_size(1))';
        z = meshgrid(x,y);
    case 'plane_squared'
        x = linspace(0, 1, im_size(2));
        y = linspace(0, 1, im_size(1))';
        z = y*x;
    case 'sphere'        
        x = linspace(-0.5, 0.5, im_size(2));
        y = linspace(-0.5, 0.5, im_size(1));
        [X,Y] = meshgrid(x,y);
        z = -sqrt(0.5-X.^2-Y.^2);        
    case 'cone'
        x = linspace(-0.5, 0.5, im_size(2));
        y = linspace(-0.5, 0.5, im_size(1));
        [X,Y] = meshgrid(x,y);
        z = sqrt(X.^2+Y.^2);
    case 'cos'
        x = linspace(-3*pi/4, 3*pi/4, im_size(2));
        y = linspace(-3*pi/4, 3*pi/4, im_size(1))';
        z = -cos(y)*cos(x);
end

z = (z1 - z0)*(z - min(z(:)))/(max(z(:)) - min(z(:))) + z0;

end

