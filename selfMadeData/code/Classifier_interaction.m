function [CorrectRate CPMatrix varargout] = Classifier_interaction(HankelMatrixBatchDCC, groupsLabel, mode, varargin)
Types = unique(groupsLabel);
n_class = length(Types);
n = varargin{1}; pca_dim = varargin{2}; kernel = varargin{3};
if length(varargin) == 4
    pca_dimSVM = varargin{4};
else
    pca_dimSVM = 1;
end

switch mode
    case 'OneHankelAsOneSet_SVM'
        %n_set = 50; %pca_dim = 15;
        img_dim_side = sqrt(size(HankelMatrixBatchDCC{1}, 1));
        ang_dim = pca_dim; flag_dcc = 'ON';
        img_dim = img_dim_side * img_dim_side; red_dim = img_dim_side * img_dim_side;
        dcc_dim = red_dim;
        
        c = 1000;   lambda = 1e-7;  kerneloption= 2;    verbose = 0;
        %         kernel='gaussian';
        %         kernel='poly';
        
        
        CorrectRate = zeros(n, 1);
        CPMatrix = cell(n, 1);
        trainBatch = zeros(n, length(groupsLabel));
        Margin = zeros(n, 1);
        wBatch = cell(n, 1);
        groups = groupsLabel + 1;
        
        %             matlabpool open
        %         parfor k = 1 : n
        for k = 1 : n
            if n == 1
                [train, test] = specialSetting(groupsLabel);
            else
                [train, test] = crossvalind('holdOut', groupsLabel);
            end
            trainBatch(k, :) = train';
            n_set = floor(sum(train) / n_class);
            Pm = [];
            for i = 1 : n_class
                TrainingIdx = find((train & ismember(groupsLabel, Types(i))) == 1);
                for j = 1 : length(TrainingIdx )
                    tempPm = Eigen_Decompose(HankelMatrixBatchDCC{TrainingIdx(j)}, 1);
                    Pm = cat(2, Pm, tempPm(:, 1: pca_dim));
                end
            end
            
            T = Learn_DCC(Pm,n_class,n_set,pca_dim,red_dim);
%             T = eye(size(Pm, 1));
            save T;
            FF = FrameFeatureExtractionMajorComponent(HankelMatrixBatchDCC, T, 'DCC_TransferredHankel', pca_dimSVM);
%             FF = FrameFeatureExtractionMajorComponent(HankelMatrixBatchDCC, T, 'DCC_TransferredU', pca_dimSVM);
            
            [xsup,w,b,nbsv]=svmmulticlassoneagainstall(FF(train, :),groups(train),n_class,c,lambda,kernel,kerneloption,verbose);
            %             [xsup,w,b,nbsv]=svmmulticlassoneagainstone(FF(train, :),groups(train),n_class,c,lambda,kernel,kerneloption,verbose);
            ypred = svmmultival(FF(test, :),xsup,w,b,nbsv,kernel,kerneloption);
            [CPMatrix{k} CorrectRate(k)] = confusionMatrix(ypred, groups(test));
            wBatch{k} = w;
            Weight = w' * xsup;
            Margin(k) = 2/sqrt(sum(Weight.^2));
            display(['Finish ' num2str(k)]);
        end
        
        varargout{1} = trainBatch;
%         varargout{2} = wBatch;
    case 'OneHankelAsOneSet_NN'
        %n_set = 50; %pca_dim = 15;
        img_dim_side = sqrt(size(HankelMatrixBatchDCC{1}, 1));
        ang_dim = pca_dim; flag_dcc = 'ON';
        img_dim = img_dim_side * img_dim_side; red_dim = img_dim_side * img_dim_side;
        dcc_dim = red_dim;
        recog_dim = 2; nn = 5;
        
        c = 1000;   lambda = 1e-7;  kerneloption= 2;    verbose = 0;
        %         kernel='gaussian';
        %         kernel='poly';
        
        
        CorrectRate = zeros(n, 1);
        CPMatrix = cell(n, 1);
        Margin = zeros(n, 1);
        wBatch = cell(n, 1);
        groups = groupsLabel + 1;
        
        %             matlabpool open
        %         parfor k = 1 : n
        for k = 1 : n
            if n == 1
                [train, test] = specialSetting(groupsLabel);
            else
                [train, test] = crossvalind('holdOut', groupsLabel);
            end
            trainBatch(k, :) = train';
            n_set = floor(sum(train) / n_class);    Pm = [];
            PBatch = cell(length(HankelMatrixBatchDCC), 1);
            % P for all Hankel Matrix
            for i = 1 : length(HankelMatrixBatchDCC)
                PBatch{i} = Eigen_Decompose(HankelMatrixBatchDCC{i}, 1);
            end
            
            for i = 1 : n_class
                TrainingIdx = find((train & ismember(groupsLabel, Types(i))) == 1);
                for j = 1 : length(TrainingIdx )
                    tempPm = PBatch{TrainingIdx(j), 1};
                    Pm = cat(2, Pm, tempPm(:, 1: pca_dim));
                end
            end
            
            T = Learn_DCC(Pm,n_class,n_set,pca_dim,red_dim);
%             T = eye(size(Pm, 1));
            
            comm = ['save Recog_DCC_angdim' num2str(ang_dim) 'RemoveDC.mat PBatch T groups train test ang_dim recog_dim'];
            eval(comm);
            %             ypred = Recog_DCC(PBatch, T, groups, train, test, ang_dim);
            ypred = Recog_DCC(PBatch, T, groups, train, test, ang_dim, recog_dim, nn);
            %             FF = FrameFeatureExtractionMajorComponent(HankelMatrixBatchDCC, T, 'DCC_TransferredHankel');
            %
            %             [xsup,w,b,nbsv]=svmmulticlassoneagainstall(FF(train, :),groups(train),n_class,c,lambda,kernel,kerneloption,verbose);
            %             %             [xsup,w,b,nbsv]=svmmulticlassoneagainstone(FF(train, :),groups(train),n_class,c,lambda,kernel,kerneloption,verbose);
            %             ypred = svmmultival(FF(test, :),xsup,w,b,nbsv,kernel,kerneloption);
            [CPMatrix{k} CorrectRate(k)] = confusionMatrix(ypred, groups(test));
            display(['Finish ' num2str(k)]);
        end
        
        varargout{1} = trainBatch;
%         varargout{2} = wBatch;
end