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
ratioAveTransfer = ratioAveTransfer(:);
figure(2); plot(1:100, ratioAveTransfer(1:100), 'g*-');
hold on; plot(101: 200, ratioAveTransfer(101: 200), 'r^-'); hold off;
title('Overlap Ratio v.s. Action Type');
xlabel('Clip Numbers: 1-50 handshaking 51-100 highFive 101-150 kiss 151 - 200 hug');
ylabel('Overlap Ratio');
legend('hansshaking/highFive', 'kiss/hug');

classRes = ratioAveTransfer(:) < 0.12;
AccRate1_2 = sum(classRes(1:100)) / 100; 
AccRate3_4 = sum(classRes(101:200)) / 100;
AccRate = mean([AccRate1_2 1- AccRate3_4]);

       