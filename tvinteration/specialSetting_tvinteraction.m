function [train test] = specialSetting_tvinteraction
% According to the Clips above and the training and testing set information
% in the readme file of this database.
ClipNum = []; 
tc = [1 : 6 8:16 18 : 28]'; 
ClipNum = cat(1, ClipNum, [0 * ones(length(tc), 1) tc]);
tc = [1 : 10 12 : 19 21 25 29 33 44 45 47 49]';
ClipNum = cat(1, ClipNum, [1 * ones(length(tc), 1) tc]);
% tc = [1 : 2 4 : 6 8 : 14: 16 18: 20 23 25 : 30 32 : 33 36 : 38 40 : 41 43: 45]';
% ClipNum = cat(1, ClipNum, [2 * ones(length(tc), 1) tc]);

ttI = [2 14 15 16 18 19 20 21 24 25 26 27 28 32 40 41 42 43 44 45 46 47 48 49 50];% temp traing Idx
trainIdx = [0 * ones(length(ttI), 1) ttI'];
ttI = [1 6 7 8 9 10 11 12 13 23 24 25 27 28 29 30 31 32 33 34 35 44 45 47 48];
trainIdx = [trainIdx; 1 * ones(length(ttI), 1) ttI'];
ttI = [1 7 8 9 10 11 12 13 14 16 17 18 22 23 24 26 29 31 35 36 38 39 40 41 42];
trainIdx = [trainIdx; 2 * ones(length(ttI), 1) ttI'];

train = false(size(ClipNum, 1), 1);
for i = 1 : size(ClipNum)
    istrain = any(checkEqual(trainIdx - repmat(ClipNum(i, :), size(trainIdx, 1), 1)));
    train(i) = istrain;
end
test = ~train;

function checklist = checkEqual(input)
D = size(input, 1);
checklist = -1 * ones(D, 1);
for i = 1 : D
    isOn = isequal(input(i, :), [0 0]);
    checklist(i) = isOn;
end