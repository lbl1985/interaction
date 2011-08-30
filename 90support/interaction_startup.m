if ispc
    workingpath = 'C:\Users\XPS\Documents\MATLAB\work\interaction';
end

cd(workingpath);
addpath(genpath(fullfile(workingpath, '90support')));

% interaction_startup

addpath(genpath(fullfile(workingpath, 'selfMadeData')));
addpath(genpath(fullfile(workingpath, 'tvinteraction')));