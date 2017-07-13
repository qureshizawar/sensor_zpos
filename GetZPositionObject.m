function [objpersep,ObjCrit,ZPosObj,objpersepProbable,ZPosProbable] = GetZPositionObject(SenVert,MountAngle,Gamma,ZPosT,HeightT,Ground,ZPosGround,ObjHeightPersep,ObjDistancePersep)

Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);
Gamma = Gamma*(pi/180);

% Height = linspace(0.1,3,291);
% HeightT = transpose(Height);

objAbs = zeros(size(Ground,1),size(HeightT,1));
objNegative = zeros(size(Ground,1),size(HeightT,1));
objPositive = zeros(size(Ground,1),size(HeightT,1));

for n = 1:size(HeightT,1)
    
    objAbs(:,n) = Ground - HeightT(n,1)/tan(Beta);

    objNegative(:,n) = Ground - HeightT(n,1)/tan(Beta-Gamma);

    objPositive(:,n) = Ground - HeightT(n,1)/tan(Beta+Gamma);
    
    objAbs(objAbs < 0) = NaN;
    objNegative(objNegative < 0) = NaN;
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