vcm
Type = 1; Clip =3;
% [srcdirI filenamesI] = rfdatabase(datadir(Type, 'kthvideo'), 'person', '.avi');
[srcdirI filenamesI] = rfdatabase(datadir_interaction(Type, 'tvinteraction'), [], '.avi');
[srcdirA filenamesA] = rfdatabase(datadir_interaction(Type, 'tvinteractionAnnotation'), [], '.txt');
filename = [srcdirI filenamesI{Clip}]; outName = './sample.txt';
filenameA = [srcdirA filenamesA{Clip}]; 
% STIPbin = 'C:\Users\lbl1985\Desktop\STIP\bin\';
% comm = ['!' STIPbin 'stipdet -f ' filename ' -o ' outName ' -vis no'];
% % comm = ['!' STIPbin 'stipdet -f ' filename '4-o ' outName];
% eval(comm);
% 
% info = readTVdatasetAnnotation('handShake_0001.txt');

info = readTVdatasetAnnotation(filenameA);
info.Type = Type;
info.Clip = Clip;

% info_backup = info;

% info = BoundingBoxRefine_tvinteraction(info);

% info.PersonInfo(:, 4, :) = 350;
% ideaShow(info, 'tvAnnotation', filename); close;


mat = movie2var(filename, 0, 1);
% for i = 1 : size(mat, 4)
%     imshow(mat(:, :, :, i));
%     title(['Frame ' num2str(i)]);
%     pause(1/11);
% end
close all; 
nwin = [16 8];
Person = Hog_in_BoundingBox(mat, info, nwin);
% % ideaShow(info, 'tvAnnotation', filename);
ideaShow(info, 'GradientShow', filename, nwin, Person);
[~, NAME, ~] = fileparts(filename);

record = 1;
if record == 1
    videoPath = 'C:\Users\XPS\Documents\MATLAB\work\interaction\tvinteration\testVideo';
    ideaShow(info, 'GradientShowRec_Alert', filename, nwin, Person, fullfile(videoPath, [NAME '.avi']));
end
% % ideaShow(info, 'GradientShowRec_Alert', filename, nwin, Person);

