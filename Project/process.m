function varargout = process(BW, number)
%PROCESS Process binary image by regionalizing.
%   [CENTER, X, Y] = PROCESS(BW) processes binary image BWBlack and BWRed
%   from the One-by-Two cell array BW. BW{1, 1} is BWBlack, BW{1, 2} is BWRed.
%
%   CENTER is a One-by-Two cell array. CENTER{1, 1} is centerBlack, CENTER{1, 2}
%   is centerRed. centerBlack and centerRed are found by using Circular Hough Transform.
%   X is a One-by-Two cell array. X{1, 1} is XBlack, X{1, 2} is XRed.
%   XBlack and XRed are summation of coordinate x in centerBlack and centerRed.
%   Y is a One-by-Two cell array. Y{1, 1} is YBlack, X{1, 2} is YRed.
%   YBlack and YRed are summation of coordinate y in centerBlack and centerRed.
%
%   [CENTER, RADIUS, X, Y] = PROCESS(BW, NUMBER) processes binary image BW
%   in region specified by NUMBER.
%
%   CENTER and RADIUS are found by using Circular Hough Transform in a region.
%   X is the summation of coordinate x. Y is the summation of coordinate y.
%
%   Author: KevinK
%   Date: 2019/05/16 01:33:57
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
if nargin < 2
    number = 0;
end
if iscell(BW)
    BWBlack = BW{1, 1};
    BWRed = BW{1, 2};
    [m, n] = size(BWRed);
else
    [m, n] = size(BW);
end

%% Process
if number ~= 0
    %% Step 1
    X = zeros(1, 1); Y = zeros(1, 1);
    center = cell(1, 1); radius = cell(1, 1);
    %% Step 2
    switch number
        case 1
            subplot(3, 3, 1);
            ga = BW(1 : floor(m/3), 1 : floor(n/3)+10);
            [center{1, 1}, radius{1, 1}] = show(ga);
        case 2
            subplot(3, 3, 2);
            gb = BW(1 : floor(m/3), ceil(n/3)+10 : floor(n*2/3)-10);
            [center{1, 1}, radius{1, 1}] = show(gb);
        case 3
            subplot(3, 3, 3);
            gc = BW(1 : floor(m/3), ceil(n*2/3)-10 : n);
            [center{1, 1}, radius{1, 1}] = show(gc);
        case 4
            subplot(3, 3, 4);
            gd = BW(ceil(m/3) : floor(m*2/3), 1 : floor(n/3)+10);
            [center{1, 1}, radius{1, 1}] = show(gd);
        case 5
            subplot(3, 3, 5);
            ge = BW(ceil(m/3) : floor(m*2/3), ceil(n/3)+10 : floor(n*2/3)-10);
            [center{1, 1}, radius{1, 1}] = show(ge);
        case 6
            subplot(3, 3, 6);
            gf = BW(ceil(m/3) : floor(m*2/3), ceil(n*2/3)-10 : n);
            [center{1, 1}, radius{1, 1}] = show(gf);
        case 7
            subplot(3, 3, 7);
            gg = BW(ceil(m*2/3) : m, 1 : floor(n/3)+10);
            [center{1, 1}, radius{1, 1}] = show(gg);
        case 8
            subplot(3, 3, 8);
            gh = BW(ceil(m*2/3) : m, ceil(n/3)+10 : floor(n*2/3)-10);
            [center{1, 1}, radius{1, 1}] = show(gh);
        case 9
            subplot(3, 3, 9);
            gi = BW(ceil(m*2/3) : m, ceil(n*2/3)-10 : n);
            [center{1, 1}, radius{1, 1}] = show(gi);
    end
    %% Step 3
    centermat = cell2mat(center(1, 1));
    if isempty(centermat)
        X(1, 1) = 0; Y(1, 1) = 0;
    else
        % parameter 1 is necessary
        % for centermat can be vector or array
        summation = sum(centermat, 1);
        X(1, 1) = summation(1, 1);
        Y(1, 1) = summation(1, 2);
    end
    varargout{1} = center;
    varargout{2} = radius;
    varargout{3} = X;
    varargout{4} = Y;
