function [FrameFeaturesBatch groups HankelMatrixType] = batchFrameFeatures_ManualTracking(k, selectFrames, HankelWindowSize)
%function [FrameFeaturesBatch groups HankelMatrixType] = batchFrameFeatures_MoreFeaturesTracking(k, selectFrames, HankelWindowSize)

% Extract the FrameFeatures into row per video. Firstly, just select the
% first 100 frames for each video.
% This is for the input of svmtrain and svmclassify.
% threshold = 100;
thresholdArea = 5;
% HankelWindowSize = 25;
pca_dim = 1;
nclusters = 5;
% load nclustersAllTypes_thByFrame_AreaTH
% FrameFeaturesBatch = zeros(200, 600);
% k = 2; % Handclapping
% selectFrames = [1 100];

% matlabpool open
ClipIdx = zeros(10: 6);
ClipIdx(:, 4) = [17;58;82;44;66;35;83;43;47;29;];
ClipIdx(:, 5) = [64;66;88;90;43;45;44;35;17;62;];
ClipIdx(:, 6) = [82;17;90;15;35;66;39;49;11;44;];
ClipIdx = sort(ClipIdx, 1);
[srcdirI filenamesI ] = rfdatabase(datadir(k, 'kth_selectFrames'), 'clip');
[srcdirB filenamesB] = rfdatabase(datadir(k, 'kthBoundingBox'), 'Person');
[srcdirM filenamesM n] = rfdatabase(datadir(k, 'kthManualTracking'), 'person');

FrameFeaturesBatch = zeros(n, 2 * (nclusters + 1) * HankelWindowSize * pca_dim);
HankelMatrixType = cell(n, 1);
% FrameFeaturesBatch = zeros(n, HankelWindowSize ^ 2);

for i = 1 : n
    LOAD = load([srcdirI filenamesI{ClipIdx(i, k + 1)}]);
    I = LOAD.I;
    LOAD = load([srcdirB filenamesB{ClipIdx(i, k + 1)}]);
    BoundingBox = LOAD.BoundingBox;
    LOAD = load([srcdirM filenamesM{i}]);
    
    
    % If the size of frames for BoundingBox is less than number of Frames in
    % original Video. Do the following:
    if size(BoundingBox, 1) < size(I, 3)
        BoundingBox2 = zeros(size(I, 3), 4);
        BoundingBox2(1 : size(BoundingBox, 1), :) = BoundingBox;
        BoundingBox = BoundingBox2;
    end
    
    if k >= 10
        BlueScreen = blueScreen(I, BoundingBox, 'extend');
        R = stfeaturesSelfKTH( BlueScreen, 2, 3, 1, 1e-5, [], 1.85, 1, 1, 0 );
    else
        % R_labelShow = ideaShow(I, 'BoundingBox', BoundingBox);
        % [R,subs,vals,cuboids,V] = stfeatures( I, 2, 3, 1, 1e-5, [], 1.85, 2, 1, 0 );
        %         R = stfeaturesSelfKTH( I, 2, 3, 1, 1e-5, [], 1.85, 1, 1, 0 );
%         R = stfeaturesSelfKTH( I, 1, 1.5, 1, 1e-5, [], 1.85, 1, 1, 0 );
        R = stfeaturesSelfKTH( I, 0.8, 1.2, 1, 1e-5, [], 1.85, 1, 1, 0 );
    end
    
    
    % R_labelShow = ideaShow(I, 'BoundingBox', BoundingBox);
    % [R,subs,vals,cuboids,V] = stfeatures( I, 2, 3, 1, 1e-5, [], 1.85, 2, 1, 0 );
    % R = stfeaturesSelfKTH( I, 2, 3, 1, eps, [], 1.85, 1, 1, 0 );
    % playM_asVideo(R);
    [R_rescale] = rescale(R, 0);
    
    threshold = thresholdSetting(R_rescale);
    [R_filt] = filtPerFrame(R_rescale, threshold);
    [R_label, s] = R_region(R_filt);
    
    % R_labelShow = ideaShow(R_label, 'LabelMatrix');
    
    % If mode is 'Centroid', the input should be: R_label
    % R_RegionPoint = RegionPoint(R_filt, s);
    % R_RegionPoint = RegionPoint(R_label, 'Centroid');
    % If mode is 'MaxIntensity', the input should be: (s, 'MaxIntensity', R)
    % R_RegionPoint = RegionPoint(s, 'MaxIntensity', R);
    % If mode is 'MaxIntensityArea', the input should be: (s, 'MaxIntensity', R)
    % R_RegionPoint = RegionPoint(s, 'MaxIntensityArea', R);
    % Add Bounding Box Information for all modes. Including Centroid.
    R_RegionPoint = RegionPoint(s, 'MaxIntensityArea', R);
    [R_RegionPoint s] = RegionsFitness(R_RegionPoint, s, thresholdArea, 'RegionArea');
    
    % close all; R_labelShow = ideaShow(R_RegionPoint, 'MaxIntensity', I);
    
    %     vector = structField2Vector(s, 'NumObjects');
    %     edges = min(vector) : max(vector);
    %     n = histc(vector, edges);
    %     stem(edges, n);
    %     [~, Idx] = max(n);    %clear C;
    %
    %     nclusters = edges(Idx);
    % Tricky part Force nclusters = 2
    %     nclusters = 3;
    display(['The main number of segment is ' num2str(nclusters)]);
    
    if k < 3
        [R_RegionFiltered sFiltered] = FeatureRegionFiltering(R_RegionPoint, s, nclusters, 'lr');
    else
        [R_RegionFiltered sFiltered] = FeatureRegionFiltering(R_RegionPoint, s, nclusters, 'tb');
    end
    
    % BoundingBox Refining, according to ncluster to decide the input
    % parameters.
    % If nclusters == 1
    % Using all the regions to decide the width.
    % If nclusters ~= 1
    % Only use the selected Regions to decide the width.
    if nclusters == 1
        BoundingBox = BoundingBoxRefine(s, BoundingBox, [120 160]);
        %     BoundingBox = BoundingBoxRefine(R_RegionFiltered, BoundingBox, [120 160]);
    else
        BoundingBox = BoundingBoxRefine(sFiltered, BoundingBox, [120 160]);
    end
    
    % R_labelShowBoundingBox = ideaShow(I, 'BoundingBox', BoundingBox);
    % R_labelShowBoundingBox = ideaShow(I, 'BoundingBox', BoundingBox, 0);
    
    % Person Body Position
    if k >= 10
        [sFiltered_Refined FrameBodyCentroidPoint] = BodyPosition(BlueScreen, BoundingBox);
        R_RegionPointCorr = FeatureRegionCorresponse(R_RegionFiltered, BlueScreen, [19 19], 'distance');
    else
        [sFiltered_Refined FrameBodyCentroidPoint] = BodyPosition(I, BoundingBox);
