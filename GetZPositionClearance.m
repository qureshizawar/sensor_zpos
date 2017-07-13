function [swT] = GetZPositionClearance(SenVert,MountAngle,Gamma,DistanceHi,ClrObjHeight)

Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);
Gamma = Gamma*(pi/180);

sw = ClrObjHeight - DistanceHi*tan(Alpha-Gamma);
% dmin = (ZPosT - ClrObjHeight)/tan(Alpha);
% d = 3;
% sw = round(sw, d); %// or y = round(x, d, 'decimals')
sw(sw < 0.1) = NaN;
sw(sw > 2.4) = NaN;
swT = transpose(sw);