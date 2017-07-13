clear all
close all

SenVert = 30;
SenHoriz = 90;
MountAngle = -5; %+ve clockwise
Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180); %FOV looking down
Gamma = 0.1*(pi/180);

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
ZPosT = transpose(ZPos);

Height = linspace(0.1,3,291);
HeightT = transpose(Height);

DistanceHi = linspace(0.1,200,3999); %increment 50mm
DistanceHiT = transpose(DistanceHi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Ground,GroundCrit,ZPosGround,gH,gL] = GetZPosition(SenVert,MountAngle,GroundPresep,ZPosT,BHeight,BLength,WAngle);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

objAbs = zeros(size(Ground,1),size(HeightT,1));
% objNegative = zeros(size(Ground,1),size(HeightT,1));
objPositive = zeros(size(Ground,1),size(HeightT,1));

for n = 1:size(HeightT,1)
    
    objAbs(:,n) = Ground - HeightT(n,1)/tan(Beta);

%     objNegative(:,n) = Ground - HeightT(n,1)/tan(Beta-Gamma);

    objPositive(:,n) = Ground - HeightT(n,1)/tan(Beta+Gamma);
    
    objAbs(objAbs < 0) = NaN;
%     objNegative(objNegative < 0) = NaN;
    objPositive(objPositive < 0) = NaN;
end


% objdiff = objPositive - objAbs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kGnd = find(HeightT>=ObjHeightPersep, 1, 'first');
objpersep = objPositive(:,kGnd);
ObjCrit = NaN([size(objpersep,1),1]);
ZPosObj = NaN([size(ZPosT,1),1]);
cObj = 1;

for a = 1:size(objpersep,1)
    if objpersep(a,1) < ObjDistancePersep
        ObjCrit(cObj,1) = objpersep(a,1);
        ZPosObj(cObj,1) = ZPosT(a,1);
        cObj = cObj+1;
    end
end


ZPosProbable = intersect(ZPosGround,ZPosObj);
if size(ZPosProbable,1) == 0
    ZPosProbable = 0;
    objpersepProbable = 0;
else
    objpersepProbable = objpersep(find(ZPosT==ZPosProbable(1)):find(ZPosT==ZPosProbable(end)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
ax1 = subplot(1,2,1); % bottom subplot
ax2 = subplot(1,2,2); % top subplot

% figure
plot(ax1,objpersep,ZPosT,'r--',ObjCrit,ZPosObj,'g','LineWidth',2')
xlim(ax1,[0 objpersep(end)])
ylim(ax1,[0 ZPosT(end)])

ZPosObjA = ZPosObj;
ZPosObjA(isnan(ZPosObj)) = 0;
if norm(ZPosObjA) > 0
    hold (ax1,'on')
    h = area(ax1,ObjCrit,ZPosObj, max(ZPosObj));
    h(1).FaceColor = [0 0.9 0];
    alpha(.5)
end
grid (ax1,'on')
grid (ax1,'minor')
title(ax1,'Sensor height vs Distance to perceive Obj')
xlabel(ax1,'Distance to perceive (m)')
ylabel(ax1,'Max sensor height (Z-position (m))')
legend(ax1,'All','Target criteria (30cm @ 1.3m)','Location','northwest')

% figure
plot(ax2,objpersep,ZPosT,'r--',objpersepProbable,ZPosProbable,'g','LineWidth',2')
xlim(ax2,[0 objpersep(end)])
ylim(ax2,[0 ZPosT(end)])

ZPosProbableA = ZPosProbable;
ZPosProbableA(isnan(ZPosProbable)) = 0;
if norm(ZPosProbableA) > 0
    hold (ax2,'on')
    h = area(ax2,objpersepProbable,ZPosProbable, max(ZPosProbable));
    h(1).FaceColor = [0 0.9 0];
    alpha(.5)
end
grid (ax2,'on')
grid (ax2,'minor')
title(ax2,'Sensor height vs Distance to perceive Gnd & Obj')
xlabel(ax2,'Distance to perceive (m)')
ylabel(ax2,'Max sensor height (Z-position (m))')
legend(ax2,'All','Target criteria','Location','northwest')