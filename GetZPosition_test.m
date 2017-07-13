clear all
close all

SenVert = 15;
SenHoriz = 90;
MountAngle = -5; %+ve clockwise
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
%         if ZPosGround(cGnd,1) > BHeight && ZPosGround(cGnd,1) < BHeight + (BLength)*tan(Beta)
%             GroundCrit(cGnd,1) = NaN;
%         end
        if ZPosGround(cGnd,1) > BHeight
            gzH(cGnd,1) = ZPosGround(cGnd,1);
            ggH(cGnd,1) = GroundCrit(cGnd,1);
            Wx = (ZPosGround(cGnd,1) - BHeight)/tan(WAngle);
            if ZPosGround(cGnd,1) < BHeight + (BLength + Wx)*tan(Beta)
                GroundCrit(cGnd,1) = NaN;
                ZPosGround(cGnd,1) = NaN;
                ggH(cGnd,1) = GroundCrit(cGnd,1);
                gzH(cGnd,1) = NaN;
            end
        end
        
        if ZPosGround(cGnd,1) < BHeight
            gzL(cGnd,1) = ZPosGround(cGnd,1);
            ggL(cGnd,1) = GroundCrit(cGnd,1);
        end

        cGnd = cGnd+1;
    end
end

figure
h = plot(Ground,ZPosT,'r--',GroundCrit,ZPosGround,'g','LineWidth',2');
xlim([0 Ground(end)])
ylim([0 ZPosT(end)])

% ZPosGroundA = ZPosGround;
% ZPosGroundA(isnan(ZPosGround)) = 0;
ggHi = zeros(1,2);
gzHi = zeros(1,2);
ggLi = zeros(1,2);
gzLi = zeros(1,2);
% if norm(ZPosGroundA) > 0
    if max(ZPosGround) > BHeight
        ggHi(1) = ggH(find(ggH > 0,1, 'first'));
        ggHi(2) = ggH(find(ggH > 0,1, 'last'));

        gzHi(1) = gzH(find(gzH > 0,1, 'first'));
        gzHi(2) = gzH(find(gzH > 0,1, 'last'));
    end

    ggLi(1) = ggL(find(ggL > 0,1, 'first'));
    ggLi(2) = ggL(find(ggL > 0,1, 'last'));

    gzLi(1) = gzL(find(gzL > 0,1, 'first'));
    gzLi(2) = gzL(find(gzL > 0,1, 'last'));
% end


patch([0,ggHi(1),ggHi(2), 0],[gzHi(1),gzHi(1),gzHi(2), gzHi(2)],'g')
patch([0,ggLi(1),ggLi(2), 0],[gzLi(1),gzLi(1),gzLi(2), gzLi(2)],'g')
alpha(.5)

uistack(h(2),'top')

grid ('on')
grid ('minor')
title('Sensor height vs Distance to perceive Gnd')
xlabel('Distance to perceive (m)')
ylabel('Sensor height (Z-position (m))')
% legend('All','Target criteria (2 m)','Location','northwest')
legend('All',['Target criteria ' num2str(GroundPresep) 'm'],'Location','northwest')