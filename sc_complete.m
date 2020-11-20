function sc_complete(imgFileName)

%This code is based on https://github.com/jbhuang0604/StructCompletion
%which is the re-implementation of the paper, Huang, J.B, Kang, S.B.,
%Ahuja, N., Kopf, J., 2014. Image completion using planar structure
%guidance. ACM Transactions on graphics (TOG) 33, 1-10.

% Set up required path
startup;

path = 'detectData'
%imgFileName = 'dort2.png';

[I,map,alpha] =imread( fullfile(path, imgFileName) ); 

Igray = rgb2gray(I);
new_alpha = Igray ~= 255;
new_alpha = 255*new_alpha;
 
imwrite(I, fullfile(path, imgFileName) ,'Alpha',new_alpha);

% Option parameters
[optA, optS] = sc_init_opt;

% optS.direction = direction;

% =========================================================================
% Planar structure extraction
% =========================================================================
fprintf('- Extract planar structures \n');
tic;
[img, mask, maskD, modelPlane, modelReg, optSD] = sc_extract_planar_structure(imgFileName, optA, optS);
tAnalysis = toc;
fprintf('Done in %6.3f seconds.\n\n', tAnalysis);

% =========================================================================
% Guided image completion
% =========================================================================
% Construct image pyramid for coarse-to-fine image completion
fprintf('- Construct image pyramid: \n');
tic;
% Create image pyramid
[imgPyr, maskPyr, scaleImgPyr] = sc_create_pyramid(img, maskD, optSD);
% Structure constraints
[modelPlane, modelReg] = sc_planar_structure_pyramid(scaleImgPyr, modelPlane, modelReg);
tImgPyramid = toc;
fprintf('Done in %6.3f seconds.\n\n', tImgPyramid);

% Completion by synthesis
fprintf('- Image completion using planar structure guidance \n');
tic;
imgPyr = sc_synthesis(imgPyr, maskPyr, modelPlane, modelReg, optSD);
tSynthesis = toc;
fprintf('Synthesis took %6.3f seconds.\n', tSynthesis);

% Return the top level
imgSyn = imgPyr{optS.topLevel};

imwrite(imgSyn, fullfile('result', [imgFileName(1:end-4), '_completion.png']));
end
