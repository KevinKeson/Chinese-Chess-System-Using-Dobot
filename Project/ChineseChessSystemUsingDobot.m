%% Initialization
clear; close all; clc
load('RecognitionModel\alex_transfered.mat');
loadlibrary('MagicianDll\DobotDll.dll', 'MagicianDll\DobotDll.h');
loadlibrary('ChessAIDll\NegaMaxSearch.dll', 'ChessAIDll\NegaMaxSearch.h');
global netTransfer; offense = "Black"; camera = webcam(2); clc
fprintf('\nWelcome to CCSUD System.\n\nAuthor: KevinK, KevinR, Ivy.\n\n');
Dobot(1); Dobot(2);  showinterface;

%% Chinese Chess System Using Dobot
% For the first move by Dobot
% 二次开发时 可自行添加初始化棋盘搜索识别的部分 即从任意残局开始
% This part can also be involved in the WHILE-LOOP structure below
if offense == "Black"
    showstep;
end
while true
    %% Save the new result
    % Save the image for debugging
    imwrite(snapshot(camera), 'Image.jpg');
    [~, BWA] = preprocess('Image.jpg');
    [centerA, XA, YA] = process(BWA);
    while true
        %% Get the changed image and Preprocess
        % Double check for the first time
        imwrite(snapshot(camera), 'Image.jpg');
        [Image, BWB] = preprocess('Image.jpg');
        if prejudge(BWB, BWA)
            while true
                % Double check for the second time
                imwrite(snapshot(camera), 'Image.jpg');
                [Image, BWB] = preprocess('Image.jpg');
                if prejudge(BWB, BWA)
                    %% Compare and move chess
                    % centerB XB and YB are not necessary
                    % Ignoring these return values can speed up programs
                    [centerB, XB, YB] = compare(Image, BWB, centerA, XA, YA, offense);
                    fprintf('Dobot moves chess finished.\n');
                    close('Image A Black'); close('Image A Red');
                    close('Image B Black'); close('Image B Red');
                    close('Result');
                    break;
                end
            end
            break;
        end
    end
end
