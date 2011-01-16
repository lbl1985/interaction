vcm
Type = 2; Clip = 34;
% [srcdirI filenamesI] = rfdatabase(datadir(Type, 'kthvideo'), 'person', '.avi');
[srcdirI filenamesI] = rfdatabase(datadir_interaction(Type, 'tvinteraction'), [], '.avi');
[srcdirA filenamesA] = rfdatabase(datadir_interaction(Type, 'tvinteractionAnnotation'), [], '.txt');
filename = [srcdirI filenamesI{Clip}]; outName = './sample.txt';
filenameA = [srcdirA filenamesA{Clip}]; 

mat = movie2var(filename, 0, 1);

nframe = size(mat, ndims(mat));
skinMat = zeros(size(mat, 1), size(mat, 2), nframe);

info = readTVdatasetAnnotation(filenameA);
info.Type = Type;
info.Clip = Clip;

for i = 1 : nframe
    im = mat(:, :, :, i);
    h = figure(1); subplot(1, 2, 1); 
    imshow(im);
    title(['Frame ' num2str(i)]);
    
    im = double(im);
    skinprob = computeSkinProbability(im);
    skin = (skinprob >0) + 0;
    skinMat(:, :, i) = skin;
    h2 = subplot(1, 2, 2); ideaShow(info, 'tvAnnotation_data', skinMat, i, h2);
%     figure(1); subplot(1, 2, 2); imshow(skin);    
end

