function Dobot(varargin)
%DOBOT Move chess using Dobot.
%   Author: KevinK
%   Date: 2019/06/16 14:54:31
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Dobot
if nargin == 1
    %% Initialization
    if varargin{1} == 1
        DobotLeft(true);
    elseif varargin{1} == 2
        DobotRight(true);
    end
else
    %% Move chess
    x0 = varargin{1};
    y0 = varargin{2};
    x = varargin{3};
    y = varargin{4};
    iseaten = varargin{5};
    if x0 <= 5 && x >=6
        DobotLeft(x0, y0, 0, 0, true);
        if iseaten
            DobotRight(x, y, -1, -1, false);
        end
        DobotRight(0, 0, x, y, true);
    elseif x0 >= 6 && x <=5
        DobotRight(x0, y0, 0, 0, true);
        if iseaten
            DobotLeft(x, y, -1, -1, false);
        end
        DobotLeft(0, 0, x, y, true);
    elseif x0 <= 5 && x <= 5
        if iseaten
            DobotLeft(x, y, -1, -1, false);
        end
        DobotLeft(x0, y0, x, y, true);
    elseif x0 >= 6 && x >= 6
        if iseaten
            DobotRight(x, y, -1, -1, false);
        end
        DobotRight(x0, y0, x, y, true);
    end
end

end


function DobotLeft(varargin)
%DOBOTLEFT Move chess using left Dobot.
%   Author: KevinK
%   Date: 2019/06/16 15:26:42
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
load('coordinates.mat');
calllib('DobotDll', 'ConnectDobot', 'COM3', 115200);
calllib('DobotDll', 'SetQueuedCmdStartExec');
%% Judge
if nargin == 5
    x0 = varargin{1};
    y0 = varargin{2};
    x = varargin{3};
    y = varargin{4};
    isover = varargin{5};
    %% Dobot Left
    calllib('DobotDll', 'SetEndEffectorSuctionCup', 1, 1, 1, libpointer('uint64Ptr', 0));
    if x0 == 0 && y0 == 0
        ptp.ptpMode = 0; ptp.x = 278.9824; ptp.y = -2.8357; ptp.z = -2.8334; ptp.r = 0.0;
    elseif x0 == -1 && y0 == -1
        ptp.ptpMode = 0; ptp.x = 89.7894; ptp.y = 211.7723; ptp.z = 6.9516; ptp.r = 0.0;
    else
        ptp.ptpMode = 0; ptp.x = coordinates(x0, y0, 1); ptp.y = coordinates(x0, y0, 2); ptp.z = coordinates(x0, y0, 3); ptp.r = 0.0;
    end
    calllib('DobotDll', 'SetPTPCmd', libpointer('tagPTPCmdPtr', libstruct('tagPTPCmd', ptp)), 1, libpointer('uint64Ptr', 1)); pause(4);
    if x == 0 && y == 0
        ptp.ptpMode = 0; ptp.x = 278.9824; ptp.y = -2.8357; ptp.z = -2.8334; ptp.r = 0.0;
    elseif x == -1 && y == -1
        ptp.ptpMode = 0; ptp.x = 89.7894; ptp.y = 211.7723; ptp.z = 6.9516; ptp.r = 0.0;
    else
        ptp.ptpMode = 0; ptp.x = coordinates(x, y, 1); ptp.y = coordinates(x, y, 2); ptp.z = coordinates(x, y, 3); ptp.r = 0.0;
    end
    calllib('DobotDll', 'SetPTPCmd', libpointer('tagPTPCmdPtr', libstruct('tagPTPCmd', ptp)), 1, libpointer('uint64Ptr', 2)); pause(4);
    calllib('DobotDll', 'SetEndEffectorSuctionCup', 1, 0, 1, libpointer('uint64Ptr', 3));
else
    isover = varargin{1};
end
if isover
    ptp.ptpMode = 0; ptp.x = 89.7894; ptp.y = 211.7723; ptp.z = 6.9516; ptp.r = 0.0;
    calllib('DobotDll', 'SetPTPCmd', libpointer('tagPTPCmdPtr', libstruct('tagPTPCmd', ptp)), 1, libpointer('uint64Ptr', 4));
end
pause(2);
calllib('DobotDll', 'SetQueuedCmdStopExec');
%% Disconnect Dobot
calllib('DobotDll', 'DisconnectDobot');

end


function DobotRight(varargin)
%DOBOTRIGHT Move chess using right Dobot.
%   Author: KevinK
%   Date: 2019/06/16 15:26:55
%   Copyright 2019 Liangwei KE, Yue WANG, Jiachang REN.

%% Initialization
load('coordinates.mat');
calllib('DobotDll', 'ConnectDobot', 'COM5', 115200);
calllib('DobotDll', 'SetQueuedCmdStartExec');
%% Judge
if nargin == 5
    x0 = varargin{1};
    y0 = varargin{2};
    x = varargin{3};
    y = varargin{4};
    isover = varargin{5};
    %% Dobot Right
    calllib('DobotDll', 'SetEndEffectorSuctionCup', 1, 1, 1, libpointer('uint64Ptr', 0));
    if x0 == 0 && y0 == 0
        ptp.ptpMode = 0; ptp.x = 284.6596; ptp.y = 0.1315; ptp.z = -11.7737; ptp.r = 0.0;
    elseif x0 == -1 && y0 == -1
        ptp.ptpMode = 0; ptp.x = 92.3178; ptp.y = -223.7515; ptp.z = 2.9454; ptp.r = 0.0;
    else
        ptp.ptpMode = 0; ptp.x = coordinates(x0, y0, 1); ptp.y = coordinates(x0, y0, 2); ptp.z = coordinates(x0, y0, 3); ptp.r = 0.0;
    end
    calllib('DobotDll', 'SetPTPCmd', libpointer('tagPTPCmdPtr', libstruct('tagPTPCmd', ptp)), 1, libpointer('uint64Ptr', 1)); pause(4);
    if x == 0 && y == 0
        ptp.ptpMode = 0; ptp.x = 284.6596; ptp.y = 0.1315; ptp.z = -11.7737; ptp.r = 0.0;
    elseif x == -1 && y == -1
        ptp.ptpMode = 0; ptp.x = 92.3178; ptp.y = -223.7515; ptp.z = 2.9454; ptp.r = 0.0;
    else
        ptp.ptpMode = 0; ptp.x = coordinates(x, y, 1); ptp.y = coordinates(x, y, 2); ptp.z = coordinates(x, y, 3); ptp.r = 0.0;
    end
    calllib('DobotDll', 'SetPTPCmd', libpointer('tagPTPCmdPtr', libstruct('tagPTPCmd', ptp)), 1, libpointer('uint64Ptr', 2)); pause(4);
    calllib('DobotDll', 'SetEndEffectorSuctionCup', 1, 0, 1, libpointer('uint64Ptr', 3));
else
    isover = varargin{1};
end
if isover
    ptp.ptpMode = 0; ptp.x = 92.3178; ptp.y = -223.7515; ptp.z = 2.9454; ptp.r = 0.0;
    calllib('DobotDll', 'SetPTPCmd', libpointer('tagPTPCmdPtr', libstruct('tagPTPCmd', ptp)), 1, libpointer('uint64Ptr', 4));
end
pause(2);
calllib('DobotDll', 'SetQueuedCmdStopExec');
%% Disconnect Dobot
calllib('DobotDll', 'DisconnectDobot');

end
