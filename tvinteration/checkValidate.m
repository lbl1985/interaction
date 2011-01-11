function var = checkValidate(var, mode, varargin)
% This function should be moved into shortcut/MATLAB

switch mode
    case 'BoundingBox'
        siz = varargin{1};      
            
        var(var < 1) = 1;
        if nargin < 4
            if var(1) > siz(1), var(1) = siz(1); end
            if var(2) > siz(2), var(2) = siz(2); end
%         else
%             if var(1) > siz(1), var(1) = siz(1); end
%             if var(2) > siz(2), var(2) = siz(2); end
        end
end
        
    