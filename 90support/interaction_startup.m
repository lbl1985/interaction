if ispc
    workingpath = 'C:\Users\XPS\Documents\MATLAB\work\interaction';
end

cd(workingpath);
addpath(genpath(fullfile(workingpath, '90support')));

% interaction_startup

addpath(genpath(fullfile(workingpath, 'selfMadeData')));

if ismac
    workingpath = '/Users/herbert19lee/Documents/MATLAB/work/interaction';
elseif ispc    
    workingpath = 'C:\Users\lbl1985\Documents\MATLAB\work\interaction';
    if ~exist(workingpath, 'dir')
        workingpath = 'C:\Users\XPS\Documents\MATLAB\work\interaction';
    end
elseif isunix
    workingpath = '/home/binlongli/Documents/MATLAB/work/interaction';
    if ~exist(workingpath, 'dir')
        workingpath = '/home/binlong/Documents/MATLAB/work/interaction';
    end
end 

cd(workingpath);
addpath(workingpath);
addpath(fullfile(workingpath, '90support'));
addpath(genpath(fullfile(workingpath, '00feiTest')));
addpath(genpath(fullfile(workingpath, 'tvinteraction')));

if ispc
    rmpath(genpath(fullfile(workingpath, '90support', 'mmread_linux')));
elseif isunix
    rmpath(genpath(fullfile(workingpath, '90support', 'mmread')));
end
