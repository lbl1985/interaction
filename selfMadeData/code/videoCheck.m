function videoCheck(type, clip, frameStart,frameEnd)
% type = 0; clip = 1;

[srcdir filenames n] = rfdatabase(datadir_interaction(type), [], '.*');

filename = [srcdir filenames{clip}]; fn = filenames{clip};
for i = frameStart : frameEnd
    [video audio] = mmread(filename, i, [], false, true);
    imshow(video.frames(1).cdata); title(['Frame ' num2str(i)]);
    pause(1/11);
end