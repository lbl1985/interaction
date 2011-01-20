% function diffMatrix = skinRegionsTracking(skinRegions)
function diffMatrix = skinRegionsTracking(im, skinRegions)
[nframe numRegions]= size(skinRegions);
diffMatrix = zeros(numRegions, numRegions, nframe);
% matlabpool open
for i = 1 : nframe
    diffM = zeros(numRegions, numRegions);   
    for j = 1 : numRegions
        for k = j : numRegions
            if k == j
                diffM(j, k) = inf;
            else
                diffM(j, k) = norm3d(skinRegions{i, j}, skinRegions{i, k});
                diffM(k, j) = diffM(j, k);
            end
        end
    end
    diffMatrix(:, :, i) = diffM;
    display(['i = ' num2str(i)]);
end

% matlabpool close        