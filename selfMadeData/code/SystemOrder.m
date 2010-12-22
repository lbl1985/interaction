% Path = 'C:\Users\XPS\Documents\MATLAB\work\interaction\manualTracking\TrackingResult\handshake\';
% filename = 'handshake01_manualTrackingFS50FE80';
% filename = 'handshake02_manualTrackingFS56FE90';
Path = 'C:\Users\XPS\Documents\MATLAB\work\interaction\manualTracking\TrackingResult\slap\';
filename = 'slap07_manualTrackingFS1FE18';
load([Path filename]);

HankelWindowSize = 8;
FrameFeatures1 = FrameFeatureExtraction_interaction(FeaturePos(1:5, :, :));
FrameFeatures2 = FrameFeatureExtraction_interaction(FeaturePos(6:10, :, :));

hankelObj1 = hankelConstruction(FrameFeatures1, HankelWindowSize);
hankelObj2 = hankelConstruction(FrameFeatures2, HankelWindowSize);

[U1 S1 V1] = svd(hankelObj1);
[U2 S2 V2] = svd(hankelObj2);


[Ut Stv Vt] = svd([hankelObj1; hankelObj2]);
[Ut Sth Vt] = svd([hankelObj1  hankelObj2]);
figure(1);
subplot(1, 4, 1); plot(1 : length(diag(S1)), diag(S1));
subplot(1, 4, 2); plot(1 : length(diag(S2)), diag(S2));
subplot(1, 4, 3); plot(1 : length(diag(Stv)), diag(Stv));
subplot(1, 4, 4); plot(1 : length(diag(Sth)), diag(Sth));

[temp1, nonhankelObj1] = FrameFeatureExtractionMajorComponent(FrameFeatures1, HankelWindowSize, 'nonHankel'); clear temp1;
[temp2, nonhankelObj2] = FrameFeatureExtractionMajorComponent(FrameFeatures2, HankelWindowSize, 'nonHankel'); clear temp2;

[U1 nS1 V1] = svd(nonhankelObj1);
[U2 nS2 V2] = svd(nonhankelObj2);


[Ut nStv Vt] = svd([nonhankelObj1; nonhankelObj2]);
[Ut nSth Vt] = svd([nonhankelObj1  nonhankelObj2]);
figure(2);
subplot(1, 4, 1); plot(1 : length(diag(nS1)), diag(nS1));
subplot(1, 4, 2); plot(1 : length(diag(nS2)), diag(nS2));
subplot(1, 4, 3); plot(1 : length(diag(nStv)), diag(nStv));
subplot(1, 4, 4); plot(1 : length(diag(nSth)), diag(nSth));