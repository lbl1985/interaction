% function foreGround = bgSubtract(filename)

% varname = filename(1:end - 4);
% comm = [varname ' = movie2var(''' filename '''' ');'];
% filename = 'handshake01.wmv';
% load background.mat
% var = movie2var(filename, 1);

[srcdir filenames n] = rfdatabase(datadir_interaction(0), [], '.wmv');
filename = [srcdir filenames{1}];
var = movie2var(filename, 0, 0.5);

thresh = 25;

nframe = size(var, 3);
foreGround = zeros(size(var));
bgImageGray = var(:, :, 1);
% matlabpool open
for i = 1 : nframe
    fr_bw = var(:, :, i);
    fr_diff = abs(double(fr_bw) - double(bgImageGray));
    
    fg_mask = fr_diff > thresh;
    fg = uint8(double(fr_bw) .* double(fg_mask));
    
    fg = refine_HumanBody(fr_bw, fg);
    
%     tempforeGround(tempforeGround < 10) = 0;
    foreGround(:, :, i) = fg;
    display(['Finish Frame ' num2str(i)]);
%     imshow(foreGround(:, :, i)); title(['Frame ' num2str(i)]); pause(1/11);
end
% matlabpool close
clear var;
foreGround = uint8(foreGround); 

temp = foreGround(:, :, 1);
% temp(temp < 5) = 0;
tempb = temp;
tempb(tempb ~= 0) = 1;
imagesc(tempb);