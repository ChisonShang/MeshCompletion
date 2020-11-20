function [img, mask, maskD, modelPlane, modelReg, optSD] = sc_extract_planar_structure(imgFileName, optA, optS)

% SC_EXTRACT_PLANAR_STRUCTURE
% 
% Input:
%   - imgFileName: image file name in PNG (with alpha channel)
%   - optA: parameters for analysis stage.
% Output:
%   - img:        Original image
%   - mask:       Hole mask
%   - modelPlane: Plane model
%   - modelReg:   Regularity model
%
% modelReg
% modelReg.plane{indPlane}.dispVec
% modelReg.plane{indPlane}.costMapReg

% Default parameter
% modelPlane.numPlane = 1;
% modelPlane.plane{1}.vLine = [0 0];

% Read image and hole mask 
[img, ~, alpha] = imread(fullfile('detectData', imgFileName));
%����mask
%[alpha1,~,~] = imread('E:\Program Files\MATLAB\StructCompletion-master\data\CtestMask.png');
%figure,imshow(img)
%figure,imshow(alpha1)

mask = alpha ~= 255;
img  = im2double(img);

% 
mask = imdilate(mask, strel('square', 5));

maskD = imdilate(mask, strel('diamond', 1));

% Extract planar constructural constraints
modelPlane = sc_extract_plane(imgFileName, img, maskD, optA);

% Extract regularity constraints
[modelReg,optSD] = sc_extract_regularity(img, maskD, modelPlane, optA, optS);

% Convert mask and dilated mask to double type
mask  = im2double(mask);   % User-specified mask
maskD = im2double(maskD);  % Use dilated mask for image completion (for Poisson reconstruction)

end