function Feedback = prejudge(BWB, BWA)
%PREJUDGE Prejudge chess move.
%   Author: KevinK
%   Date: 2019/06/13 11:47:25
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
Feedback = false;
BWBBlack = BWB{1, 1}; BWBRed = BWB{1, 2};
BWABlack = BWA{1, 1}; BWARed = BWA{1, 2};
%% Black Ones
[centerBBlack, ~] = findcircles(BWBBlack);
[centerBRed, ~] = findcircles(BWBRed);
[centerABlack, ~] = findcircles(BWABlack);
[centerARed, ~] = findcircles(BWARed);
centerB = [centerBBlack; centerBRed];
centerA = [centerABlack; centerARed];
sizeB = size(centerB, 1);
sizeA = size(centerA, 1);
% 由于是对全局进行预判断 将相对坐标转换为绝对坐标
% 可以极大地降低失误概率 如移动棋子时不小心触碰到周围的棋子
% 但由于摄像头固定后 前后照片误差极小 故这个环节也不是必要的
% 只需判断总和小于一倍直径即可 详见Compare.m中类似环节
% Convert relative coordinates to absolute coordinates
for i = 1 : sizeB
    [centerB(i, 1), centerB(i, 2)] = getcoordinate(centerB(i, 1), centerB(i, 2));
end
% Convert relative coordinates to absolute coordinates
for i = 1 : sizeA
    [centerA(i, 1), centerA(i, 2)] = getcoordinate(centerA(i, 1), centerA(i, 2));
end
summationB = sum(centerB, 1); summationA = sum(centerA, 1);
XB = summationB(1, 1); YB = summationB(1, 2);
XA = summationA(1, 1); YA = summationA(1, 2);
%% Prejudge
if (sizeB == sizeA - 1) || ...
        ((sizeB == sizeA) && ...
        ((abs(XB - XA) > 0 && abs(XB - XA) < 10) || ...
        (abs(YB - YA) > 0 && abs(YB - YA) < 9)))
    Feedback = true;
end

end
