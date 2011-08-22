% function batchResizeVideo
% path = datadir_interaction(1);
[srcdir filenames n] = rfdatabase(datadir_interaction(0), [], '.wmv');
filename = [srcdir filenames{1}];
var = movie2var(filename, 1, 0.5);
