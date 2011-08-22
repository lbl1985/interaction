function info = BoundingBoxRefine_tvinteraction(info)
BoundingBox = info.PersonInfo(:, 1:4, :);
% This makes the bounding box extended to the bottom of the screen
extIndex = zeros(info.NumFrame, 1); extRange = 5;
for i = 1 : info.NumFrame
    if ~isempty(info.FrameInfoBatch{i})
        if ~isempty(deblank(info.FrameInfoBatch{i}.inter))
            interPersonID = extractInterPersonID(info.FrameInfoBatch{i}.inter);
            if i ~= 1
                if extIndex(i - 1) ~= 1 
                    % This conditions means current frame is the first frame
                    % for interaction
                    if (i - extRange) > 1
                        if all(extIndex((i - extRange) : i) == 0)
                            [BoundingBox, info] = BoundingBoxConnect(BoundingBox, (i - extRange : i), interPersonID, info);
                            extIndex(i - extRange : i) = 1;
                        end
                    else
                        [BoundingBox, info] = BoundingBoxConnect(BoundingBox, (1 : i), interPersonID, info);
                        extIndex(1:i) = 1;
                    end
                else
                    [BoundingBox, info] = BoundingBoxConnect(BoundingBox, i, interPersonID, info);
                    extIndex(i) = 1;
                end
            else
                [BoundingBox, info] = BoundingBoxConnect(BoundingBox, i, interPersonID, info);
                extIndex(i) = 1;
            end
        end
    end
end
info.PersonInfo(:, 1:4, :) = BoundingBox;

function interPersonID = extractInterPersonID(inter)
[temp, remain] = strtok(inter); clear temp;
C = textscan(remain, '%d %s %d');
interPersonID = [C{1}; C{3}];
interPersonID = interPersonID + 1;
    
function [BoundingBox info] = BoundingBoxConnect(BoundingBox, Index, interPersonID, info)
nProFrame = length(Index); % nProFrame: number of Processing Frame
BottomLocation = BoxBottom(info.Type, info.Clip);
if BottomLocation ~= -1
    BoundingBox(Index, 4, interPersonID) = BoxBottom(info.Type, info.Clip);
end
if ~(BoundingBox(Index(end), 3, interPersonID(1)) < BoundingBox(Index(end), 1, interPersonID(2)))
    % if 1st person right most point IS NOT less than the 2nd person left
    % most point. flip it. 
    % which means, we always want to keep the first Person is the person on
    % the left
    interPersonID = flipud(interPersonID);
end
% for i = 1 : nProFrame
    LeftPersonRightPoint = BoundingBox(Index(end), 3, interPersonID(1));
    RightPersonLeftPoint = BoundingBox(Index(end), 1, interPersonID(2));
    Distance = RightPersonLeftPoint - LeftPersonRightPoint;
    if Distance > 2
        % if the bounding box distance is more than 2 then do the
        % connection operation. otherwise, if the distance is less than 2
        % or even the two boundingbox is overlap with each other. do
        % nothing.
        MergingPoint = LeftPersonRightPoint + floor(Distance / 2);
        BoundingBox(Index(end), 3, interPersonID(1)) = MergingPoint;
        BoundingBox(Index(end), 1, interPersonID(2)) = MergingPoint + 1;
%         BoundingBox(Index(i), 4, interPersonID) = 350;
%         BoundingBox(Index(i), 1 : 2, interPersonID) = BoundingBox(Index(end), 1 : 2, interPersonID);
%         info.PersonInfo(Index(i), 5 : 6, interPersonID) = info.PersonInfo(Index(end), 5 : 6, interPersonID);
    end
% end
% 
for i = 1 : nProFrame - 1
    BoundingBox(Index(i), 1 : 3, interPersonID) = BoundingBox(Index(end), 1 : 3, interPersonID);
    info.PersonInfo(Index(i), 5 : 6, interPersonID) = info.PersonInfo(Index(end), 5 : 6, interPersonID);
end

function BottomLocation = BoxBottom(Type, Clip)
BLBatch = 350 * ones(4, 50);
BLBatch(1, 2) = 260;    BLBatch(1, 4) = 290;   BLBatch(1, 8) = 190; 
BLBatch(1, 9) = 252;    BLBatch(1, 12) = 430;   BLBatch(1, 23) = 250;
BLBatch(1, 24) = 190;
BLBatch(2, :) = -1;     BLBatch(2, 2) = 350;    BLBatch(2, 6) = 235;
BLBatch(3, :) = 245;    BLBatch(3, 6) = -1;     BLBatch(3, 9) = -1;
BLBatch(3, 12 : 14) = -1; BLBatch(3, 16) = -1;  BLBatch(3, 23) = -1;
BLBatch(3, 24) = 180;   BLBatch(3, 29) = -1;    BLBatch(3, 33) = -1;
BLBatch(3, 36) = 160;   BLBatch(3, 40) = -1;    BLBatch(3, 44) = -1;
BottomLocation = BLBatch(Type + 1, Clip);