if ismac
    workingpath = '/Users/herbert19lee/Documents/MATLAB/work/interaction';
elseif ispc    
    workingpath = 'C:\Users\lbl1985\Documents\MATLAB\work\interaction';
elseif isunix
    workingpath = '/home/binlongli/Documents/MATLAB/work/interaction';
    if ~exist(workingpath, 'dir')
        workingpath = '/home/binlong/Documents/MATLAB/work/interaction';
    end
end 

cd(workingpath);
addpath(workingpath);
addpath(fullfile(workingpath, '90support'));
addpath(genpath(fullfile(workingpath, 'tvinteraction')));