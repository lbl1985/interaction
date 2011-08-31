function [CorrectRate CPMatrix] = afterClassification_IPLDE(ypred, ypredMatrix, groupsLabel)
idx = find(ypred{1} - ypred{2});
