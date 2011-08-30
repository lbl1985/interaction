function trajectory = RegionTrajectory(diffMatrix)
[numRegions, ~, nframe]= size(diffMatrix);
trajectory = zeros(numRegions, nframe);
% try
for i = 1 : numRegions
    trajectory(i, 1) = i;
    for j = 1 : nframe - 1
%         row = diffMatrix(i, :, j);
        [A, trajectory(i, j+1)] = min(diffMatrix(trajectory(i, j), :, j));
    end
end
% catch
%     display(['[i, j] = ', num2str(i) ' ' num2str(j)]);
% end

        