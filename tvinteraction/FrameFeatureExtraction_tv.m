function FrameFeature = FrameFeatureExtraction_tv(Person, interactivePersonID, FrameNum)
% Extract the Frame Features on according to the interactive happens
% frames. Extract the Frames like Gradient.Angles. and so on for the future
% expansion.
nFrameNum = length(FrameNum); 
n_intPerson = length(interactivePersonID);
FrameFeature = cell(n_intPerson, 1);
try
for i = 1 : n_intPerson
    tFeature = Person(interactivePersonID(i)).Gradient.Angles(:, :, 1);
    tFeature = tFeature(:);
    tFF = zeros(size(tFeature, 1), nFrameNum);
    for j =1 : nFrameNum
        tFeature = Person(interactivePersonID(i)).Gradient.Angles(:, :, j);
        tFF(:, j) = tFeature(:);
    end
    FrameFeature{i} = tFF;
end
catch ME
    display(['i = ' num2str(i)]);
    display(['j = ' num2str(j)]);
end