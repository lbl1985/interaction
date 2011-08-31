function Classification_IPLED
% Comparing to mode: OneHankelAsOneSet_SVM, this mode is mainly for
% the convenient of different pca_dimSVM(recog_dim) under the same
% pca_dim(ang_dim) setting.
% Because, T(transfer function) is related to  pca_dim(ang_dim),
% unrelated to pca_dimSVM(recog_dim). Meanwhile, T calcualtion the
% the most expensive part of our algorithm. Therefore, if we just
% calculate T once for all pca_dimSVM settings. We can save big
% amount time.
img_dim_side = sqrt(size(HankelMatrixBatchDCC{1}, 1));
ang_dim = pca_dim; flag_dcc = 'ON';
img_dim = img_dim_side * img_dim_side; red_dim = img_dim_side * img_dim_side;
dcc_dim = red_dim;

c = 1000;   lambda = 1e-7;  kerneloption= 3;    verbose = 0;
%         kernel='gaussian';
%         kernel='poly';

n_pca_dimSVM = length(pca_dimSVM);
%         CorrectRate = zeros(n, 1);
%         CPMatrix = cell(n, 1);
Margin = zeros(n, 1);
wBatch = cell(n, 1);
groups = groupsLabel + 1;

%             matlabpool open
%         parfor k = 1 : n
for k = 1 : n
    if n == 1
        [train, test] = specialSetting_tvinteraction;
    else
        [train, test] = crossvalind('holdOut', groupsLabel);
    end
    n_set = floor(sum(train) / n_class);
    Pm = [];
    
    for i = 1 : n_class
        TrainingIdx = find((train & ismember(groupsLabel, Types(i))) == 1);
        for j = 1 : length(TrainingIdx )
            tempPm = Eigen_Decompose_Modify(HankelMatrixBatchDCC{TrainingIdx(j)}, 1, pca_dim);
            Pm = cat(2, Pm, tempPm(:, 1: pca_dim));
        end
    end
    T = Learn_DCC(Pm,n_class,n_set,pca_dim,red_dim);
    
    
    
    CorrectRate = zeros(n_pca_dimSVM, 1);
    CPMatrix = cell(n_pca_dimSVM, 1);
    
    for i = 1 : n_pca_dimSVM
        
        FF = FrameFeatureExtractionMajorComponent(HankelMatrixBatchDCC, T, 'DCC_TransferredU', pca_dimSVM(i));
        
        [xsup,w,b,nbsv]=svmmulticlassoneagainstall(FF(train, :),groups(train),n_class,c,lambda,kernel,kerneloption,verbose);
        %             [xsup,w,b,nbsv]=svmmulticlassoneagainstone(FF(train, :),groups(train),n_class,c,lambda,kernel,kerneloption,verbose);
        ypred = svmmultival(FF(test, :),xsup,w,b,nbsv,kernel,kerneloption);
        [CPMatrix{i} CorrectRate(i)] = confusionMatrix(ypred, groups(test));
        display(['ypred ' num2str(ypred')]);
        testind = find(test == 1);
        display(['groups(test)' num2str(testind')]);
        display(['Finish ' num2str(i)]);
    end
    %             wBatch{k} = w;
    %             Weight = w' * xsup;
    %             Margin(k) = 2/sqrt(sum(Weight.^2));
    
end

varargout{1} = Margin;
varargout{2} = wBatch;