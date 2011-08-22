% function main_svm_classifier
FF = []; groupsLabel = []; HankelMatrixBatch = [];
selectFrames = [1 150];
% batchHankelWindowSize = [10 15 20 24 25 30 35];
batchHankelWindowSize = 48;
for i = 1 : length(batchHankelWindowSize)
    HankelWindowSize = batchHankelWindowSize(i); 
%     for k = [0 2 3 4]
    for k = [3 4 5]
        [FrameFeaturesBatch groups HankelMatrixType] = batchFrameFeatures_ManualTracking(k, selectFrames, HankelWindowSize);
        FF = cat(1, FF, FrameFeaturesBatch);
        HankelMatrixBatch = cat(1, HankelMatrixBatch, HankelMatrixType);
        groupsLabel = cat(1, groupsLabel, groups);
    end
    comm = ['save MovingTypesHWS' num2str(HankelWindowSize) 'ManualTracking'];
%     comm = ['save First5TypesHWS' num2str(HankelWindowSize) 'RemoveDC'];
    eval(comm);
    clear FrameFeaturesBatch groups HankelMatrixType
    FF = []; groupsLabel = []; HankelMatrixBatch = [];
end