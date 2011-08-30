% vcm
% Type = 0; Clip = 50;
% [srcdirI filenamesI] = rfdatabase(datadir(Type, 'kthvideo'), 'person', '.avi');
function ratio = clip_overlapRatio(Type, Clip)
[srcdirI filenamesI] = rfdatabase(datadir_interaction(Type, 'tvinteraction'), [], '.avi');
[srcdirA filenamesA] = rfdatabase(datadir_interaction(Type, 'tvinteractionAnnotation'), [], '.txt');
filename = [srcdirI filenamesI{Clip}]; 
filenameA = [srcdirA filenamesA{Clip}]; 
% STIPbin = 'C:\Users\lbl1985\Desktop\STIP\bin\';
% comm = ['!' STIPbin 'stipdet -f ' filename ' -o ' outName ' -vis no'];
% % comm = ['!' STIPbin 'stipdet -f ' filename '4-o ' outName];
% eval(comm);
% 
% info = readTVdatasetAnnotation('handShake_0001.txt');

try 
    info = readTVdatasetAnnotation(filenameA);

    BoundingBox = info.PersonInfo(:, 1:4, :);

    fileinfo = mmfileinfo(filename);
    siz = [fileinfo.Video.Width fileinfo.Video.Height];
    nFrame = size(BoundingBox, 1); nPerson = size(BoundingBox, 3);
    ratio = zeros(nFrame, nchoosek(nPerson, 2));

    try 
        for i = 1 : nFrame
            count = 0; 
            for j = 1 : (nPerson - 1)
                for k = j + 1 : nPerson
                    count = count + 1;
                    ratio(i, count) = overlapRatio(BoundingBox(i, :, j), BoundingBox(i, :, k), siz);
                end
            end
        end
    catch
        display(['Type = ' num2str(Type)]);
        display(['Clip = ' num2str(Clip)]);
        display(['Frame = ' num2str(i)]);
        display(['---------------------']);
    end

catch
    display(['Reading info Error [Type Clip] = [ ' num2str(Type) ' ' num2str(Clip) ']']);
    ratio = 0;
end