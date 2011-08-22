% function main_interactio
constructHankelMatrixBatch;
[CorrectRate CPMatrix trainBatch] = Classifier_interaction(HankelMatrixBatch, groupsLabel, 'OneHankelAsOneSet_SVM', 100, 30, 'poly', 2); mean(CorrectRate)
% [CorrectRate CPMatrix trainBatch] = Classifier_interaction(HankelMatrixBatch, groupsLabel, 'OneHankelAsOneSet_NN', 100, 30, 'poly', 2); mean(CorrectRate)
% HWS = 4;
% T = I; NN; (30, 2)  72.22%
% T = I; NN; (20, 3)  74.00%

% HWS = 9; NN
% T; NN; (30, 2) 59.60%
% T; NN; (20, 3) 70%
% T = I; NN; (30, 2) 78.40%
% T = I; NN; (20, 3) 71.40%
%
% HWS = 9; SVM
% T = I; SVM; (30, 2) 56.80%
% T = I; SVM; (20, 3) 49.00%
% T;     SVM; (30, 2) 50.20%
% T;     SVM; (20, 3) 47.60%