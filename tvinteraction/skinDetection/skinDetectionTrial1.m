% vcm
Type = 2; Clip = 3;
record = 0; 
moviefile = 'trial1.avi'; moviefile2 = 'trial2.avi';
numRegions = 10;
% [srcdirI filenamesI] = rfdatabase(datadir(Type, 'kthvideo'), 'person', '.avi');
[srcdirI filenamesI] = rfdatabase(datadir_interaction(Type, 'tvinteraction'), [], '.avi');
[srcdirA filenamesA] = rfdatabase(datadir_interaction(Type, 'tvinteractionAnnotation'), [], '.txt');
filename = [srcdirI filenamesI{Clip}]; outName = './sample.txt';
filenameA = [srcdirA filenamesA{Clip}]; 

mat = movie2var(filename, 0, 1);

% nframe = size(mat, ndims(mat));

info = readTVdatasetAnnotation(filenameA);
info.Type = Type;
info.Clip = Clip;

nframe = size(info.PersonInfo, 1); 
skinMat = zeros(size(mat, 1), size(mat, 2), nframe);
if record
    aviobj = avifile(moviefile, 'fps', 22, 'compression', 'none');
end

skinColor = zeros(size(mat));
skinRegions = cell(nframe, numRegions);
for i = 1 : nframe
    im = mat(:, :, :, i);
    h = figure(1); subplot(2, 3, 1); 
    imshow(im);
    title(['Frame ' num2str(i)]);
    
    im = double(im);
    skinprob = computeSkinProbability(im);
    skin = (skinprob >0) + 0;
    skinMat(:, :, i) = skin;
    skinColor(:, :, :, i) = repmat(skin, [1 1 3]);
    h2 = subplot(2, 3, 4); ideaShow(info, 'tvAnnotation_data', skinMat, i, h2);
    
    CC = bwconncomp(skin, 8);
    numPixels = cellfun(@numel, CC.PixelIdxList);
    [biggest, idx] = sort(numPixels, 'descend');
    
%     figure(1); subplot(1, 2, 2); imshow(skin);    
    
    for j = 1 : 4
        skinShow = zeros(size(skin));
        skinShow(CC.PixelIdxList{idx(j)}) = 1;
        skinShowTemp = uint8(im .* repmat(skinShow, [1 1 3]));
%         figure(h); subplot(2, 3, j + floor(j/3) + 1); imshow(skinRegions{i, j});        
        figure(h); subplot(2, 3, j + floor(j/3) + 1); imshow(skinShowTemp);        
    end

    for j = 1 : numRegions
%         skinShow = zeros(size(skin));
%         skinShow(CC.PixelIdxList{idx(j)}) = 1;        
%         skinRegions{i, j} = uint8(im .* repmat(skinShow, [1 1 3]));
        skinRegions{i, j} = CC.PixelIdxList{idx(j)};
    end
    
    
    
    if record
        frame = getframe(gcf);
        aviobj = addframe(aviobj, frame);
    end

end

% figure(2); playM_asVideo(uint8(double(mat) .* skinColor));

if record
    aviobj = close(aviobj);
end

diffMatrix = skinRegionsTracking(mat, skinRegions);
save(['diffMatrixType' num2str(Type) 'Clip' num2str(Clip)], 'diffMatrix',  'skinRegions');
trajectory = RegionTrajectory(diffMatrix);

% load diffMatrixType2Clip4.mat

if record
    aviobj = avifile('trial3.avi', 'fps', 22, 'compression', 'none');
end

for i = 1 : size(trajectory, 2)
    im = mat(:, :, :, i);
    h = figure(1); subplot(2, 3, 1); 
    imshow(im);
    title(['Frame ' num2str(i)]);
    
    im = double(im);
    skinprob = computeSkinProbability(im);
    skin = (skinprob >0) + 0;
    skinMat(:, :, i) = skin;
    skinColor(:, :, :, i) = repmat(skin, [1 1 3]); 
    figure(h); h2 = subplot(2, 3, 4); 
    ideaShow(info, 'tvAnnotation_data', skinMat, i, h2);
    
    for j = 1 : 4
        skinShow = zeros(size(skin));
        id = trajectory(j, i);
        skinShow(skinRegions{i, id}) = 1;
        skinShowTemp = uint8(im .* repmat(skinShow, [1 1 3]));
%         figure(h); subplot(2, 3, j + floor(j/3) + 1); imshow(skinRegions{i, j});        
        figure(h); subplot(2, 3, j + floor(j/3) + 1); imshow(skinShowTemp);
    end
    
    if record
        frame = getframe(gcf);
        aviobj = addframe(aviobj, frame);
    end
end
if record
    aviobj = close(aviobj);
end