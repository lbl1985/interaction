function l1demo(Type, Clip)
[srcdirI filenamesI] = rfdatabase(datadir_interaction(Type, 'tvinteraction'), [], '.avi');
[srcdirA filenamesA] = rfdatabase(datadir_interaction(Type, 'tvinteractionAnnotation'), [], '.txt');
filename = [srcdirI filenamesI{Clip}]; outName = './sample.txt';
filenameA = [srcdirA filenamesA{Clip}]; 

if ispc
    k = strfind(filename, '\');
else
    k = strfind(filename, '/');
end

nT = 10;
n_sample = 600;
path = pwd;

res_path = fullfile(path, 'result');

fprefix = fullfile(path, 'pktest02');
fext = 'jpg';
start_frame = 1;
% nframes = movie2frames(filename, fprefix);
nframes = 62;

sz_T = [12 15];
numzeros = 4;

s_frames = cell(nframes, 1);

filenameT = filename(k(end) + 1 : end-4);
for i = 1 : nframes
%     I = movie.frames(i).cdata;
    s_frames{i} = fullfile('pktest02', [filenameT '_' int2str2(i, numzeros), '.jpg']);
end

init_pos	= SelectTarget(s_frames{1});

% init_pos	= [	128 150 120;
% 			    116 136 129];

%% L1 tracking
fcdatapts       = [28 507; 82 721]; %the coordinates of the image on the figure
tracking_res    = L1Tracking_release( s_frames, sz_T, n_sample, init_pos, res_path, fcdatapts);


%% Output tracking results
for t = 1:nframes
    img_color	= imread(s_frames{t});
    img_color	= double(img_color);
    imshow(uint8(img_color));
    color = [1 0 0];
    map_afnv	= tracking_res(:,t)';
    drawAffine(map_afnv, sz_T, color, 2);
    
    s_res	= s_frames{t}(1:end-4);
    s_res	= fliplr(strtok(fliplr(s_res),'/'));
    s_res	= fliplr(strtok(fliplr(s_res),'\'));
    s_res	= [res_path s_res '_L1.png'];
    f = getframe(gcf);
    % imwrite(uint8(f.cdata(fcdatapts(1,1):fcdatapts(1,2), fcdatapts(2,1):fcdatapts(2,2), :)), s_res);
end

%% output result
s_res = sprintf('%s\\L1_result_%d_%d.mat', res_path, start_frame, nframes);
save(s_res, 'tracking_res');
