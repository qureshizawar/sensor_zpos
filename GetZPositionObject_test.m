clear all
close all

SenVert = 30;
SenHoriz = 90;
MountAngle = 0; %+ve clockwise
Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180); %FOV looking down
Gamma = 0.1*(pi/180);

BLength = 1;
BHeight = 0.4;
WAngle = 45*(pi/180);

GroundPresep = 2;
<<<<<<< HEAD
ObjHeightPersep = 0.3;
ObjHeightPersep2 = 0.1;
ObjDistancePersep = 2;
=======
ObjHeightPersep = 0.1;
ObjHeightPersep2 = 0.1;
ObjDistancePersep = 1.5;
>>>>>>> 1b28b0df53585226eb8c1262a116dcb309af0f2b
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

% for a = 1:size(objpersep,1)
%     if objpersep(a,1) < ObjDistancePersep
%         ObjCrit(cObj,1) = objpersep(a,1);
%         ZPosObj(cObj,1) = ZPosT(a,1);
%         cObj = cObj+1;
%     end
% end

for a = 1:size(objpersep,1)
    if objpersep(a,1) < ObjDistancePersep
        ObjCrit(cObj,1) = objpersep(a,1);
        ZPosObj(cObj,1) = ZPosT(a,1);
        if ZPosObj(cObj,1) > BHeight
            Wx = (ZPosObj(cObj,1) - BHeight)/tan(WAngle);
            if ZPosObj(cObj,1) < BHeight + (BLength + Wx)*tan(Beta)
                ObjCrit(cObj,1) = NaN;
                ZPosObj(cObj,1) = NaN;
            end
        end
        
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

ZPosObjA = ZPosObj;
ZPosObjA(isnan(ZPosObj)) = 0;
% oH = zeros(2,4);
oH = zeros(2,2);
% oL = zeros(2,4);
oL = zeros(2,2);
if norm(ZPosObjA) > 0
    if max(ZPosObj) > BHeight
        gzH(1) = ZPosObj(find(ZPosObj >= BHeight + (BLength)*tan(Beta), 1, 'first'));
        gzH(2) = ZPosObj(find(ZPosObj >= BHeight + (BLength + Wx)*tan(Beta), 1, 'last'));
        ggH(1) = ObjCrit(find(ZPosObj >= BHeight + (BLength)*tan(Beta), 1, 'first'));
        ggH(2) = ObjCrit(find(ZPosObj >= BHeight + (BLength + Wx)*tan(Beta), 1, 'last'));
        
%         ZPosProbableA = ZPosProbable;
%         ZPosProbableA(isnan(ZPosProbable)) = 0;
%         if norm(ZPosProbableA) > 0 && max(ZPosObj) >= BHeight + (BLength + Wx)*tan(Beta)
%             gzHp(1) = ZPosProbable(find(ZPosObj >= BHeight + (BLength)*tan(Beta), 1, 'first'));
%             gzHp(2) = ZPosProbable(find(ZPosObj >= BHeight + (BLength + Wx)*tan(Beta), 1, 'last'));
%             ggHp(1) = objpersepProbable(find(ZPosObj >= BHeight + (BLength)*tan(Beta), 1, 'first'));
%             ggHp(2) = objpersepProbable(find(ZPosObj >= BHeight + (BLength + Wx)*tan(Beta), 1, 'last'));
%         else
%             gzHp(1) = 0;
%             gzHp(2) = 0;
%             ggHp(1) = 0;
%             ggHp(2) = 0; 
%         end

%         oH = [ggH(1) gzH(1) ggHp(1) gzHp(1); ggH(2) gzH(2) ggHp(2) gzHp(2)]
        oH = [ggH(1) gzH(1); ggH(2) gzH(2)];

    end

    if min(ZPosObj) <= BHeight
        gzL(1) = ZPosObj(find(ZPosObj <= BHeight, 1, 'first'));
        gzL(2) = ZPosObj(find(ZPosObj <= BHeight, 1, 'last'));
        ggL(1) = ObjCrit(find(ZPosObj <= BHeight, 1, 'first'));
        ggL(2) = ObjCrit(find(ZPosObj <= BHeight, 1, 'last'));

    %     ZPosProbableA = ZPosProbable;
    %     ZPosProbableA(isnan(ZPosProbable)) = 0;
    %     if norm(ZPosProbableA) > 0
    %         gzLp(1) = ZPosProbable(find(ZPosObj <= BHeight, 1, 'first'));
    %         gzLp(2) = ZPosProbable(find(ZPosObj <= BHeight, 1, 'last'));
    %         ggLp(1) = objpersepProbable(find(ZPosObj <= BHeight, 1, 'first'));
    %         ggLp(2) = objpersepProbable(find(ZPosObj <= BHeight, 1, 'last'));
    %     else
    %         gzLp(1) = 0;
    %         gzLp(2) = 0;
    %         ggLp(1) = 0;
    %         ggLp(2) = 0; 
    %     end

        oL = [ggL(1) gzL(1); ggL(2) gzL(2)];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% Objh(1:2) = plot(ax2,objpersep,ZPosT,'r--',objpersepProbable,ZPosProbable,'g','LineWidth',2');
% xlim(ax2,[0 objpersep(end)])
% ylim(ax2,[0 ZPosT(end)])
% 
% grid (ax2,'on')
% grid (ax2,'minor')
% title(ax2,'Sensor height vs Distance to perceive Gnd & Obj')
% xlabel(ax2,'Distance to perceive (m)')
% ylabel(ax2,'Max sensor height (Z-position (m))')
% legend(ax2,'All','Target criteria','Location','northwest')
% 
% Objh(3) = patch([0,oH(1,3),oH(2,3), 0],[oH(1,4),oH(1,4),oH(2,4), oH(2,4)],'g','Parent',ax2);
% Objh(4) = patch([0,oL(1,3),oL(2,3), 0],[oL(1,4),oL(1,4),oL(2,4), oL(2,4)],'g','Parent',ax2);
% 
% alpha(Objh(3),.5)
% alpha(Objh(4),.5)
% 
% uistack(Objh(3),'bottom')
% uistack(Objh(4),'bottom')
% uistack(Objh(1),'top')
% uistack(Objh(2),'top')
