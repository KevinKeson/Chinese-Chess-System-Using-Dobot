function [Image, BW] = preprocess(filename)
%PREPROCESS Preprocess digital image from graphics source file using MATLAB.
%   [IMAGE, BW] = PREPROCESS(FILENAME) reads a color image from the file
%   specified by FILENAME and binarizes digital IMAGE by thresholding.
%
%   IMAGE is a color image read from the file using A = IMREAD(FILENAME).
%   BW is a One-by-Two cell array. BW{1, 1} is BWBlack, BW{1, 2} is BWRed.
%   BWBlack and BWRed are binarized with BW = IMBINARIZE(I, METHOD).
%
%   Author: KevinK
%   Date: 2019/05/16 20:47:03
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
CorrectionFactor = 0;
Image = imread(filename);
Image = imrotate(Image, 90);
% 此处的画面XY范围 需要根据自己选择的摄像头和架设高度进行测定
% 调试实验可在ThePrinciple.m中进行 分区域检测效果可在ThePrincipleOfRegionlization.m中进行验证
Image = Image(495-305+CorrectionFactor : 495+305+CorrectionFactor, :, :);
R = Image(:, :, 1); G = Image(:, :, 2); B = Image(:, :, 3); BW = cell(1, 2);
%% Black Ones
% 'Sensitivity' default is 0.50 in the range [0 1]
% default BW = imbinarize(I, 'adaptive', Name, Value)
BWBlack = imbinarize(R, 'adaptive', 'Sensitivity', 0.28, 'ForegroundPolarity', 'dark');
%% Red Ones
BWRed = G; BWR = imbinarize(R, 0.39); BWRed(BWR == 0) = 255;
BWRed = imbinarize(BWRed, 'adaptive', 'Sensitivity', 0.28, 'ForegroundPolarity', 'dark');
%% Get Data
BW{1, 1} = BWBlack; BW{1, 2} = BWRed;

end
