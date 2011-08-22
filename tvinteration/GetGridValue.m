function V = GetGridValue(I, BoundingBox, nwin, mode, varargin)
directions = 8;
nwin_x = nwin(1); nwin_y = nwin(2);
lefttop = [BoundingBox(2) BoundingBox(1)];
rightbottom = [BoundingBox(4) BoundingBox(3)];
I = I(lefttop(1) : rightbottom(1), lefttop(2) : rightbottom(2));

[L,C]=size(I); % L num of lines ; C num of columns
step_x=floor(C/(nwin_x));
step_y=floor(L/(nwin_y));

V = zeros(nwin_y, nwin_x);
try
for n=0:nwin_y-1
    for m=0:nwin_x-1
        I2=I(n*step_y+1:(n+1)*step_y,m*step_x+1:(m+1)*step_x);
        v = I2(:);
        switch mode
            case 'maxDirection'
                edges = -pi : pi/directions : pi;                
                [temp, ind]= max(histc(v, edges)); clear temp;
                V(n + 1, m + 1) = edges(ind);
            case 'maxMagnitDirection'
                magnit = varargin{1}; 
                edges = -pi : pi/directions : pi;
                voteBox = zeros(length(edges), 1);
                [temp, bin] = histc(v, edges);  clear temp;
                for i = 1 : length(edges)
                    voteBox(i) = sum(magnit(find(bin == i)));
                end
                [temp, ind] = max(voteBox); clear temp;
                V(n + 1, m + 1) = edges(ind);
        end
%         V(n + 1, m + 1) = mean(v);
    end
end
catch ME
    display(ME.message);
    display(['n = ' num2str(n)]);
    display(['m = ' num2str(m)]);
end