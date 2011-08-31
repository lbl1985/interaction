clc
baseFolder = getProjectBaseFolder();
[srcdir filenames n] = rfdatabase(fullfile(getProjectBaseFolder(), ...
    '00feiTest', 'testData'), [], '.mat');
HankelWindowSize = 4;
pca_dim = 4;

for i = 1
    I = load(fullfile(srcdir, filenames{i}));
    I = I.I;
    nVideo = length(I);
    HankelMatrixBatch = cell(nVideo, 1);
    for j = 1 : nVideo
        HankelMatrixBatch{j} = hankelConstruction(I{j}', HankelWindowSize);
    end
    groupsLabel = [zeros(nVideo/2, 1); ones(nVideo/2, 1)];
    [CorrectRate CPMatrix trainBatch] = Classifier_interaction(HankelMatrixBatch, groupsLabel, 'OneHankelAsOneSet_SVM_pcadimSVM_Batch', 1, pca_dim, 'poly', 2);
    display([ filenames{i}(1:end-4) 'AR: ' num2str(CorrectRate)]); 
end