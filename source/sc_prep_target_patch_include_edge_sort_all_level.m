function trgPatch = sc_prep_target_patch_include_edge_sort_all_level(img, uvPixSub, optS, edge1)
% SC_PREP_TARGET_PATCH: Prepare target patches with centers uvPixSub
%
% Input:
%   - img:       input image
%   - uvPixSub:  target patch position
%   - optS:      parameter
%   - edge1      edge map
% Output:
%   - trgPatch: [pNumPix] x [3] x [numUvPix]

[imgH, imgW, nCh] = size(img);

% Updated target patch extraction
numUvPix = size(uvPixSub, 1);

% Prepare target patch position
uvPixSub    = reshape(uvPixSub', [1, 2, numUvPix]);
trgPatchPos = bsxfun(@plus, optS.refPatchPos(:,1:2), uvPixSub);

% Sample target patch
trgPatchInd = zeros(optS.pNumPix, nCh, numUvPix, 'single');

trgPatchInd0 = zeros(optS.pNumPix, 1, numUvPix, 'single');

%%%%%%%%%%%%%%%%%%%%%%%
trgPatchInd0(:, 1, :)= sub2ind([imgH, imgW, nCh], ...
    trgPatchPos(:,2,:), trgPatchPos(:,1,:), ...
    1*ones(optS.pNumPix, 1, numUvPix, 'single'));
trgPatchInd0X = squeeze(trgPatchInd0);

%Cal the sum of pixel value
valueEdgeToBeSorted = zeros(numUvPix, 1);
[numRow, numCol] = size(trgPatchInd0X);
valueEdge = 0;
for i = 1:numCol
    tempIndVector = trgPatchInd0X(:, i);
    row = imgH;
    valuePre = 0;
    for j = 1:numRow
        tempInd = tempIndVector(j);
        rowIndex = mod(tempInd, row);
        if(rowIndex==0)
            rowIndex = row;
        end
        colIndex = (tempInd - rowIndex) / row + 1;
        valueEdge = valuePre + edge1(rowIndex, colIndex);
        valuePre = valueEdge;
    end
    valueEdgeToBeSorted(i) = valueEdge;
end
%descending sort of valueEdgeToBeSort
[~, IndexBefore] = sort(valueEdgeToBeSorted, 1, 'DESCEND');
[~,nCh, numCol1] = size(trgPatchInd);


for k = 1:numCol1
    indexTemp = IndexBefore(k);
    trgPatchInd(:, 1, k) = trgPatchInd0X(:,indexTemp);
    trgPatchInd(:, 2, k) = trgPatchInd0X(:,indexTemp) + 1;
    trgPatchInd(:, 3, k) = trgPatchInd0X(:,indexTemp) + 2;
end
if(nCh > 1)

    temp = ones(optS.pNumPix, 1, numUvPix, 'single');
    trgPatchInd(:, 1, :) =  bsxfun(@plus,  trgPatchInd(:, 1, :), temp);
    trgPatchInd(:, 2, :) =  bsxfun(@plus,  trgPatchInd(:, 1, :), 2*temp);
    trgPatchInd(:, 3, :) =  bsxfun(@plus,  trgPatchInd(:, 1, :), 3*temp);
end


% Get target patch via indexing
trgPatch = img(trgPatchInd);

end