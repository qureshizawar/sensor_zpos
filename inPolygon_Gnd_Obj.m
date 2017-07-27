clear
close

slopeAngle = 15;
slope = tan(slopeAngle*(pi/180));
% slope = 0.13;
XMax = 2;

b = slope;
a = -b/(2*XMax);

SenVert = 30;
SenVert2 = 15;
MountAngle = -2; %+ve clockwise
% MountAngle2 = -2;
MountAngle2 = -5;

% Orientation = 0;
Orientation = atan(-(1/b))*(180/pi) +90;
Gamma = 0.1;

Alpha = ((SenVert/2) + MountAngle + Orientation)*(pi/180);
Beta = ((SenVert/2) - MountAngle - Orientation)*(pi/180);

Alpha2 = ((SenVert2/2) + MountAngle2 + Orientation)*(pi/180);
Beta2 = ((SenVert2/2) - MountAngle2 - Orientation)*(pi/180);

% DistanceHi = linspace(0.1,200,3999); %increment 50mm
% DistanceHi = linspace(0.1,20,399); %increment 50mm
DistanceHi = linspace(0,5,1911); %increment 10mm
DistanceHiT = transpose(DistanceHi);

% ZPos = linspace(0.1,2.4,461); %increment 5mm
% % ZPos = linspace(0.1,2.4,231); %increment 10mm
% ZPosT = transpose(ZPos);
ZPos = 0.5;

ObjHeightPersep = 0.5;
ObjDistancePersep = 4.75;

SenPersep = 0.7;
SenPersep2 = 0.8;

l = tan((Alpha-Beta)/2)*DistanceHiT + ZPos;
l2 = tan((Alpha2-Beta2)/2)*DistanceHiT + ZPos;
y1 = -tan(Beta)*DistanceHiT + ZPos;
y2 = tan(Alpha)*DistanceHiT + ZPos;

y3 = -tan(Beta2)*DistanceHiT + ZPos;
y4 = tan(Alpha2)*DistanceHiT + ZPos;

g = a*(DistanceHiT.^2) + b*DistanceHiT;
% dg = gradient(g)
dg = 2*a*DistanceHiT +b;

grad = 2*a*ObjDistancePersep +b;

if grad == 0
    yObj = linspace(a*ObjDistancePersep.^2 + b*ObjDistancePersep,ObjHeightPersep,100);
    xo(1:100) = ObjDistancePersep;
elseif grad > 0
    ndg = -(1/grad);
    % dg = diff(g)/0.001;
    % obj = (diff(g))
    c = a*ObjDistancePersep.^2 + b*ObjDistancePersep - ndg*ObjDistancePersep;
    xo = linspace(ObjDistancePersep-ObjHeightPersep*sin(atan(ndg)+(pi/2)),ObjDistancePersep,100);
    yObj = ndg*xo + c;
    
elseif grad < 0
    ndg = -(1/grad);
    % dg = diff(g)/0.001;
    % obj = (diff(g))
    c = a*ObjDistancePersep.^2 + b*ObjDistancePersep - ndg*ObjDistancePersep;
    xo = linspace(ObjDistancePersep,ObjDistancePersep-ObjHeightPersep*sin(atan(ndg)-(pi/2)),100);
    yObj = ndg*xo + c;
end


xv = [0 max(DistanceHiT) max(DistanceHiT) 0]';
yv = [ZPos min(y1) max(y2) ZPos]';

xv2 = [0 max(DistanceHiT) max(DistanceHiT) 0]';
yv2 = [ZPos min(y3) max(y4) ZPos]';

Gndxq = DistanceHiT;
Gndyq = g;

Gndxq2 = DistanceHiT;
Gndyq2 = g;

Objxq = xo;
Objyq = yObj;

Objxq2 = xo;
Objyq2 = yObj;

[Gndin,Gndon] = inpolygon(Gndxq,Gndxq,xv,yv);
[Gndin2,Gndon2] = inpolygon(Gndxq2,Gndyq2,xv2,yv2);
[Objin,Objon] = inpolygon(Objxq,Objyq,xv,yv);
[Objin2,Objon2] = inpolygon(Objxq2,Objyq2,xv2,yv2);

inGnd = Gndxq(Gndin);
if norm(inGnd) > 0
    Gnd = inGnd(1);
else
    Gnd = NaN;
end

inGnd2 = Gndxq2(Gndin2);
if norm(inGnd2) > 0
    Gnd2 = inGnd2(1);
else
    Gnd2 = NaN;
end

inObj = Objxq(Objin);
if norm(inObj) > 0
    Obj = inObj(1);
else
    Obj = NaN;
end

inObj2 = Objxq2(Objin2);
if norm(inObj2) > 0
    Obj2 = inObj2(1);
else
    Obj2 = NaN;
end

if norm(inObj) > 0 && norm(inObj2)
    SenObjPersep = (SenPersep+SenPersep2)/2
elseif norm(inObj) > 0
    SenObjPersep = SenPersep
elseif norm(inObj2) > 0
    SenObjPersep = SenPersep2
else
    SenObjPersep = 0
end


figure
hold on

plot(xv,yv) % polygon
plot(xv2,yv2,'m') % polygon
% axis equal

% hold on
plot(Gndxq(Gndin),Gndyq(Gndin),'r','Linewidth',3) % points inside
plot(Gndxq(~Gndin),Gndyq(~Gndin),'b','Linewidth',3) % points outside

plot(Gndxq2(Gndin2),Gndyq2(Gndin2),'r-','Linewidth',3) % points inside
plot(Gndxq2(~Gndin2),Gndyq2(~Gndin2),'b-','Linewidth',3) % points outside

plot(Objxq(Objin),Objyq(Objin),'r-.','Linewidth',3) % points inside
plot(Objxq(~Objin),Objyq(~Objin),'b-.','Linewidth',3) % points outside

plot(Objxq2(Objin2),Objyq2(Objin2),'g:','Linewidth',3) % points inside
plot(Objxq2(~Objin2),Objyq2(~Objin2),'k:','Linewidth',3) % points outside

plot(DistanceHiT,g)
plot(DistanceHiT,l,'b--',DistanceHiT,l2,'m-.')
% plot(xo,yObj,'o')
hold off