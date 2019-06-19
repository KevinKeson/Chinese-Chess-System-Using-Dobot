%% Initialization
clear; close all; clc

%% The Principle
A = imread('Test.jpg');
A = imrotate(A, 90); A = A(495-305 : 495+305, :, :);
AR = A(:, :, 1); AG = A(:, :, 2); AB = A(:, :, 3);
%% Black Ones
% 'Sensitivity' default is 0.50 in the range [0 1]
% default BW = imbinarize(I, 'adaptive', Name, Value)
BWBlack = imbinarize(AR, 'adaptive', 'Sensitivity', 0.28, 'ForegroundPolarity', 'dark');
% 'Sensitivity' default is 0.85 in the range [0 1]
% 'ObjectPolarity' and 'EdgeThreshold' are not necessary
[centersB, radiiB] = imfindcircles(BWBlack, [20 27], 'Method', 'TwoStage', 'Sensitivity', 0.86);
%% Red Ones
BWR = imbinarize(AR, 0.39);
% BWRed = AG/2 + AB/2; BWRed(BWR == 0) = 255; BWRed = imbinarize(BWRed, 0.45);
BWRed = AG; BWRed(BWR == 0) = 255; BWRed = imbinarize(BWRed, 'adaptive', 'Sensitivity', 0.28, 'ForegroundPolarity', 'dark');
% 'Sensitivity' default is 0.85 in the range [0 1]
% 'ObjectPolarity' and 'EdgeThreshold' are not necessary
[centersR, radiiR] = imfindcircles(BWRed, [20 27], 'Method', 'TwoStage', 'Sensitivity', 0.86);
%% Display the Results
figure('Name', 'Image Black', 'NumberTitle', 'off');
% 'EnhanceVisibility' and 'LineWidth' are not necessary
imshow(BWBlack); viscircles(centersB, radiiB, 'EdgeColor', 'b', 'LineStyle', ':');
figure('Name', 'Image Red', 'NumberTitle', 'off');
% 'EnhanceVisibility' and 'LineWidth' are not necessary
imshow(BWRed); viscircles(centersR, radiiR, 'EdgeColor', 'b', 'LineStyle', ':');
