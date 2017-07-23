clear all
close all

SenVert = 30;
SenHoriz = 90;
MountAngle = 0; %+ve clockwise
MountAngleVar = linspace(-14,14,200);
Gamma = 0.1;

Alpha = ((SenVert/2) + MountAngle)*(pi/180);
AlphaVar = ((SenVert/2) + MountAngleVar)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);
Gamma = Gamma*(pi/180);

BLength = 1;
BHeight = 0.4;
WAngle = 45*(pi/180);

GroundPresep = 4;
ObjHeightPersep = 0.3;
ObjHeightPersep2 = 0.1;
ObjDistancePersep = 1.3;
ClrObjHeight = 1.7;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ZPos = linspace(0.1,2.4,461); %increment 5mm
ZPosTVar = [0.1 0.2 0.3 0.8 0.9 1]';
ZPosT = transpose(ZPos);

Height = linspace(0.1,3,291);
HeightT = transpose(Height);

DistanceHi = linspace(0.1,200,3999); %increment 50mm
DistanceHiT = transpose(DistanceHi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sw = ClrObjHeight - DistanceHi*tan(Alpha-Gamma);
dmin = (ClrObjHeight - ZPosT)/tan(Alpha-Gamma);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:size(ZPosTVar,1)
    dminVar(:,k) = (ClrObjHeight - ZPosTVar(k))./tan(AlphaVar-Gamma);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% d = 3;
% sw = round(sw, d); %// or y = round(x, d, 'decimals')
sw(sw < 0.1) = NaN;
sw(sw > 2.4) = NaN;
swT = transpose(sw);

% swTA = swT;
% swTA(isnan(DistanceHiT)) = 0;
Clri = zeros(2);
% if norm(swTA) > 0
    clrz(1) = min(swT);
    clrz(2) = max(swT);
    clrd(1) = (ClrObjHeight - min(swT))/tan(Alpha-Gamma);
    clrd(2) = (ClrObjHeight - max(swT))/tan(Alpha-Gamma);

    Clri = [clrd(1) clrz(1); clrd(2) clrz(2)];
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
plot(dminVar,MountAngleVar)

grid ('on')
grid ('minor')
title(['Sensor height vs suspended object ' num2str(ClrObjHeight) 'm high'])
xlabel('Min Distance to perceive (m)')
ylabel('MountAngle (Deg)')
for t = 1:size(ZPosTVar,1)
labels{t} = ['ZPos ' num2str(ZPosTVar(t)) ' m'];
end
legend(labels)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DistanceHiT(isnan(swT)) = NaN;

figure
Clrh(1) = plot(DistanceHiT,swT,'LineWidth',2');
xlim([0 max(DistanceHiT)])
ylim([0 max(swT)])

% swTA = swT;
% swTA(isnan(swT)) = 0;
% if norm(swTA) > 0
%     hold on
%     h = area(DistanceHiT,swT,max(swT));
%     h(1).FaceColor = [0 0.9 0];
%     alpha(.5)
% end
grid ('on')
grid ('minor')
title(['Sensor height vs suspended object ' num2str(ClrObjHeight) 'm high'])
xlabel('Min Distance to perceive (m)')
ylabel('Sensor height (Z-position (m))')

Clrh(2) = patch([max(DistanceHiT),Clri(1,1),Clri(2,1), max(DistanceHiT)],[Clri(1,2),Clri(1,2),Clri(2,2), Clri(2,2)],'g');
alpha(Clrh(2),.5)

uistack(Clrh(1),'top')