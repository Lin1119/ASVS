function [w]=gausskernel(x1,y1,x,y,sigma)
% getting a distance weight for each point using a Gaussian filter

% By Lin Shen -- University of Leeds
w=1/(2*pi*sigma^2)*exp(-1*((x1-x)^2+(y1-y)^2)/(2*sigma^2));
end