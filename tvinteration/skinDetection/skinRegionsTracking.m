% function diffMatrix = skinRegionsTracking(skinRegions)
function diffMatrix = skinRegionsTracking(mat, skinRegions)
[nframe numRegions]= size(skinRegions);
diffMatrix = zeros(numRegions, numRegions, nframe-1);
siz = size(mat);

% matlabpool open
for i = 1 : nframe-1
    diffM = zeros(numRegions, numRegions);   
    currFrame = mat(:, :, :, i);
    nextFrame = mat(:, :, :, i + 1);
%     cskinRegion = skinRegions(i, :);
%     nskinRegion = skinRegions(i + 1, :);
    
    for j = 1 : numRegions
        for k = 1 : numRegions
            currMask = zeros(siz(1:2));
            nextMask  = currMask;    
            currMask(skinRegions{i, j}) = 1;
            nextMask(skinRegions{i + 1, k}) = 1;
            
            cskinRegionReal = double(currFrame) .* repmat(currMask, [1 1 3]);
            nskinRegionReal = double(nextFrame) .* repmat(nextMask, [1 1 3]);
            diffM(j, k) = norm3d(cskinRegionReal, nskinRegionReal);
            diffM(k, j) = diffM(j, k);
        end
    end
    diffMatrix(:, :, i) = diffM;
    display(['i = ' num2str(i)]);
end

% matlabpool close        