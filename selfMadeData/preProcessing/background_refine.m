mask = foreGround(:, :, 49);
figure; subplot(3, 2, 1); imshow(logical(foreGround(:, :, 50))); title('foreGround Mask');

[video, audio] = mmread(videoFullFileName, 59, [], false, true);
Iorg = video.frames(1).cdata;
subplot(3, 2, 2); imshow(Iorg); title(['Original Image']);

I = rgb2gray(Iorg);
subplot(3, 2, 3); imshow(I); title('I gray image');
[edges threshold] = edge(I, 'sobel');
subplot(3, 2, 4); imshow(edges); title('edges');

IorgMasked = double(Iorg) .* double(repmat(foreGround(:, :, 50), [1 1 3]));
subplot(3, 2, 5); imshow(uint8(IorgMasked)); title(['Maked Orig Image']);
IedgesMasked = double(edges) .* logical(foreGround(:, :, 50));
subplot(3, 2, 6); imshow(logical(IedgesMasked)); title(['Maked edge Image']);