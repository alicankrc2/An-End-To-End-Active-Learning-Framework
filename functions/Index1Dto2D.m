function [x y] = Index1Dto2D(Index1D, H, W)
% ��1D����ת��Ϊ2D����
x = mod(Index1D,H);
y = (Index1D-x)/H + 1;
if (x==0)
    y = y - 1;
    x = H;
end