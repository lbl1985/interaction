clc
baseFolder = getProjectBaseFolder();
[srcdir filenames n] = rfdatabase(fullfile(getProjectBaseFolder(), ...
    '00feiTest', 'testData'), [], '.mat');
HankelWindowSize = 3;
pca_dim = 5;

fid = fopen('results.txt', 'w');


for pca_dim = 5 : 7
    for HankelWindowSize = 3 : 7
        fprintf(fid, '%s\n', ['pca_dim: ' num2str(pca_dim) ' HankelWindowSize: ' num2str(HankelWindowSize)]);
        for i = 1: n
            I = load(fullfile(srcdir, filenames{i}));
            I = I.I;
            nVideo = length(I);
            HankelMatrixBatch = cell(nVideo, 1);
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
%             display([ filenames{i}(1:end-4) 'AR: ' num2str(CorrectRate)]); 
        end
    end
end

send_mail_message('herbert19lee', 'batchRun is Done', 'FYI');
fclose(fid);
