function FrameFeatures = FrameFeatureExtraction_interaction(FeaturePos)
nclusters = 5;
nframe = size(FeaturePos, 3);
FrameFeatures = [];

for i = 1 : nframe 
    tempFeaturePos = FeaturePos(:, :, i);    
    tempFeatureBasePoint = FeaturePos(1, :, i);
    tempFeatureBaseHeight = max(tempFeaturePos(4 : 5, 2)) - tempFeaturePos(1, 2);
    
    singleFeature = zeros(2 * nclusters, 1);
    for j = 1 : nclusters
        idx = [(j - 1) * 2 + 1 : (j - 1) * 2 + 2];
        singleFeature(idx) = (tempFeaturePos(j, :) - tempFeatureBasePoint)';
%         singleFeature(idx) = (FeaturePos(j, :, i + 1) - tempFeaturePos(j, :))';
    end
    singleFeature = singleFeature ./ repmat(tempFeatureBaseHeight, 2 * nclusters, 1);
    singleFeature = singleFeature(3 : end);
    FrameFeatures = cat(2, FrameFeatures, singleFeature);
    
end
