clear all
close all

SenVert = 30;
SenHoriz = 90;
MountAngle = -5; %+ve clockwise
Gamma = 0.1;

BLength = 1;
BHeight = 0.4;
WAngle = 45;

GroundPresep = 4;
ObjHeightPersep = 0.3;
ObjHeightPersep2 = 0.1;
ObjDistancePersep = 1.3;
ClrObjHeight = 6;

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
legend('All',['Target criteria ' num2str(GroundPresep) 'm'],'Location','northwest')

[objpersep,ObjCrit,ZPosObj,objpersepProbable,ZPosProbable,oH,oL] = GetZPositionObject(SenVert,MountAngle,Gamma,ZPosT,HeightT,Ground,ZPosGround,ObjHeightPersep,ObjDistancePersep,BLength,BHeight,WAngle);

figure
ax1 = subplot(1,2,1); % bottom subplot
ax2 = subplot(1,2,2); % top subplot

% figure
Objh(1:2) = plot(ax1,objpersep,ZPosT,'r--',ObjCrit,ZPosObj,'g','LineWidth',2');
xlim(ax1,[0 objpersep(end)])
ylim(ax1,[0 ZPosT(end)])

grid (ax1,'on')
grid (ax1,'minor')
title(ax1,'Sensor height vs Distance to perceive Obj')
xlabel(ax1,'Distance to perceive (m)')
ylabel(ax1,'Max sensor height (Z-position (m))')
legend(ax1,'All',['Target criteria ' num2str(ObjHeightPersep) 'm' ' @' num2str(ObjDistancePersep) 'm'],'Location','northwest')

Objh(3) = patch([0,oH(1,1),oH(2,1), 0],[oH(1,2),oH(1,2),oH(2,2), oH(2,2)],'g','Parent',ax1);
Objh(4) = patch([0,oL(1,1),oL(2,1), 0],[oL(1,2),oL(1,2),oL(2,2), oL(2,2)],'g','Parent',ax1);

alpha(Objh(3),.5)
alpha(Objh(4),.5)

uistack(Objh(3),'bottom')
uistack(Objh(4),'bottom')
uistack(Objh(1),'top')
uistack(Objh(2),'top')

% % figure
% plot(ax2,objpersep,ZPosT,'r--',objpersepProbable,ZPosProbable,'g','LineWidth',2')
% xlim(ax2,[0 objpersep(end)])
% ylim(ax2,[0 ZPosT(end)])
% 
% ZPosProbableA = ZPosProbable;
% ZPosProbableA(isnan(ZPosProbable)) = 0;
% if norm(ZPosProbableA) > 0
%     hold (ax2,'on')
%     h = area(ax2,objpersepProbable,ZPosProbable, max(ZPosProbable));
%     h(1).FaceColor = [0 0.9 0];
%     alpha(.5)
% end
% grid (ax2,'on')
% grid (ax2,'minor')
% title(ax2,'Sensor height vs Distance to perceive Gnd & Obj')
% xlabel(ax2,'Distance to perceive (m)')
% ylabel(ax2,'Max sensor height (Z-position (m))')
% legend(ax2,'All','Target criteria','Location','northwest')

% [objpersep2,ObjCrit2,ZPosObj2,objpersepProbable2,ZPosProbable2] = GetZPositionObject(SenVert,MountAngle,Gamma,ZPosT,HeightT,Ground,ZPosGround,ObjHeightPersep2,ObjDistancePersep);
% 
% figure
% ax4 = subplot(1,2,1); % bottom subplot
% ax5 = subplot(1,2,2); % top subplot
% 
% % figure
% plot(ax4,objpersep2,ZPosT,'r--',ObjCrit2,ZPosObj2,'g','LineWidth',2')
% xlim(ax4,[0 objpersep2(end)])
% ylim(ax4,[0 ZPosT(end)])
% 
% ZPosObj2A = ZPosObj2;
% ZPosObj2A(isnan(ZPosObj2)) = 0;
% if norm(ZPosObj2A) > 0
%     hold (ax4,'on')
%     h = area(ax4,ObjCrit2,ZPosObj2,max(ZPosObj2));
%     h(1).FaceColor = [0 0.9 0];
%     alpha(.5)
% end
% grid (ax4,'on')
% grid (ax4,'minor')
% title(ax4,'Sensor height vs Distance to perceive Obj')
% xlabel(ax4,'Distance to perceive (m)')
% ylabel(ax4,'Max sensor height (Z-position (m))')
% legend(ax4,'All','Target criteria (10cm @ 1.3m)','Location','northwest')
% 
% % figure
% plot(ax5,objpersep2,ZPosT,'r--',objpersepProbable2,ZPosProbable2,'g','LineWidth',2')
% xlim(ax5,[0 objpersep2(end)])
% ylim(ax5,[0 ZPosT(end)])
% 
% ZPosProbable2A = ZPosProbable2;
% ZPosProbable2A(isnan(ZPosProbable2)) = 0;
% if norm(ZPosProbable2A) > 0 
%     hold (ax5,'on')
%     h = area(ax5,objpersepProbable2,ZPosProbable2,max(ZPosProbable2));
%     h(1).FaceColor = [0 0.9 0];
%     alpha(.5)
% end
% grid (ax5,'on')
% grid (ax5,'minor')
% title(ax5,'Sensor height vs Distance to perceive Gnd & Obj')
% xlabel(ax5,'Distance to perceive (m)')
% ylabel(ax5,'Max sensor height (Z-position (m))')
% legend(ax5,'All','Target criteria','Location','northwest')

[swT,Clri] = GetZPositionClearance(SenVert,MountAngle,Gamma,DistanceHi,ClrObjHeight);

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