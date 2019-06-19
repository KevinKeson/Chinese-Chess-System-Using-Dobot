function showinterface
%SHOWINTERFACE Display Chinese chess interface in Handle Graphics figure.
%   SHOWINTERFACE displays a Chinese chess interface using PNG in 'icon\'.
%
%   ChessImage is a global variable for displaying Chess movement step.
%   ChessImage is a One-by-ThirtyFive cell array and stores Image handles.
%
%   Author: KevinK
%   Date: 2019/05/25 23:17:36
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
global Board; Board = zeros(9, 10);
global ChessImage; ChessImage = cell(1, 35);
figure('Name', 'Chinese Chess Interface', 'NumberTitle', 'off');
Image = imread('icon\board.png'); imshow(Image); hold on;
%% Black Ones
% Black Jiang
[Image, ~, Alpha] = imread('icon\bk.png');
bk = imshow(Image); bk.AlphaData = Alpha;
bk.XData = [71-65+1 72+65-1]; bk.YData = [597-65+1 598+65-1];
%% Black Ju
[Image, ~, Alpha] = imread('icon\br.png');
br1 = imshow(Image); br1.AlphaData = Alpha;
br1.XData = [71-65+1 72+65-1]; br1.YData = [77-65+1 78+65-1];
br2 = imshow(Image); br2.AlphaData = Alpha;
br2.XData = [71-65+1 72+65-1]; br2.YData = [1117-65+1 1118+65-1];
%% Black Ma
[Image, ~, Alpha] = imread('icon\bn.png');
bn1 = imshow(Image); bn1.AlphaData = Alpha;
bn1.XData = [71-65+1 72+65-1]; bn1.YData = [207-65+1 208+65-1];
bn2 = imshow(Image); bn2.AlphaData = Alpha;
bn2.XData = [71-65+1 72+65-1]; bn2.YData = [987-65+1 988+65-1];
%% Black Xiang
[Image, ~, Alpha] = imread('icon\bb.png');
bb1 = imshow(Image); bb1.AlphaData = Alpha;
bb1.XData = [71-65+1 72+65-1]; bb1.YData = [337-65+1 338+65-1];
bb2 = imshow(Image); bb2.AlphaData = Alpha;
bb2.XData = [71-65+1 72+65-1]; bb2.YData = [857-65+1 858+65-1];
%% Black Shi
[Image, ~, Alpha] = imread('icon\ba.png');
ba1 = imshow(Image); ba1.AlphaData = Alpha;
ba1.XData = [71-65+1 72+65-1]; ba1.YData = [467-65+1 468+65-1];
ba2 = imshow(Image); ba2.AlphaData = Alpha;
ba2.XData = [71-65+1 72+65-1]; ba2.YData = [727-65+1 728+65-1];
%% Black Pao
[Image, ~, Alpha] = imread('icon\bc.png');
bc1 = imshow(Image); bc1.AlphaData = Alpha;
bc1.XData = [331-65+1 332+65-1]; bc1.YData = [207-65+1 208+65-1];
bc2 = imshow(Image); bc2.AlphaData = Alpha;
bc2.XData = [331-65+1 332+65-1]; bc2.YData = [987-65+1 988+65-1];
%% Black Zu
[Image, ~, Alpha] = imread('icon\bp.png');
bp1 = imshow(Image); bp1.AlphaData = Alpha;
bp1.XData = [461-65+1 462+65-1]; bp1.YData = [77-65+1 78+65-1];
bp2 = imshow(Image); bp2.AlphaData = Alpha;
bp2.XData = [461-65+1 462+65-1]; bp2.YData = [337-65+1 338+65-1];
bp3 = imshow(Image); bp3.AlphaData = Alpha;
bp3.XData = [461-65+1 462+65-1]; bp3.YData = [597-65+1 598+65-1];
bp4 = imshow(Image); bp4.AlphaData = Alpha;
bp4.XData = [461-65+1 462+65-1]; bp4.YData = [857-65+1 858+65-1];
bp5 = imshow(Image); bp5.AlphaData = Alpha;
bp5.XData = [461-65+1 462+65-1]; bp5.YData = [1117-65+1 1118+65-1];
%% Red Ones
% Red Shuai
[Image, ~, Alpha] = imread('icon\rk.png');
rk = imshow(Image); rk.AlphaData = Alpha;
rk.XData = [1249-65+1 1250+65-1]; rk.YData = [597-65+1 598+65-1];
%% Red Ju
[Image, ~, Alpha] = imread('icon\rr.png');
rr1 = imshow(Image); rr1.AlphaData = Alpha;
rr1.XData = [1249-65+1 1250+65-1]; rr1.YData = [77-65+1 78+65-1];
rr2 = imshow(Image); rr2.AlphaData = Alpha;
rr2.XData = [1249-65+1 1250+65-1]; rr2.YData = [1117-65+1 1118+65-1];
%% Red Ma
[Image, ~, Alpha] = imread('icon\rn.png');
rn1 = imshow(Image); rn1.AlphaData = Alpha;
rn1.XData = [1249-65+1 1250+65-1]; rn1.YData = [207-65+1 208+65-1];
rn2 = imshow(Image); rn2.AlphaData = Alpha;
rn2.XData = [1249-65+1 1250+65-1]; rn2.YData = [987-65+1 988+65-1];
%% Red Xiang
[Image, ~, Alpha] = imread('icon\rb.png');
rb1 = imshow(Image); rb1.AlphaData = Alpha;
rb1.XData = [1249-65+1 1250+65-1]; rb1.YData = [337-65+1 338+65-1];
rb2 = imshow(Image); rb2.AlphaData = Alpha;
rb2.XData = [1249-65+1 1250+65-1]; rb2.YData = [857-65+1 858+65-1];
%% Red Shi
[Image, ~, Alpha] = imread('icon\ra.png');
ra1 = imshow(Image); ra1.AlphaData = Alpha;
ra1.XData = [1249-65+1 1250+65-1]; ra1.YData = [467-65+1 468+65-1];
ra2 = imshow(Image); ra2.AlphaData = Alpha;
ra2.XData = [1249-65+1 1250+65-1]; ra2.YData = [727-65+1 728+65-1];
%% Red Pao
[Image, ~, Alpha] = imread('icon\rc.png');
rc1 = imshow(Image); rc1.AlphaData = Alpha;
rc1.XData = [989-65+1 990+65-1]; rc1.YData = [207-65+1 208+65-1];
rc2 = imshow(Image); rc2.AlphaData = Alpha;
rc2.XData = [989-65+1 990+65-1]; rc2.YData = [987-65+1 988+65-1];
%% Red Bing
[Image, ~, Alpha] = imread('icon\rp.png');
rp1 = imshow(Image); rp1.AlphaData = Alpha;
rp1.XData = [859-65+1 860+65-1]; rp1.YData = [77-65+1 78+65-1];
rp2 = imshow(Image); rp2.AlphaData = Alpha;
rp2.XData = [859-65+1 860+65-1]; rp2.YData = [337-65+1 338+65-1];
rp3 = imshow(Image); rp3.AlphaData = Alpha;
rp3.XData = [859-65+1 860+65-1]; rp3.YData = [597-65+1 598+65-1];
rp4 = imshow(Image); rp4.AlphaData = Alpha;
rp4.XData = [859-65+1 860+65-1]; rp4.YData = [857-65+1 858+65-1];
rp5 = imshow(Image); rp5.AlphaData = Alpha;
rp5.XData = [859-65+1 860+65-1]; rp5.YData = [1117-65+1 1118+65-1];
%% Green Mark
[Image, ~, Alpha] = imread('icon\mark.png');
mark1 = imshow(Image); mark1.AlphaData = Alpha; mark1.Visible = 'off';
mark2 = imshow(Image); mark2.AlphaData = Alpha; mark2.Visible = 'off';
%% Green Highlight
[Image, ~, Alpha] = imread('icon\highlight.png');
highlight = imshow(Image); highlight.AlphaData = Alpha; highlight.Visible = 'off';
%% Save Chess Image
Board(:, :) = [
2 0 0 7 0 0 14  0 0  9;
3 0 4 0 0 0  0 11 0 10;
6 0 0 7 0 0 14  0 0 13;
5 0 0 0 0 0  0  0 0 12;
1 0 0 7 0 0 14  0 0  8;
5 0 0 0 0 0  0  0 0 12;
6 0 0 7 0 0 14  0 0 13;
3 0 4 0 0 0  0 11 0 10;
2 0 0 7 0 0 14  0 0  9;];
ChessImage{1, 1} = bk; ChessImage{1, 2} = br1; ChessImage{1, 3} = br2;
ChessImage{1, 4} = bn1; ChessImage{1, 5} = bn2; ChessImage{1, 6} = bb1;
ChessImage{1, 7} = bb2; ChessImage{1, 8} = ba1; ChessImage{1, 9} = ba2;
ChessImage{1, 10} = bc1; ChessImage{1, 11} = bc2; ChessImage{1, 12} = bp1;
ChessImage{1, 13} = bp2; ChessImage{1, 14} = bp3; ChessImage{1, 15} = bp4;
ChessImage{1, 16} = bp5; ChessImage{1, 17} = rk; ChessImage{1, 18} = rr1;
ChessImage{1, 19} = rr2; ChessImage{1, 20} = rn1; ChessImage{1, 21} = rn2;
ChessImage{1, 22} = rb1; ChessImage{1, 23} = rb2; ChessImage{1, 24} = ra1;
ChessImage{1, 25} = ra2; ChessImage{1, 26} = rc1; ChessImage{1, 27} = rc2;
ChessImage{1, 28} = rp1; ChessImage{1, 29} = rp2; ChessImage{1, 30} = rp3;
ChessImage{1, 31} = rp4; ChessImage{1, 32} = rp5; ChessImage{1, 33} = mark1;
ChessImage{1, 34} = mark2; ChessImage{1, 35} = highlight;

end
