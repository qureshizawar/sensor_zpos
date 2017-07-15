function [swT,Clri] = GetZPositionClearance(SenVert,MountAngle,Gamma,DistanceHi,ClrObjHeight)

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