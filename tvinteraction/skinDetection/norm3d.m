function diff = norm3d(A, B)
% Euclidean Distance between two 3D Matrix A and B. 
% Normalized by the average number of non zeros pixels in A and B.
k = A - B;
k = k.^2;
k = sqrt(sum(k(:)));
numA = regionprops(A ~= 0, 'Area');
numB = regionprops(B ~= 0, 'Area');
diff = k / mean([numA.Area numB.Area]);
