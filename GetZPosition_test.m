clear all
close all

SenVert = 30;
SenHoriz = 90;
MountAngle = 10; %+ve clockwise
Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180); %FOV looking down
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


% ZPos = linspace(0.1,2.4,47); %increment 50mm
% ZPos = linspace(0.1,2.4,24); %increment 100mm
% ZPos = linspace(0.1,2.4,231); %increment 10mm
ZPos = linspace(0.1,2.4,461); %increment 5mm
ZPosT = transpose(ZPos);

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

figure
h = plot(Ground,ZPosT,'r--',GroundCrit,ZPosGround,'g','LineWidth',2');
xlim([0 Ground(end)])
ylim([0 ZPosT(end)])

patch([0,gH(1,1),gH(2,1), 0],[gH(1,2),gH(1,2),gH(2,2), gH(2,2)],'g')
patch([0,gL(1,1),gL(2,1), 0],[gL(1,2),gL(1,2),gL(2,2), gL(2,2)],'g')
alpha(.5)

uistack(h(2),'top')

grid ('on')
grid ('minor')
title('Sensor height vs Distance to perceive Gnd')
xlabel('Distance to perceive (m)')
ylabel('Sensor height (Z-position (m))')
% legend('All','Target criteria (2 m)','Location','northwest')
legend('All',['Target criteria ' num2str(GroundPresep) 'm'],'Location','northwest')