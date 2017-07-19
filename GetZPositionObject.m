function [objpersep,ObjCrit,ZPosObj,objpersepProbable,ZPosProbable,oH,oL] = GetZPositionObject(SenVert,MountAngle,Gamma,ZPosT,HeightT,Ground,ZPosGround,ObjHeightPersep,ObjDistancePersep,BLength,BHeight,WAngle)

Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);
Gamma = Gamma*(pi/180);
WAngle = WAngle*(pi/180);

% Height = linspace(0.1,3,291);
% HeightT = transpose(Height);

% % objAbs = zeros(size(Ground,1),size(HeightT,1));
% % objNegative = zeros(size(Ground,1),size(HeightT,1));
% % objPositive = zeros(size(Ground,1),size(HeightT,1));
% % 
% % for n = 1:size(HeightT,1)
% %     
% %     objAbs(:,n) = Ground - HeightT(n,1)/tan(Beta);
% % 
% %     objNegative(:,n) = Ground - HeightT(n,1)/tan(Beta-Gamma);
% % 
% %     objPositive(:,n) = Ground - HeightT(n,1)/tan(Beta+Gamma);
% %     
% %     objAbs(objAbs < 0) = NaN;
% %     objNegative(objNegative < 0) = NaN;
% %     objPositive(objPositive < 0) = NaN;
% % end
% % 
% % 
% % % objdiff = objPositive - objAbs;
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % kGnd = find(HeightT>=ObjHeightPersep, 1, 'first');
% % objpersep = objPositive(:,kGnd);
% % ObjCrit = NaN([size(objpersep,1),1]);
% % ZPosObj = NaN([size(ZPosT,1),1]);
% % cObj = 1;
% % 
% % for a = 1:size(objpersep,1)
% %     if objpersep(a,1) < ObjDistancePersep
% %         ObjCrit(cObj,1) = objpersep(a,1);
% %         ZPosObj(cObj,1) = ZPosT(a,1);
% %         cObj = cObj+1;
% %     end
% % end
% % 
% % 
% % ZPosProbable = intersect(ZPosGround,ZPosObj);
% % if size(ZPosProbable,1) == 0
% %     ZPosProbable = 0;
% %     objpersepProbable = 0;
% % else
% %     objpersepProbable = objpersep(find(ZPosT==ZPosProbable(1)):find(ZPosT==ZPosProbable(end)));
% % end


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