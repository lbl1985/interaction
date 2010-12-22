Type = 3;
[srcdirI filenamesI] = rfdatabase(datadir(Type, 'kth_selectFrames'), 'clip');
nFrames = zeros(length(filenamesI), 1);
for i = 1 : length(filenamesI)
    load([srcdirI filenamesI{i}]);
    nFrames(i) = size(I, 3);
end
[B idx] = sort(nFrames);
