% clear all
% close all

SenVert = 30;
SenHoriz = 90;
MountAngle = -5; %+ve clockwise
MountAngleVar = linspace(-10,10,100);
Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180); %FOV looking down
BetaVar = ((SenVert/2) - MountAngleVar)*(pi/180);
Gamma = 0.1*(pi/180);

BLength = 1;
BHeight = 0.4;
WAngle = 45*(pi/180);
% Wy = linspace(BHeight,2.4,(((2.4-BHeight)/0.005))+1); %increment 5mm
% Wx = Wy/tan(WAngle);
% Wx = transpose(Wx);

GroundPresep = 4;

ObjHeightPersep = 0.3;

ObjHeightPersep2 = 0.1;

ObjDistancePersep = 1.3;

ClrObjHeight = 1.7;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ZPos = linspace(0.1,2.4,47); %increment 50mm
% ZPos = linspace(0.1,2.4,24); %increment 100mm
% ZPos = linspace(0.1,2.4,231); %increment 10mm
ZPos = linspace(0.1,2.4,461); %increment 5mm
ZPosT = transpose(ZPos);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for s = 1:size(BetaVar,2)

Ground = ZPosT/tan(BetaVar(s));
GroundCrit = NaN([size(Ground,1),1]);
ZPosGround = NaN([size(ZPosT,1),1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cGnd = 1;
for a = 1:size(Ground,1)
    if Ground(a,1) < GroundPresep
        GroundCrit(cGnd,1) = Ground(a,1);
        ZPosGround(cGnd,1) = ZPosT(a,1);
        if ZPosGround(cGnd,1) > BHeight
            Wx = (ZPosGround(cGnd,1) - BHeight)/tan(WAngle);
            if ZPosGround(cGnd,1) < BHeight + (BLength + Wx)*tan(BetaVar(s))
                GroundCrit(cGnd,1) = NaN;
                ZPosGround(cGnd,1) = NaN;
            end
        end
        
        cGnd = cGnd+1;
    end
end

MaxGroundCrit(s,1) = max(GroundCrit);
MaxZPosGround(s,1) = max(ZPosGround);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(MaxZPosGround,MountAngleVar)

