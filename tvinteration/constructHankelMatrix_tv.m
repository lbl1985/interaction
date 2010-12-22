function HankelMatrix = constructHankelMatrix_tv(info, Person, HankelWindowSize)
PersonInfo = info.PersonInfo;
intInfo = PersonInfo(:, 5, :);
interactivePersonID = find(permute(sum(intInfo, 1), [3 1 2]) ~= 0);
interactivePersonID = interactivePersonID(1 : 2);
intFrameNum = find(intInfo(:, :, interactivePersonID(1)) ~= 0);
FF = FrameFeatureExtraction_tv(Person, interactivePersonID, intFrameNum);
hankelObj = cell(2, 1);
for i = 1 : 2
    hankelObj{i} = hankelConstruction(FF{i}, HankelWindowSize);
end
HankelMatrix = [hankelObj{1}; hankelObj{2}];