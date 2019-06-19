function [x2, y2] = getcoordinate(x, y)
%GETCOORDINATE Convert relative coordinates to absolute coordinates.
%   Author: KevinK
%   Date: 2019/05/26 01:37:48
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
% 由于摄像头固定后 被触碰之后会造成画面平移
% Correction Factor
a = 0; b = 0;
%% Get Coordinate
% Coordinate X
if abs(x - 38 + a) < 23
    x2 = 1;
elseif abs(x - 105 + a) < 23
    x2 = 2;
elseif abs(x - 172 + a) < 23
    x2 = 3;
elseif abs(x - 239 + a) < 23
    x2 = 4;
elseif abs(x - 306 + a) < 23
    x2 = 5;
elseif abs(x - 424 + a) < 23
    x2 = 6;
elseif abs(x - 490 + a) < 23
    x2 = 7;
elseif abs(x - 555 + a) < 23
    x2 = 8;
elseif abs(x - 622 + a) < 23
    x2 = 9;
elseif abs(x - 688 + a) < 23
    x2 = 10;
else
    x2 = 0;
end
%% Coordinate Y
if abs(y - 39 + b) < 23
    y2 = 1;
elseif abs(y - 106 + b) < 23
    y2 = 2;
elseif abs(y - 173 + b) < 23
    y2 = 3;
elseif abs(y - 240 + b) < 23
    y2 = 4;
elseif abs(y - 306 + b) < 23
    y2 = 5;
elseif abs(y - 372 + b) < 23
    y2 = 6;
elseif abs(y - 438 + b) < 23
    y2 = 7;
elseif abs(y - 506 + b) < 23
    y2 = 8;
elseif abs(y - 573 + b) < 23
    y2 = 9;
else
    y2 = 0;
end

end
