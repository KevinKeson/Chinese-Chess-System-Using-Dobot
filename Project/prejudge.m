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
% �����Ƕ�ȫ�ֽ���Ԥ�ж� ���������ת��Ϊ��������
% ���Լ���ؽ���ʧ����� ���ƶ�����ʱ��С�Ĵ�������Χ������
% ����������ͷ�̶��� ǰ����Ƭ��С ���������Ҳ���Ǳ�Ҫ��
% ֻ���ж��ܺ�С��һ��ֱ������ ���Compare.m�����ƻ���
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
