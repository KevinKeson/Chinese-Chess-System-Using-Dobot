function [centers, radii] = findcircles(I)
%FINDCIRCLES Find circles using Circular Hough Transform.
%   Author: KevinK
%   Date: 2019/05/04 02:26:32
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Find Circles
% 'Sensitivity' default is 0.85 in the range [0 1]
% 'ObjectPolarity' and 'EdgeThreshold' are not necessary
[centers, radii] = imfindcircles(I, [20 27], 'Method', 'TwoStage', 'Sensitivity', 0.86);

end
