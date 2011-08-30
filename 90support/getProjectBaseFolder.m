function projectBaseFolder = getProjectBaseFolder
projectBaseFolder = which('interactionFlag.m');
projectBaseFolder = projectBaseFolder(1:strfind(projectBaseFolder, 'interactionFlag.m') - 1);
 