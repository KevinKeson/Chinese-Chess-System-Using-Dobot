function showstep(centerB, centerA, XB, YB, XA, YA, m, n, x, y, Result, offense)
%SHOWSTEP Display chess movement step in Chinese chess interface.
%   Author: KevinK
%   Date: 2019/05/26 00:03:32
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
global Board;
global ChessImage;
% Get Chess Mark Image
mark1 = ChessImage{1, 33};
mark2 = ChessImage{1, 34};
highlight = ChessImage{1, 35};
if nargin == 0
    % Black is on the offensive
    offense = "Black"; defense = "Red";
end
%% Judge
if nargin == 12
if offense == "Black"
    % Black is on the offensive
    defense = "Red";
    A = [1 4 7]; A = A(randperm(numel(A)));
    B = [2 5 8]; B = B(randperm(numel(B)));
    C = [3 6 9]; C = C(randperm(numel(C)));
    order = [A B C];
else
    % Red is on the offensive
    defense = "Black";
    A = [3 6 9]; A = A(randperm(numel(A)));
    B = [2 5 8]; B = B(randperm(numel(B)));
    C = [1 4 7]; C = C(randperm(numel(C)));
    order = [A B C];
end

%% Compare
for i = order
    if (size(centerA{1, i}, 1) == size(centerB{1, i}, 1) + 1) || ...
            ((size(centerA{1, i}, 1) == size(centerB{1, i}, 1)) && ...
            ((abs(XA(1, i) - XB(1, i)) > 46) || (abs(YA(1, i) - YB(1, i)) > 46)))
        arrayA = cell2mat(centerA(1, i));
        arrayB = cell2mat(centerB(1, i));
        %% Get Local Coordinate
        if isempty(arrayB)
            x0 = arrayA(1, 1);
            y0 = arrayA(1, 2);
        else
            sizeA = size(arrayA, 1);
            sizeB = size(arrayB, 1);
            for j = randperm(sizeA)
                result = 0;
                xa = arrayA(j, 1);
                ya = arrayA(j, 2);
                for k = randperm(sizeB)
                    if (abs(xa - arrayB(k, 1)) < 23) && (abs(ya - arrayB(k, 2)) < 23)
                        break;
                    else
                        result = result + 1;
                    end
                end
                if result == sizeB
                    x0 = arrayA(j, 1);
                    y0 = arrayA(j, 2);
                    break;
                end
            end
        end
        %% Get Global Coordinate
        switch i
            case 1
                y0 = round(y0); x0 = round(x0);
            case 2
                y0 = round(y0); x0 = round(n/3 + x0);
            case 3
                y0 = round(y0); x0 = round(n*2/3 + x0);
            case 4
                y0 = round(m/3 + y0); x0 = round(x0);
            case 5
                y0 = round(m/3 + y0); x0 = round(n/3 + x0);
            case 6
                y0 = round(m/3 + y0); x0 = round(n*2/3 + x0);
            case 7
                y0 = round(m*2/3 + y0); x0 = round(x0);
            case 8
                y0 = round(m*2/3 + y0); x0 = round(n/3 + x0);
            case 9
                y0 = round(m*2/3 + y0); x0 = round(n*2/3 + x0);
        end
        break;
    end
end

%% Show Step
% Get Coordinate
[x, y] = getcoordinate(x, y);
[x0, y0] = getcoordinate(x0, y0);
%% Get Chess Image
ImageEnd = getchessimage(x, y, defense);
ImageStart = getchessimage(x0, y0, offense);
%% Change Image Visibility
if not(isempty(ImageEnd))
    ImageEnd.Visible = 'off';
end
if mark1.Visible == "off"
    mark1.Visible = 'on';
    mark2.Visible = 'on';
end
%% Move Chess Image
if highlight.Visible == "on"
    highlight.XData = mark2.XData;
    highlight.YData = mark2.YData;
end
movechessimage(mark2, x, y);
movechessimage(mark1, x0, y0);
movechessimage(ImageStart, x, y);
%% Change Board Status
switch Result
    case "b_jiang"
        num = 1;
    case "b_ju"
        num = 2;
    case "b_ma"
        num = 3;
    case "b_xiang"
        num = 6;
    case "b_shi"
        num = 5;
    case "b_pao"
        num = 4;
    case "b_zu"
        num = 7;
    case "r_shuai"
        num = 8;
    case "r_ju"
        num = 9;
    case "r_ma"
        num = 10;
    case "r_xiang"
        num = 13;
    case "r_shi"
        num = 12;
    case "r_pao"
        num = 11;
    case "r_zu"
        num = 14;
