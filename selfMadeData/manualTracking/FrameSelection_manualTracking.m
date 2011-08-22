function [vector idx] = FrameSelection_manualTracking(FeaturesPos)
nFrame = size(FeaturesPos, 3);
vector = zeros(nFrame, 1);
idx = vector;
count = 0;
for i = 1 : nFrame
    
    FrameFeaturePos = FeaturesPos(:, :, i) ~= 0;
    vector(i) = sum(FrameFeaturePos(:));
    if  vector(i) == 10
        count = count + 1;
    else
        if i~= 1 && idx(i-1) == 1
            idx(i - 1) = 0;            
        end
        count = 0;
    end
    if count >= 2
        idx(i) = 1;
    end
end
idx(end) = 0;