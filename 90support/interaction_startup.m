<<<<<<< HEAD
if ispc
    workingpath = 'C:\Users\XPS\Documents\MATLAB\work\interaction';
end

cd(workingpath);
addpath(genpath(fullfile(workingpath, '90support')));

% interaction_startup

addpath(genpath(fullfile(workingpath, 'selfMadeData')));
=======
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
>>>>>>> 4b70f2bdf1810f88d01004fbde14e6a54103572c
addpath(genpath(fullfile(workingpath, 'tvinteraction')));