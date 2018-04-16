function [ dist ] = distance_stiefel( x,y,n,p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

v=logmap_Stiefel(x,y,n,p);
dist=norm(v,'fro');


end

