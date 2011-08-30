function [u v x y] =quiverPre(Angles, BoundingBox, nwin)
[u v] = pol2cart(Angles, 0.0005); 
nwin_x = nwin(1); nwin_y = nwin(2);
lefttop = [BoundingBox(2) BoundingBox(1)];
rightbottom = [BoundingBox(4) BoundingBox(3)];

L = rightbottom(1) - lefttop(1);
C = rightbottom(2) - lefttop(2);

step_x = floor(C/(nwin_x)) + 0.9;
step_y = floor(L/(nwin_y));

% x = zeros(nwin_y, nwin_x); y = x;
% for n = 0: nwin_y - 1
%     for m = 0: nwin_x - 1
%         x(n + 1, m + 1) = lefttop(1) + n * step_y + floor(step_y/2);
%         y(n + 1, m + 1) = lefttop(2) + n * step_x + floor(step_x/2);
%     end
% end
% 
% u = u(:); v = v(:); 
% x = x(:); y = y(:);

% [x y] = meshgrid(lefttop(1) + floor(step_y/2) : step_y : rightbottom(1) - floor(step_y/2), ...
%     lefttop(2) + floor(step_x/2) : step_x : rightbottom(2) - floor(step_x/2));
XX = lefttop(2) : (C / nwin_x) : rightbottom(2); XX = bisection(XX);
YY = lefttop(1) : (L / nwin_y) : rightbottom(1); YY = bisection(YY);

[x y] = meshgrid(XX, YY);
% [x y] = meshgrid(floor(lefttop(2) + floor(step_x/2)) : floor(step_x) : floor(rightbottom(2) - floor(step_x/2)), ...
% floor(lefttop(1) + floor(step_y/2)) : floor(step_y) : floor(rightbottom(1) - floor(step_y/2)));

% while ~isequal(size(x), size(u))
%     if size(x, 2) < size(u, 2),  step_x = step_x - 1;   end
%     if size(x, 2) > size(u, 2),  step_x = step_x + 1;   end
%     if size(x, 1) < size(u, 1),  step_y = step_y - 1;   end
%     if size(x, 1) > size(u, 1),  step_y = step_y + 1;   end
%     else
%         step_x = step_x + 1;        step_y = step_y + 1;
%     end
%     [x y] = meshgrid(lefttop(2) + floor(step_x/2) : step_x : rightbottom(2) - floor(step_x/2), ...
%     lefttop(1) + floor(step_y/2) : step_y : rightbottom(1) - floor(step_y/2));
%     x = x / 2; y = y/2;
% end
    
       
function out = bisection(data)
D = length(data);
out = zeros(D-1, 1);
for i = 1 : D - 1
    out(i) = mean([data(i) data(i + 1)]);
end