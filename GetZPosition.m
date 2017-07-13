function [Ground,GroundCrit,ZPosGround] = GetZPosition(SenVert,MountAngle,GroundPresep,ZPosT)

% clear all
% close all

% SenVert = 30;
% SenHoriz = 90;
% MountAngle = 5; %+ve clockwise
Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);
% Gamma = Gamma*(pi/180);
% Gamma = 0.1*(pi/180);

% BLength = 1;
% BHeight = 0.4;

% GroundPresep = 2;
% 
% ObjHeightPersep = 0.3;
% 
% ObjHeightPersep2 = 0.1;
% 
% ObjDistancePersep = 1.3;
% 
% ClrObjHeight = 1.7;


% ZPos = linspace(0.1,2.4,47); %increment 50mm
% ZPos = linspace(0.1,2.4,24); %increment 100mm
% ZPos = linspace(0.1,2.4,231); %increment 10mm
% ZPos = linspace(0.1,2.4,461); %increment 5mm
% ZPosT = transpose(ZPos);

Ground = ZPosT/tan(Beta);
GroundCrit = NaN([size(Ground,1),1]);
ZPosGround = NaN([size(ZPosT,1),1]);

cGnd = 1;
for a = 1:size(Ground,1)
    if Ground(a,1) < GroundPresep
        GroundCrit(cGnd,1) = Ground(a,1);
        ZPosGround(cGnd,1) = ZPosT(a,1);
        cGnd = cGnd+1;
    end
end