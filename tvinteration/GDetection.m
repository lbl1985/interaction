function [angles magnit] = GDetection(Im, hx, hy)
% Im = double(mat(:, :, i));
grad_xr = imfilter(double(Im),hx);
grad_yu = imfilter(double(Im),hy);
angles=atan2(grad_yu,grad_xr);
magnit=((grad_yu.^2).*(grad_xr.^2)).^.5;