%         BoundingBox = LOAD.BoundingBox;
        FeaturesPos = LOAD.FeaturesPos;
        R_RegionPointCorr = LOAD.R_RegionPointCorr;
%         R_RegionPointCorr = FeatureRegionCorresponse(R_RegionFiltered, I, [15 15], 'order');
    end
    [vector idx] = FrameSelection_manualTracking(FeaturesPos);
    idx = logical(idx);
    R_RegionPointCorr = R_RegionPointCorr(idx);
    BoundingBox = BoundingBox(idx, :);
    FrameBodyCentroidPoint = FrameBodyCentroidPoint(idx, :);
    % R_labelShowRegions = ideaShow(sFiltered_Refined, 'labelmatrix');
    % R_labelShow = ideaShow(FrameBodyCentroidPoint, 'CentroidTwoColumns', R_labelShowBoundingBox);
    % R_labelShow = ideaShow(FrameBodyCentroidPoint, 'CentroidTwoColumns', I);
    
    
    
    %     if nclusters == 2
    %         R_RegionPointCorr = FeatureRegionCorresponse(R_RegionFiltered, I, [15 15], 'order');
    %     else
    %         R_RegionPointCorr = FeatureRegionCorresponse(R_RegionFiltered, I, [19 19], 'distance');
    %     end
    % R_RegionPointCorrCorrect = FeatureRegionCorresponseCorrect(R_RegionPointCorr);
    % R_RegionPointCorr = FeatureRegionCorresponse(R_RegionPoint, I, [17 17]);
    
%     rec = 0;
    % R_labelShow = ideaShow(R_RegionPointCorr, 'Corresponse', I, rec);
    % R_labelShow = ideaShow(R_RegionPointCorr, 'Corresponse', R_labelShowBoundingBox, rec);
    
    % FrameFeatures = FrameFeatureExtraction(R_RegionPointCorr, nclusters);
    % FrameFeatures = FrameFeatureExtraction(R_RegionPointCorr, BoundingBox, FrameBodyCentroidPoint, nclusters);
    % FrameFeatures = FrameFeatureExtraction(R_RegionPointCorr, BoundingBox, FrameBodyCentroidPoint, nclusters, 'relative');
    % FrameFeatures = FrameFeatureExtraction(R_RegionPointCorr, BoundingBox, FrameBodyCentroidPoint, nclusters, 'svm');
    
    % Changed on 31 Aug 2010
    FrameFeatures = FrameFeatureExtraction(R_RegionPointCorr, BoundingBox, FrameBodyCentroidPoint, nclusters, 'svm', selectFrames);
%     FrameFeatures = FrameFeatureExtractionRemoveDC(R_RegionPointCorr, BoundingBox, FrameBodyCentroidPoint, nclusters, 'svm', selectFrames);
    %         FrameFeaturesBatch((k - 1) * 100 + i, :) = FrameFeatures;
    % Changed for Task nonHankel 05 Sep 2010
    [FrameFeaturesBatch(i, :) HankelMatrixType{i}] = FrameFeatureExtractionMajorComponent(FrameFeatures, HankelWindowSize);
%     [FrameFeaturesBatch(i, :) HankelMatrixType{i}] = FrameFeatureExtractionMajorComponent(FrameFeatures, HankelWindowSize, 'nonHankel');
    %     FrameFeaturesBatch(i, :) = FrameFeatureExtractionMajorComponent(FrameFeatures, HankelWindowSize, 'FrameBasedDynamics');
    display(['Finish ' num2str(i)]);
end
% matlabpool close

% switch num2str(k)
%     case '0'
%         TypeName = 'boxing';
%     case '1'
%         TypeName = 'handclapping';
%     case '2'
%         TypeName = 'handwaving';
% end

% groups = repmat({TypeName}, n, 1);
groups = repmat(k, n, 1);

% FileName = ['Type_' TypeName '_FrameFeatures'];
% save(FileName, 'FrameFeaturesBatch', 'groups');