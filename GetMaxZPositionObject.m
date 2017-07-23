function [MaxOutZPosObj] = GetMaxZPositionObject(BetaVar,Gamma,ZPosT,HeightT,GroundPresep,ObjHeightPersep,ObjDistancePersep,BLength,BHeight,WAngle)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Gamma = Gamma*(pi/180);
WAngle = WAngle*(pi/180);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% objAbs = zeros(size(Ground,1),size(HeightT,1));
% MaxobjPositive = zeros(size(Ground,1),size(HeightT,1));

for s = 1:size(BetaVar,2)

    [Ground,GroundCrit,ZPosGround] = GetMaxZPosition(BetaVar(s),GroundPresep,ZPosT,BHeight,BLength,WAngle);
    
    MaxobjPositive = zeros(size(Ground,1),size(HeightT,1));
    
    for n = 1:size(HeightT,1) 
    %     objAbs(:,n) = Ground - HeightT(n,1)/tan(BetaVar(s));
        MaxobjPositive(:,n) = Ground - HeightT(n,1)/tan(BetaVar(s)+Gamma);

    %     objAbs(objAbs < 0) = NaN;
        MaxobjPositive(MaxobjPositive < 0) = NaN;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    MaxkGnd = find(HeightT>=ObjHeightPersep, 1, 'first');
    Maxobjpersep = MaxobjPositive(:,MaxkGnd);
    MaxObjCrit = NaN([size(Maxobjpersep,1),1]);
    MaxZPosObj = NaN([size(ZPosT,1),1]);
    cObj = 1;

    for a = 1:size(Maxobjpersep,1)
        if Maxobjpersep(a,1) < ObjDistancePersep
            MaxObjCrit(cObj,1) = Maxobjpersep(a,1);
            MaxZPosObj(cObj,1) = ZPosT(a,1);
            if MaxZPosObj(cObj,1) > BHeight
                MaxWx = (MaxZPosObj(cObj,1) - BHeight)/tan(WAngle);
                if MaxZPosObj(cObj,1) < BHeight + (BLength + MaxWx)*tan(BetaVar(s))
                    MaxObjCrit(cObj,1) = NaN;
                    MaxZPosObj(cObj,1) = NaN;
                end
            end
            cObj = cObj+1;
        end

    end

    MaxOutObjCrit(s,1) = max(MaxObjCrit);
    MaxOutZPosObj(s,1) = max(MaxZPosObj);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
