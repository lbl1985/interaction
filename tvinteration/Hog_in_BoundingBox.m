%Image descriptor based on Histogram of Orientated Gradients for gray-level
%images. This code
%was developed for the work: O. Ludwig, D. Delgado, V. Goncalves, and U.
%Nunes, 'Trainable
%Classifier-Fusion Schemes: An Application To Pedestrian Detection,' In: 12th International IEEE
%Conference On Intelligent Transportation Systems, 2009, St. Louis, 2009. V. 1. P. 432-437. In
%case of publication with this code, please cite the paper above.

function Person = Hog_in_BoundingBox(mat, info, nwin)
nwin_x = nwin(1); nwin_y = nwin(2);
hx = [-1,0,1];
hy = -hx';

nPerson = length(info.PersonID);

Person.Gradient.Angles = zeros(nwin_y, nwin_x, info.NumFrame);
Person = repmat(Person, nPerson, 1);
BoundingBox = info.PersonInfo(:, 1:4, :);

try
    
    for i = 1 : info.NumFrame
        [angles magnit] = GDetection(mat(:, :, i), hx, hy);
        for j = 1 : nPerson
    %         Person(j).Gradient.Angles(:, :, i) = GetGridValue(angles, BoundingBox(i, :, j), nwin, 'maxDirection');
            if ~isempty(find(BoundingBox(i, :, j)))
                if BoundingBox(i, 1, j) < 1, BoundingBox(i, 1, j) = 1; end
                if BoundingBox(i, 2, j) < 1, BoundingBox(i, 2, j) = 1; end
                if BoundingBox(i, 3, j) > size(angles, 2), BoundingBox(i, 3, j) = size(angles, 2); end
                if BoundingBox(i, 4, j) > size(angles, 1), BoundingBox(i, 4, j) = size(angles, 1); end
                Person(j).Gradient.Angles(:, :, i) = GetGridValue(angles, BoundingBox(i, :, j), nwin, 'maxMagnitDirection', magnit);
            end
        end
    end
catch ME
    display(['i = ' num2str(i)]);
    display(['j = ' num2str(j)]);
    error(ME.message);
end