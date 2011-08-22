vcm

[srcdir filenames n] = rfdatabase(datadir_interaction(0), [], '.wmv');
filename = [srcdir filenames{1}];
% videoFullFileName =  'C:\Users\Caglayan\ALERT\Data\binlong\handshake01.wmv';
videoFullFileName = filename;
dim = 3; siz = 0.25;

% learn the background
[bgMean, bgVar] = learn_bg_gaussian_from_video(videoFullFileName,[1 9]);
bgMean = imresize(bgMean, siz);
bgMeanRange = rangefilt(bgMean);

se90 = strel('line', 6, 90); 
se0 = strel('line', 6, 0);
frameStart=10;frameEnd=150;

foreGround = [];    foreGroundRange = [];

for n = frameStart : frameEnd
    
    [video,audio] = mmread(videoFullFileName,[n],[],false,true);
    nextFrame = video.frames(1).cdata; nextFrame = imresize(nextFrame, siz);
    
    nextFrameRange = rangefilt(nextFrame);
    
    diffFrame = sum(abs(double(nextFrame) - bgMean),3)/dim;
    diffFrameRange = sum(abs(double(nextFrameRange) - bgMeanRange), 3)/ dim;
    
    fgImage = (diffFrame>35);
    fgImageRange = (diffFrameRange > 35);
%     fgImageRangeDenoise = medfilt2(fgImageRange, [5 5]);
    
    
%     diffFrameDil = imdilate(fgImage, [se90 se0]);
    diffFrameDil = imdilate(fgImageRange, [se90]);
    diffFrameFil = imfill(diffFrameDil, 'holes');
    
%     diffFrameFilThresh = diffFrameFil > 35;
    foreGround = cat(3, foreGround, fgImage);
    figure(1);
    imshow(fgImage,'border','tight');
    title(['Frame ' num2str(n)]);
    
    foreGroundRange = cat(3, foreGroundRange, fgImageRange);
    figure(2); imshow(fgImageRange, 'border', 'tight');
    title(['Frame ' num2str(n) 'Range']);
    
%     figure(1); imshow(diffFrameDil, 'border', 'tight');
%     title(['Frame ' num2str(n) 'Fill']);
end

% foreGround = uint8(foreGround);
save fg foreGround foreGroundRange;
% clear;
% 
% load foreGround
% nframe = size(foreGround, 3);
% for i = 1 : nframe
%     foreGround(:, :, i) = uint8(medfilt2(foreGround(:, :, i), [ 3 3]));
% end
    





