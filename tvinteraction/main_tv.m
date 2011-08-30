vcm
% ClipNum = [0 1; 0 6; 0 19; 0 20; 0 22; 0 26; 0 28; 0 29;0 41; 0 47; 0 49; 0 50;...
%     1 1; 1 2; 1 3; 1 8; 1 12; 1 15; 1 16; 1 17; 1 29; 1 41; 1 43; 1 47; ...
%     2 6; 2 7; 2 8; 2 10; 2 11; 2 12; 2 13; 2 14; 2 16; 2 20; 2 24; 2 26];
ClipNum = []; 
tc = [1 : 6 8:16 18 : 28]'; 
ClipNum = cat(1, ClipNum, [0 * ones(length(tc), 1) tc]);
tc = [1 : 10 12 : 19 21 25 29 33 44 45 47 49]';
ClipNum = cat(1, ClipNum, [1 * ones(length(tc), 1) tc]);
% tc = [1 : 2 4 : 6 8 : 14: 16 18: 20 23 25 : 30 32 : 33 36 : 38 40 : 41 43: 45]';
% ClipNum = cat(1, ClipNum, [2 * ones(length(tc), 1) tc]);


% nwin = [8 16];   HankelWindowSize = 4;
nwin = [16 8];   HankelWindowSize = 4;
nClip = length(ClipNum);
PersonBatch = cell(nClip, 1);
infoBatch = PersonBatch;
HankelMatrixBatch = infoBatch;
h = waitbar(0, 'Please wait ...');
try
    for i = 1 : nClip
        Type = ClipNum(i, 1); Clip = ClipNum(i, 2);
        [srcdirI filenamesI] = rfdatabase(datadir_interaction(Type, 'tvinteraction'), [], '.avi');
        [srcdirA filenamesA] = rfdatabase(datadir_interaction(Type, 'tvinteractionAnnotation'), [], '.txt');
        filename = [srcdirI filenamesI{Clip}]; 
        filenameA = [srcdirA filenamesA{Clip}]; 

        info = readTVdatasetAnnotation(filenameA);  
        info.Type = Type; info.Clip = Clip;
%         if ClipNum(i, 1) <10
            infoBatch{i} = BoundingBoxRefine_tvinteraction(info);
%         else
%             infoBatch{i} = info;
%         end
        mat = movie2var(filename, 1, 1);
        PersonBatch{i} = Hog_in_BoundingBox(mat, infoBatch{i}, nwin);    
        HankelMatrixBatch{i} = constructHankelMatrix_tv(infoBatch{i}, PersonBatch{i}, HankelWindowSize);
        waitbar(i/nClip);
    end
    close(h);
catch ME
    display(['i = ' num2str(i)]);
    display(ME.stack(1).file)
    error(ME.message);
end
groupsLabel = ClipNum(:, 1);
% hand shaking and hand clapping : pca_dim = 6, pca_dimSVM from 1 : 6 : [0.56 0.64 0.60 0.48 0.48 0.48];
% [CorrectRate CPMatrix trainBatch] = Classifier_interaction(HankelMatrixBatch, groupsLabel, 'OneHankelAsOneSet_SVM_pcadimSVM_Batch', 1, 6, 'poly', (1:6)); mean(CorrectRate)
% % hand shaking and hand clapping : pca_dim = 6, pca_dimSVM from 1 : 6 : [0.56 0.64 0.60 0.48 0.48 0.48];
[CorrectRate CPMatrix trainBatch] = Classifier_interaction(HankelMatrixBatch, groupsLabel, 'OneHankelAsOneSet_SVM_pcadimSVM_Batch', 1, 6, 'poly', 2); mean(CorrectRate)
% [CorrectRate CPMatrix trainBatch] = Classifier_interaction(HankelMatrixBatch, groupsLabel, 'OneHankelAsOneSet_SVM_pcadimSVM_Batch', 1, 6, 'poly', 1); mean(CorrectRate)