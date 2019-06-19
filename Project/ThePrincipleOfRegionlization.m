%% Initialization
clear; close all; clc
% camera = webcam(2);
% imwrite(snapshot(camera), 'Image.jpg');

%% The Principle Of Regionlization
[Image, BW] = preprocess('Test\3.jpg');
[center, X, Y] = process(BW);
