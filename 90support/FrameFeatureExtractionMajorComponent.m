function [FFMC kHankel] = FrameFeatureExtractionMajorComponent(FrameFeatures, HankelWindowSize, varargin)
% FFMC: FrameFeatureMajorComponent
% FFDynamics: FrameFeatureDynamics (FrameFeatureMajorComponent Analysize
% after the Hankel Matrix
nframes = size(FrameFeatures, 2);

if isempty(varargin)
    mode = 'ClipBasedDynamics';
else
    mode = varargin{1};
end
if length(varargin) > 1
    % pca_dim is pca_dimSVM
    pca_dim = varargin{2};
else
    pca_dim = 1;
end
 
switch mode
    case 'ClipBasedDynamics'
        
        idx = hankel(1:HankelWindowSize, HankelWindowSize:size(FrameFeatures, 2));
        k = FrameFeatures(:, idx);
        kHankel = reshape(k, size(idx, 1) * size(k, 1), size(idx, 2));
        [U S V] = svd(kHankel); 
%         FFMC = U(:, 1)';
        tempU = U(:, 1 : pca_dim); 
        FFMC = tempU(:)';
    case 'FrameBasedDynamics'
        FFDynamics = zeros(HankelWindowSize, nframes - (3 * HankelWindowSize) + 1);
        HalfHankelWindowSize = floor(HankelWindowSize / 2);
        for i = HalfHankelWindowSize + 1 : nframes - (3 * HalfHankelWindowSize)
            try
            idx = hankel(i - HalfHankelWindowSize : i + HalfHankelWindowSize, ...
                i + HalfHankelWindowSize : i + 3 * HalfHankelWindowSize);
            k = FrameFeatures(:, idx);
            kHankel = reshape(k, size(idx, 1) * size(k, 1), size(idx, 2));
            [U S V] = svd(kHankel');
            FFDynamics(:, i - HalfHankelWindowSize) = U(:, 1);
            catch ME
                display(ME);
                display(['i = ' num2str(i)]);
            end
        end
        FFMC = FrameFeatureExtractionMajorComponent(FFDynamics, HankelWindowSize, 'ClipBasedDynamics'); 
    case 'DCC_TransferredHankel'
        % See Classifier_DCC, mode OneHankelAsOneSet_SVM
        HankelMatrixBatchDCC = FrameFeatures; 
        T = HankelWindowSize; 
        % BugFixing. Gecko # 1;        
        FFMC = zeros(length(HankelMatrixBatchDCC), size(T, 2) * pca_dim);
        for i = 1 : length(HankelMatrixBatchDCC)
            [U S V] = svd(T' * HankelMatrixBatchDCC{i});
            tempU = U(:, 1 : pca_dim);
            FFMC(i, :) = tempU(:)';
        end
    case 'DCC_TransferredU'
        HankelMatrixBatchDCC = FrameFeatures; 
        T = HankelWindowSize; % pca_dim = 2;

        FFMC = zeros(length(HankelMatrixBatchDCC), size(T, 2) * pca_dim);
        for i = 1 : length(HankelMatrixBatchDCC)
            tempH = HankelMatrixBatchDCC{i};
            [N M] = size(tempH);
            [U S V] = svd(tempH * tempH');
%             [U S V] = svd(tempH * tempH' ./ M);
            Up = T' * U;
            tempA = Up(:, 1 : pca_dim);
%             [A S B] = svd(Up);

%             tempA = A(:, 1 : pca_dim);
            FFMC(i, :) = tempA(:)';
        end
    case 'nonHankel'
        nlength = size(FrameFeatures, 2);
        idx = reshape((1 : nlength - mod(nlength, HankelWindowSize)), HankelWindowSize, []);
        k = FrameFeatures(:, idx);
        kHankel = reshape(k, size(idx, 1) * size(k, 1), size(idx, 2));
        [U S V] = svd(kHankel); 
%         FFMC = U(:, 1)';
        tempU = U(:, 1 : pca_dim); 
        FFMC = tempU(:)';
end