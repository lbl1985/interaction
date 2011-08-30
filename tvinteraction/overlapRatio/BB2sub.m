function sub = BB2sub(BB)
x = BB(1) : BB(3); 
y = BB(2) : BB(4);
% xindex = repmat(x', [length(y), 1]);
% yindex = repmat(y', [length(x), 1]);
[a b] = meshgrid(x, y);
sub = [a(:) b(:)];