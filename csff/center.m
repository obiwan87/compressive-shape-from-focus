function [ centered, m ] = center( d )
%CENTER Summary of this function goes here
%   Detailed explanation goes here

m = mean(d);
centered = bsxfun(@minus,d,m);


end

