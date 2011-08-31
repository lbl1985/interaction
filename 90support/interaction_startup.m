if ispc
    workingpath = 'C:\Users\XPS\Documents\MATLAB\work\interaction';
end

cd(workingpath);
addpath(genpath(fullfile(workingpath, '90support')));

% interaction_startup

addpath(genpath(fullfile(workingpath, 'selfMadeData')));
addpath(genpath(fullfile(workingpath, 'tvinteraction')));

if ispc
    rmpath(genpath(fullfile(workingpath, '90support', 'mmread_linux')));
elseif isunix
    rmpath(genpath(fullfile(workingpath, '90support', 'mmread')));
end
    