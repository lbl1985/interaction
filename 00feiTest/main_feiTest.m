clc
baseFolder = getProjectBaseFolder();
[srcdir filenames n] = rfdatabase(fullfile(getProjectBaseFolder(), ...
    '00feiTest', 'testData'), [], '.mat');
HankelWindowSize = 4;
pca_dim = 1;

fid = fopen('results.txt', 'w');


for pca_dim = 1
    for HankelWindowSize = 3 : 7
        fprintf(fid, '%s\n', ['pca_dim: ' num2str(pca_dim) ' HankelWindowSize: ' num2str(HankelWindowSize)]);
        for i = 2
            I = load(fullfile(srcdir, filenames{i}));
            I = I.I;
            nVideo = size(I, 2);    nManifold = size(I, 1);
            HankelMatrixBatch = cell(nVideo, nManifold);
            if ~strcmp(filenames{i}(end-8 : end-4), 'IPLDE')
                for j = 1 : nVideo
                    HankelMatrixBatch{j} = hankelConstruction(I{j}', HankelWindowSize);
                end
                groupsLabel = [zeros(nVideo/2, 1); ones(nVideo/2, 1)];
                try
                    [CorrectRate CPMatrix trainBatch] = Classifier_interaction(HankelMatrixBatch, groupsLabel, 'OneHankelAsOneSet_SVM_pcadimSVM_Batch', 1, pca_dim, 'poly', 2);
                catch ME
                    fprintf(fid, '%s\n', [filenames{i}(1:end-4) ': error']);
                end
                fprintf(fid, '%s\n', [ filenames{i}(1:end-4) 'AR: ' num2str(CorrectRate)]);
                display([ filenames{i}(1:end-4) 'AR: ' num2str(CorrectRate)]); 
            else
                ypred = cell(nManifold, 1); ypredMatrix = ypred;
                for k = 1 : nManifold
                    for j = 1 : nVideo
                        HankelMatrixBatch{j, k} = hankelConstruction(I{k, j}', HankelWindowSize);
                    end
                    groupsLabel = [zeros(nVideo/2, 1); ones(nVideo/2, 1)];
                    [~, ~, ~, ~, ypred{k}, ypredMatrix{k}] = Classifier_interaction(HankelMatrixBatch(:, k), groupsLabel, 'OneHankelAsOneSet_SVM_pcadimSVM_Batch', 1, pca_dim, 'poly', 2);
                end
                [CorrectRate CPMatrix] = afterClassification_IPLDE(ypred, ypredMatrix, groupsLabel);
            end
        end
    end
end

send_mail_message('herbert19lee', 'batchRun is Done', 'FYI');
fclose(fid);
