type = 0; clip = 8;
[srcdir filenames n] = rfdatabase(datadir_interaction(type), [], '.*');

filename = [srcdir filenames{clip}]; fn = filenames{clip};

nclusters = 5; nObject = 2; siz = 0.5;
frameStart=10;frameEnd=70; nframe = frameEnd - frameStart + 1;
clipname = fn(1:end - 4);
cliptype = fn(1:end - 6);
FeaturePos = zeros(nclusters * nObject, 2, nframe);
c{1} = struct('Area', 1, 'MaxIntensity', 1, 'MaxIntensityPos', [], 'posAfter', [], 'LinkAfter', [], 'posBefore', [], 'LinkBefore', []);
R_RegionPointCorr1 = repmat(c, [nframe 1]);
R_RegionPointCorr2 = R_RegionPointCorr1;

savePath = ['C:\Users\XPS\Documents\MATLAB\work\interaction\manualTracking\TrackingResult\' cliptype '\'];
saveNAME = [clipname '_manualTracking'];

for i = frameStart : frameEnd
    f = i - frameStart + 1;
    [video audio] = mmread(filename, i, [], false, true);
    I = video.frames(1).cdata; I = imresize(I, siz); imshow(I); title(['Frame ' num2str(i)]);
    for ob = 1 : nObject
        for j = 1 : nclusters
            r = (ob - 1) * 5 + j;
            [x y] = ginput(1); 
            FeaturePos(r, :, f) = [x y];
            
            if ob == 1
                R_RegionPointCorr1{f}(j).MaxIntensityPos = [x y];
            else
                R_RegionPointCorr2{f}(j).MaxIntensityPos = [x y];
            end
            
            if f ~= 1
                if ob == 1
                    R_RegionPointCorr1{f - 1}(j).posAfter = [x y];
                else
                    R_RegionPointCorr2{f - 1}(j).posAfter = [x y];
                end
            end
            
            if f ~= nframe
                if ob == 1
                    R_RegionPointCorr1{f + 1}(j).posBefore = [x y];
                else
                    R_RegionPointCorr2{f + 1}(j).posBefore = [x y];
                end
            end
        end
    end
end

save([savePath saveNAME 'FS' num2str(frameStart) 'FE' num2str(frameEnd)], 'FeaturePos', 'R_RegionPointCorr1', 'R_RegionPointCorr2');
