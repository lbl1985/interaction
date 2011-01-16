vcm
ratioBatch = cell(4, 50);

for Type = 0 : 3
    display(['Type = ' num2str(Type)]);
    display('---------------------');
    for Clip = 1 : 50
        ratioBatch{Type+1, Clip} = clip_overlapRatio(Type, Clip);
        display(['Clip ' num2str(Clip)]);
    end
end
save ratioBatch ratioBatch
ratioAve = zeros(4, 50);
for i = 1 : 4
    for j = 1 : 50
        temp = ratioBatch{i, j};
        ind = temp ~= 0;        
        tempNoneZero = temp(ind);
        ratioAve(i, j) = sum(tempNoneZero(:)) / length(ind);
    end
end

ratioAveTransfer = ratioAve';
plot(1:200, ratioAveTransfer(:));
       