baseFolder = getProjectBaseFolder();
[srcdir filenames n] = rfdatabase(fullfile(getProjectBaseFolder(), ...
    '00feiTest', 'testData'), [], '.mat');

% for i = 1 : n