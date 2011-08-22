function [bgMean,bgVar] = learn_bg_gaussian_from_video(videoFileName,frameInd);

bgFrameStart = frameInd(1);
bgFrameEnd = frameInd(2);

% total number of frames
N = bgFrameEnd - bgFrameStart +1;

[video,audio] = mmread(videoFileName,[1],[],false,true);

nFrames = abs(video.nrFramesTotal);
width  = video.width;
height = video.height;
dim = 3;

% bgMean = zeros(height,width, 1); % we will process gray level images
% bgVar = zeros(height,width, 1);
bgVect = zeros(height*width*dim,N);

h = fspecial('gaussian',[3 3],0.5);
index = 1;

for n = bgFrameStart : bgFrameEnd
    
    [video,audio] = mmread(videoFileName,[n],[],false,true);
    nextFrame = video.frames(1).cdata;
        
    if(dim==3)
%         nextFrame = rgb2gray(nextFrame);
    end
    
%     nextFrame = imfilter(nextFrame,h);   
    
    % make it vector
    bgVect(:,index) = double(nextFrame(:));
    index = index+1;
    
end

bgMean = mean(bgVect,2);
bgVar = var(bgVect,[],2);

bgMean = reshape(bgMean, [height width dim]);
bgVar = reshape(bgVar, [height width dim]);