end
Board(y, x) = num; Board(y0, x0) = 0;
end
%% Get Next Move
if offense == "Black"
    % Black is on the offensive
    calllib('NegaMaxSearch', 'SearchAGoodMove', Board(end:-1:1, end:-1:1), 1);
    x = 1 + (9 - calllib('NegaMaxSearch', 'get_to_y'));
    y = 1 + (8 - calllib('NegaMaxSearch', 'get_to_x'));
    x0 = 1 + (9 - calllib('NegaMaxSearch', 'get_from_y'));
    y0 = 1 + (8 - calllib('NegaMaxSearch', 'get_from_x'));
else
    % Red is on the offensive
    calllib('NegaMaxSearch', 'SearchAGoodMove', Board, 2);
    x = 1 + calllib('NegaMaxSearch', 'get_to_y');
    y = 1 + calllib('NegaMaxSearch', 'get_to_x');
    x0 = 1 + calllib('NegaMaxSearch', 'get_from_y');
    y0 = 1 + calllib('NegaMaxSearch', 'get_from_x');
end
Board(y, x) = Board(y0, x0); Board(y0, x0) = 0;
%% Get Chess Image
ImageEnd = getchessimage(x, y, offense);
ImageStart = getchessimage(x0, y0, defense);
%% Change Image Visibility
if isempty(ImageStart)
    fprintf('Game is over.\n');
    pause;
end
if not(isempty(ImageEnd))
    iseaten = true;
    ImageEnd.Visible = 'off';
else
    iseaten = false;
end
%% Move Chess Image
if highlight.Visible == "off" && nargin == 12
    highlight.Visible = 'on';
end
if mark1.Visible == "off" && nargin == 0
    mark1.Visible = 'on';
    mark2.Visible = 'on';
end
highlight.XData = mark2.XData;
highlight.YData = mark2.YData;
movechessimage(mark2, x, y);
movechessimage(mark1, x0, y0);
movechessimage(ImageStart, x, y);
%% Dobot
Dobot(x0, y0, x, y, iseaten);
pause(2);

end


function Image = getchessimage(x, y, offense)
%GETCHESSIMAGE Get chess image handle using coordinate x and y.
%   Author: KevinK
%   Date: 2019/05/26 02:12:37
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
Image = [];
global ChessImage;
if offense == "Black"
    order = 1 : 16;
else
    order = 17 : 32;
end
%% Get Chess Image
for i = order
    chessimage = ChessImage{1, i};
    if ((chessimage.XData(1, 1)+65-1) == 71+130*(x-1) || ...
            (x == 5 && (chessimage.XData(1, 1)+65-1) == 593) || ...
            (x == 6 && (chessimage.XData(1, 1)+65-1) == 727) || ...
            (chessimage.XData(1, 1)+65-1) == 859+130*(x-7)) && ...
            (chessimage.YData(1, 1)+65-1) == 77+130*(y-1)
        if chessimage.Visible == "on"
            Image = chessimage;
            break;
        end
    end
end

end


function movechessimage(Image, x, y)
%MOVECHESSIMAGE Move chess image in Chinese chess interface.
%   Author: KevinK
%   Date: 2019/05/26 03:58:27
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Move Chess Image
% Coordinate X
switch x
    case 1
        Image.XData = [71-65+1 72+65-1];
    case 2
        Image.XData = [201-65+1 202+65-1];
    case 3
        Image.XData = [331-65+1 332+65-1];
    case 4
        Image.XData = [461-65+1 462+65-1];
    case 5
        Image.XData = [593-65+1 594+65-1];
    case 6
        Image.XData = [727-65+1 728+65-1];
    case 7
        Image.XData = [859-65+1 860+65-1];
    case 8
        Image.XData = [989-65+1 990+65-1];
    case 9
        Image.XData = [1119-65+1 1120+65-1];
    case 10
        Image.XData = [1249-65+1 1250+65-1];
end
%% Coordinate Y
switch y
    case 1
        Image.YData = [77-65+1 78+65-1];
    case 2
        Image.YData = [207-65+1 208+65-1];
    case 3
        Image.YData = [337-65+1 338+65-1];
    case 4
        Image.YData = [467-65+1 468+65-1];
    case 5
        Image.YData = [597-65+1 598+65-1];
    case 6
        Image.YData = [727-65+1 728+65-1];
    case 7
        Image.YData = [857-65+1 858+65-1];
    case 8
        Image.YData = [987-65+1 988+65-1];
    case 9
        Image.YData = [1117-65+1 1118+65-1];
end

end
