function projectBaseFolder = getProjectBaseFolder
projectBaseFolder = which('HFeatureFlag.m');
projectBaseFolder = projectBaseFolder(1:strfind(projectBaseFolder, 'HFeatureFlag.m') - 1);
 