else
    %% Step 1
    X = cell(1, 2); XBlack = zeros(1, 9); XRed = zeros(1, 9);
    Y = cell(1, 2); YBlack = zeros(1, 9); YRed = zeros(1, 9);
    center = cell(1, 2); centerBlack = cell(1, 9); centerRed = cell(1, 9);
    %% Step 2
    % Region 1
    ga1 = BWBlack(1 : floor(m/3), 1 : floor(n/3)+10);
    ga2 = BWRed(1 : floor(m/3), 1 : floor(n/3)+10);
    % Region 2
    gb1 = BWBlack(1 : floor(m/3), ceil(n/3)+10 : floor(n*2/3)-10);
    gb2 = BWRed(1 : floor(m/3), ceil(n/3)+10 : floor(n*2/3)-10);
    % Region 3
    gc1 = BWBlack(1 : floor(m/3), ceil(n*2/3)-10 : n);
    gc2 = BWRed(1 : floor(m/3), ceil(n*2/3)-10 : n);
    % Region 4
    gd1 = BWBlack(ceil(m/3) : floor(m*2/3), 1 : floor(n/3)+10);
    gd2 = BWRed(ceil(m/3) : floor(m*2/3), 1 : floor(n/3)+10);
    % Region 5
    ge1 = BWBlack(ceil(m/3) : floor(m*2/3), ceil(n/3)+10 : floor(n*2/3)-10);
    ge2 = BWRed(ceil(m/3) : floor(m*2/3), ceil(n/3)+10 : floor(n*2/3)-10);
    % Region 6
    gf1 = BWBlack(ceil(m/3) : floor(m*2/3), ceil(n*2/3)-10 : n);
    gf2 = BWRed(ceil(m/3) : floor(m*2/3), ceil(n*2/3)-10 : n);
    % Region 7
    gg1 = BWBlack(ceil(m*2/3) : m, 1 : floor(n/3)+10);
    gg2 = BWRed(ceil(m*2/3) : m, 1 : floor(n/3)+10);
    % Region 8
    gh1 = BWBlack(ceil(m*2/3) : m, ceil(n/3)+10 : floor(n*2/3)-10);
    gh2 = BWRed(ceil(m*2/3) : m, ceil(n/3)+10 : floor(n*2/3)-10);
    % Region 9
    gi1 = BWBlack(ceil(m*2/3) : m, ceil(n*2/3)-10 : n);
    gi2 = BWRed(ceil(m*2/3) : m, ceil(n*2/3)-10 : n);
    % Display Result
    figure('Name', 'Image A Black', 'NumberTitle', 'off');
    subplot(3, 3, 1); [centerBlack{1, 1}, ~] = show(ga1);
    subplot(3, 3, 2); [centerBlack{1, 2}, ~] = show(gb1);
    subplot(3, 3, 3); [centerBlack{1, 3}, ~] = show(gc1);
    subplot(3, 3, 4); [centerBlack{1, 4}, ~] = show(gd1);
    subplot(3, 3, 5); [centerBlack{1, 5}, ~] = show(ge1);
    subplot(3, 3, 6); [centerBlack{1, 6}, ~] = show(gf1);
    subplot(3, 3, 7); [centerBlack{1, 7}, ~] = show(gg1);
    subplot(3, 3, 8); [centerBlack{1, 8}, ~] = show(gh1);
    subplot(3, 3, 9); [centerBlack{1, 9}, ~] = show(gi1);
    figure('Name', 'Image A Red', 'NumberTitle', 'off');
    subplot(3, 3, 1); [centerRed{1, 1}, ~] = show(ga2);
    subplot(3, 3, 2); [centerRed{1, 2}, ~] = show(gb2);
    subplot(3, 3, 3); [centerRed{1, 3}, ~] = show(gc2);
    subplot(3, 3, 4); [centerRed{1, 4}, ~] = show(gd2);
    subplot(3, 3, 5); [centerRed{1, 5}, ~] = show(ge2);
    subplot(3, 3, 6); [centerRed{1, 6}, ~] = show(gf2);
    subplot(3, 3, 7); [centerRed{1, 7}, ~] = show(gg2);
    subplot(3, 3, 8); [centerRed{1, 8}, ~] = show(gh2);
    subplot(3, 3, 9); [centerRed{1, 9}, ~] = show(gi2);
    % Get Data
    center{1, 1} = centerBlack; center{1, 2} = centerRed;
    %% Step 3
    for i = 1 : 9
        % Black Ones
        centermat1 = cell2mat(centerBlack(1, i));
        if isempty(centermat1)
            XBlack(1, i) = 0;
            YBlack(1, i) = 0;
        else
            % parameter 1 is necessary
            % for centermat can be vector or array
            summation1 = sum(centermat1, 1);
            XBlack(1, i) = summation1(1, 1);
            YBlack(1, i) = summation1(1, 2);
        end
        % Red Ones
        centermat2 = cell2mat(centerRed(1, i));
        if isempty(centermat2)
            XRed(1, i) = 0;
            YRed(1, i) = 0;
        else
            % parameter 1 is necessary
            % for centermat can be vector or array
            summation2 = sum(centermat2, 1);
            XRed(1, i) = summation2(1, 1);
            YRed(1, i) = summation2(1, 2);
        end
    end
    % Get Data
    X{1, 1} = XBlack; X{1, 2} = XRed;
    Y{1, 1} = YBlack; Y{1, 2} = YRed;
    %% Step 4
    varargout{1} = center;
    varargout{2} = X;
    varargout{3} = Y;
end

end


function [centers, radii] = show(I)
%SHOW Display original image and circles.
%   Author: KevinK
%   Date: 2019/05/01 17:55:16
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Show
imshow(I, []);
[centers, radii] = findcircles(I);
% 'EnhanceVisibility' and 'LineWidth' are not necessary
viscircles(centers, radii, 'EdgeColor', 'b', 'LineStyle', ':');

end
