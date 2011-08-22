groupsLabel = []; HankelMatrixBatch = [];
HankelWindowSize = 9;
for type = 0 : 1
    [srcdir filenames n] = rfdatabase(datadir_interaction(type, 'manualTracking'), [], '.mat');
    for clip = 1 : n
        filename = [srcdir filenames{clip}]; fn = filenames{clip};
        load(filename);
        
        FrameFeatures1 = FrameFeatureExtraction_interaction(FeaturePos(1:5, :, :));
        FrameFeatures2 = FrameFeatureExtraction_interaction(FeaturePos(6:10, :, :));

        hankelObj1 = hankelConstruction(FrameFeatures1, HankelWindowSize);
        hankelObj2 = hankelConstruction(FrameFeatures2, HankelWindowSize);
        
        hankel{1} = [hankelObj1; hankelObj2];
        
        HankelMatrixBatch = cat(1, HankelMatrixBatch, hankel); clear hankel
        groupsLabel = cat(1, groupsLabel, type);
    end
end

% save (['handshaking_slapHWS' num2str(HankelWindowSize)], 'HankelMatrixBatch', 'groupsLabel');