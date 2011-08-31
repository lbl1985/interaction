function [CorrectRate CPMatrix] = afterClassification_IPLDE(ypred, ypredMatrix, groupsLabel)
groups = groupsLabel + 1;
[~, test] = specialSetting_tvinteraction;

ypredFinal = ypred{1};
ypred = assembleCellData2Array(ypred, 2);
ypredMatrix = assembleCellData2Array(ypredMatrix, 2);

idx = find(ypred(:, 1) - ypred(:, 2));
for i = 1 : length(idx)
    [~, ypredFinal(idx(i))] = max(ypredMatrix(idx(i), :));
end

[CPMatrix CorrectRate] = confusionMatrix(ypredFinal, groups(test));

