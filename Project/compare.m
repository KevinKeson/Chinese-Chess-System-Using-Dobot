function [centerB, XB, YB] = compare(ImageB, BWB, centerA, XA, YA, offense)
%COMPARE Compare Image B with Image A.
%   Author: KevinK
%   Date: 2019/05/16 23:16:21
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
if offense == "Black"
    % Black is on the offensive
    defense = 'Red';
    A = [1 4 7]; A = A(randperm(numel(A)));
    B = [2 5 8]; B = B(randperm(numel(B)));
    C = [3 6 9]; C = C(randperm(numel(C)));
    order = [A B C]; BW1 = BWB{1, 1}; BW2 = BWB{1, 2};
    centerA = centerA{1, 1}; XA = XA{1, 1}; YA = YA{1, 1};
else
    % Red is on the offensive
    defense = 'Black';
    A = [3 6 9]; A = A(randperm(numel(A)));
    B = [2 5 8]; B = B(randperm(numel(B)));
    C = [1 4 7]; C = C(randperm(numel(C)));
    order = [A B C]; BW1 = BWB{1, 2}; BW2 = BWB{1, 1};
    centerA = centerA{1, 2}; XA = XA{1, 2}; YA = YA{1, 2};
end
[m, n] = size(BW1); radiusB = cell(1, 9);
XB = cell(1, 2); X1 = zeros(1, 9); X2 = zeros(1, 9);
YB = cell(1, 2); Y1 = zeros(1, 9); Y2 = zeros(1, 9);
centerB = cell(1, 9); center1 = cell(1, 9); center2 = cell(1, 9);
f = figure('Name', ['Image B ' char(offense)], 'NumberTitle', 'off');

%% Compare
result = true;
for i = 1 : 9
    a = order(i);
    [center1(1, a), radiusB(1, a), X1(1, a), Y1(1, a)] = process(BW1, a);
    if (size(center1{1, a}, 1) == size(centerA{1, a}, 1) + 1) || ...
            ((size(center1{1, a}, 1) == size(centerA{1, a}, 1)) && ...
            ((abs(X1(1, a) - XA(1, a)) > 46) || (abs(Y1(1, a) - YA(1, a)) > 46)))
        %% Show and Recognize Result
        [Result, x, y] = getimage(center1, centerA, radiusB, ImageB, m, n, a);
        step = i; result = false; break;
    end
end
if result
    fprintf('No Change Happened.\n');
end

%% Complete 1
figure(f);
if step < 9
    for j = step + 1 : 9
        b = order(j);
        [center1(1, b), ~, X1(1, b), Y1(1, b)] = process(BW1, b);
    end
end
%% Show Chess Movement Step
showstep(center1, centerA, X1, Y1, XA, YA, m, n, x, y, Result, offense);
%% Complete 2
figure('Name', ['Image B ' defense], 'NumberTitle', 'off');
for k = 1 : 9
    [center2(1, k), ~, X2(1, k), Y2(1, k)] = process(BW2, k);
end
if offense == "Black"
    % Black is on the offensive
    XB{1, 1} = X1; XB{1, 2} = X2;
    YB{1, 1} = Y1; YB{1, 2} = Y2;
    centerB{1, 1} = center1; centerB{1, 2} = center2;
else
    % Red is on the offensive
    XB{1, 2} = X1; XB{1, 1} = X2;
    YB{1, 2} = Y1; YB{1, 1} = Y2;
    centerB{1, 2} = center1; centerB{1, 1} = center2;
end

end


function [Result, x, y] = getimage(centerB, centerA, radiusB, ImageB, m, n, number)
%GETIMAGE Get chess image and global coordinate x and y.
%   Author: KevinK
%   Date: 2019/05/8 01:10:46
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
figure('Name', 'Result', 'NumberTitle', 'off');
arrayB = cell2mat(centerB(1, number));
arrayA = cell2mat(centerA(1, number));
radius = cell2mat(radiusB(1, number));

%% Get Image
if isempty(arrayA)
    x = arrayB(1, 1);
    y = arrayB(1, 2);
    r = radius(1, 1);
    Result = showimage(ImageB, number, m, n, x, y, r);
else
    sizeB = size(arrayB, 1);
    sizeA = size(arrayA, 1);
    for i = randperm(sizeB)
        result = 0;
        xb = arrayB(i, 1);
        yb = arrayB(i, 2);
        for j = randperm(sizeA)
            if (abs(xb - arrayA(j, 1)) < 23) && (abs(yb - arrayA(j, 2)) < 23)
                break;
            else
                result = result + 1;
            end
        end
        if result == sizeA
            x = arrayB(i, 1);
            y = arrayB(i, 2);
            r = radius(i, 1);
            Result = showimage(ImageB, number, m, n, x, y, r);
            break;
        end
    end
end

%% Get Coordinate
switch number
    case 1
        y = round(y); x = round(x);
    case 2
        y = round(y); x = round(n/3 + x);
    case 3
        y = round(y); x = round(n*2/3 + x);
    case 4
        y = round(m/3 + y); x = round(x);
    case 5
        y = round(m/3 + y); x = round(n/3 + x);
    case 6
        y = round(m/3 + y); x = round(n*2/3 + x);
    case 7
        y = round(m*2/3 + y); x = round(x);
    case 8
        y = round(m*2/3 + y); x = round(n/3 + x);
    case 9
        y = round(m*2/3 + y); x = round(n*2/3 + x);
end

end


function Result = showimage(ImageB, number, m, n, x, y, r)
%SHOWIMAGE Display chess image.
%   Author: KevinK
%   Date: 2019/05/12 21:36:15
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
global netTransfer;
%% Show Image
switch number
    case 1
        image = ImageB(floor(y-r) : ceil(y+r), floor(x-r) : ceil(x+r), :);
    case 2
        image = ImageB(floor(y-r) : ceil(y+r), floor(n/3+x-r)+10 : ceil(n/3+x+r)+10, :);
    case 3
        image = ImageB(floor(y-r) : ceil(y+r), floor(n*2/3+x-r)-10 : ceil(n*2/3+x+r)-10, :);
    case 4
        image = ImageB(floor(m/3+y-r) : ceil(m/3+y+r), floor(x-r) : ceil(x+r), :);
    case 5
        image = ImageB(floor(m/3+y-r) : ceil(m/3+y+r), floor(n/3+x-r)+10 : ceil(n/3+x+r)+10, :);
    case 6
        image = ImageB(floor(m/3+y-r) : ceil(m/3+y+r), floor(n*2/3+x-r)-10 : ceil(n*2/3+x+r)-10, :);
    case 7
        image = ImageB(floor(m*2/3+y-r) : ceil(m*2/3+y+r), floor(x-r) : ceil(x+r), :);
    case 8
        image = ImageB(floor(m*2/3+y-r) : ceil(m*2/3+y+r), floor(n/3+x-r)+10 : ceil(n/3+x+r)+10, :);
    case 9
        image = ImageB(floor(m*2/3+y-r) : ceil(m*2/3+y+r), floor(n*2/3+x-r)-10 : ceil(n*2/3+x+r)-10, :);
end
imshow(image);
%% Recognition
image = imresize(image, [227 227]);
Result = classify(netTransfer, image);

end
