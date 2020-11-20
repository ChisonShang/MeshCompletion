close all  
clear  
clc  
 
path = 'E:\Program Files\MATLAB\StructCompletion-master\data\';
imgFileName = 'cvtest.png';
 
[I,map,alpha] =imread( fullfile(path, imgFileName) ); 
%figure,imshow(I)
 
Igray = rgb2gray(I);
[x,y] = size(Igray);
new_alpha = Igray ~= 255;
new_alpha = 255*new_alpha;
%figure, imshow(new_alpha);
 
imwrite(I, fullfile(path, imgFileName) ,'Alpha',new_alpha);
 
% [I,map,alpha] = imread(fullfile(path, imgFileName)); ?
%figure, imshow(alpha);