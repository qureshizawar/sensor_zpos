clear

SenVert = 30;
MountAngle = 0; %+ve clockwise
Gamma = 0.1;

Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);

% DistanceHi = linspace(0.1,200,3999); %increment 50mm
% DistanceHi = linspace(0.1,20,399); %increment 50mm
DistanceHi = linspace(0,20,2001); %increment 10mm
DistanceHiT = transpose(DistanceHi);

% ZPos = linspace(0.1,2.4,461); %increment 5mm
ZPos = linspace(0.1,2.4,231); %increment 10mm
ZPosT = transpose(ZPos);

% ObjDistance = linspace(0.1,2,461);
ObjHeightPersep = 0.3;

% ZPos = 0.5;
% ix = zeros(399,461);
tic
for s = 1:size(ZPos,2)
    y1(:,s) = -tan(Beta)*DistanceHiT + ZPos(s);
    y2(:,s) = tan(Alpha)*DistanceHiT + ZPos(s);
    g(:,s) = 0*DistanceHiT; 
    obj = linspace(0,ObjHeightPersep,50);

    xv = [0 max(DistanceHiT) max(DistanceHiT) 0]';
    yv = [ZPos(s) min(y1(:,s)) max(y2(:,s)) ZPos(s)]';

    for i = 1:size(DistanceHiT,1)
        xq = DistanceHiT(i)*ones(size(obj));
        yq = obj;
        [in,on] = inpolygon(xq,yq,xv,yv);
        inObj = yq(in);
    
        if norm(inObj) > 0
            Obj(i) = inObj(1);
            ZPosObjf(i) = ZPos(s);
            dist(i) = DistanceHiT(i);
            break
        else
            Obj(i) = NaN;
            ZPosObjf(i) = NaN;
            dist(i) = NaN;
        end
        
    end
    
    DistObj(s) = dist(end);
    ZPosObj(s) = ZPosObjf(end);
    
% %     xq = DistanceHiT;
%     xq = ObjDistance(s)*ones(size(obj));
% %     yq = g(:,s);
%     yq = obj;
% 
%     [in,on] = inpolygon(xq,yq,xv,yv);
% 
% %     inGnd = xq(in);
% %     Gnd(s) = inGnd(1);
% 
%     inObj = yq(in);
%     
%     if norm(inObj) > 0
%     	Obj(s) = inObj(1);
%         ZPosObj(s) = ZPos(s);
%         dist(s) = DistanceHiT(s);
%     else
%         Obj(s) = NaN;
%         ZPosObj(s) = NaN;
%         dist(s) = NaN;
%     end
%     Obj(s) = inObj(1);
end
toc

% d = size(DistanceHiT,1);
% z = size(ZPos,2);
% 
% i(d,z) = intersect(round(y1,2),round(g,3));
% i = intersect(round(y1,3),round(g,3))

% plot(DistanceHiT,y1,DistanceHiT,y2,DistanceHiT,g)
% plot(Obj,ZPos)
plot(DistObj,ZPosObj)
% hold on
% % h = refline([0 -ZPos - min(ZPos)]); 
% 
% intersect(y1,g)