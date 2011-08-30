function R_labelShow = Alert_PosterShow(R_label, varargin)
% Additional Parameter(s):
% case 'CentroidTwoColumns'
%   I = varargin{1};        The Background Image to put marks on
% case 'BoundingBox'
%   Bounding = varargin{1}; The BoundingBox Info.
%   show = varargin{2};     Decide whether to show the visulization
% case 'labelmatrix':
%   show = varargin{1};     Decide whether to show the visulization
%
% Try GIT.
if ndims(R_label) == 2
    nframe = length(R_label);
else
    nframe = size(R_label, 3);
end

info = R_label;
videoName = varargin{1}; nwin = varargin{2}; Person = varargin{3}; record = 0;
if nargin == 6
    moviefile = varargin{4};
    record = 1;
end
BoundingBox = info.PersonInfo(:, 1:4, :);
nFrame = info.NumFrame;
mat = movie2var(videoName, 0, 1);
if record
    aviobj = avifile(moviefile, 'fps', 22, 'compression', 'none');
end

for i = 1 : nFrame
    I = mat(:, :, :, i); Ibox = I; figure(1); imshow(Ibox, 'border', 'tight');
    for j = 1 : size(BoundingBox, 3)
        if ~isempty(find(BoundingBox(i, :, j), 1))
            Ibox = drawbox(Ibox, [BoundingBox(i, 2, j) BoundingBox(i, 1, j)], [BoundingBox(i, 4, j) BoundingBox(i, 3, j)]);
        end
    end
    h = figure(1); hold on; imshow(Ibox, 'border', 'tight' ); hold off;%title(['Frame ' num2str(i)]);  hold off;
    for j = 1 : size(BoundingBox, 3)
        if ~isempty(find(BoundingBox(i, :, j), 1))
            [u v x y] =quiverPre(Person(j).Gradient.Angles(:, :, i), BoundingBox(i, :, j), nwin);
            hold on;
            if j == 1
                quiver(x, y, u, v, 'LineWidth', 0.05, 'color', 'g');
            elseif j == 2
                quiver(x, y, u, v, 'LineWidth', 0.05, 'color', 'r');
            elseif j == 3
                quiver(x, y, u, v, 'LineWidth', 0.05, 'color', 'b');
            elseif j == 4
                quiver(x, y, u, v, 'LineWidth', 0.05, 'color', 'c');
            end
            hold off;
        end
    end
    pause(1/11);
    if record
        frame = getframe(h);
        aviobj = addframe(aviobj, frame);
    end
end
if record
    aviobj = close(aviobj);
end