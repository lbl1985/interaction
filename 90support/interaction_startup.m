if ismac
    workingpath = '/Users/herbert19lee/Documents/MATLAB/work/HFeature';
elseif ispc    
    workingpath = 'C:\Users\lbl1985\Documents\MATLAB\work\HFeature';
elseif isunix
    workingpath = '/home/binlongli/Documents/MATLAB/work/HFeature';
    if ~exist(workingpath, 'dir')
        workingpath = '/home/binlong/Documents/MATLAB/work/HFeature';
    end
end  

cd(workingpath);
addpath(workingpath);
addpath(genpath(fullfile(workingpath, '10digging')));
if ismac
    rmpath(fullfile(workingpath, '10digging', 'mmread_linux'));
elseif isunix
    rmpath(fullfile(workingpath, '10digging', 'mmread_mac'));
end

addpath(genpath(fullfile(workingpath, '15experiments')));
addpath(genpath(fullfile(workingpath, '20ownIdea')));
addpath(genpath(fullfile(workingpath, '90support')));
addpath(genpath(fullfile(workingpath, 'Results')));