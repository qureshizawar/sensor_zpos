function [Ground,GroundCrit,ZPosGround, gH, gL] = GetZPosition(SenVert,MountAngle,GroundPresep,ZPosT,BHeight,BLength,WAngle)

% clear all
% close all

% SenVert = 30;
% SenHoriz = 90;
% MountAngle = 5; %+ve clockwise
Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);
WAngle = WAngle*(pi/180);
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
        if ZPosGround(cGnd,1) > BHeight
            Wx = (ZPosGround(cGnd,1) - BHeight)/tan(WAngle);
            if ZPosGround(cGnd,1) < BHeight + (BLength + Wx)*tan(Beta)
                GroundCrit(cGnd,1) = NaN;
                ZPosGround(cGnd,1) = NaN;
            end
        end
        
        cGnd = cGnd+1;
    end
end

ZPosGroundA = ZPosGround;
ZPosGroundA(isnan(ZPosGround)) = 0;
gH = zeros(2);
gL = zeros(2);
if norm(ZPosGroundA) > 0
    if max(ZPosGround) > BHeight
        gzH(1) = ZPosGround(find(ZPosGround >= BHeight + (BLength)*tan(Beta), 1, 'first'));
        gzH(2) = ZPosGround(find(ZPosGround >= BHeight + (BLength + Wx)*tan(Beta), 1, 'last'));
        ggH(1) = GroundCrit(find(ZPosGround >= BHeight + (BLength)*tan(Beta), 1, 'first'));
        ggH(2) = GroundCrit(find(ZPosGround >= BHeight + (BLength + Wx)*tan(Beta), 1, 'last'));

        gH = [ggH(1) gzH(1); ggH(2) gzH(2)];

    end

    gzL(1) = ZPosGround(find(ZPosGround <= BHeight, 1, 'first'));
    gzL(2) = ZPosGround(find(ZPosGround <= BHeight, 1, 'last'));
    ggL(1) = GroundCrit(find(ZPosGround <= BHeight, 1, 'first'));
    ggL(2) = GroundCrit(find(ZPosGround <= BHeight, 1, 'last'));

    gL = [ggL(1) gzL(1); ggL(2) gzL(2)];
end