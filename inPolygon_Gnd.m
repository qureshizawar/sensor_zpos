clear

slopeAngle = 7;
slope = tan(slopeAngle*(pi/180));
% slope = 0.13;
XMax = 2;

b = slope;
a = -b/(2*XMax);

SenVert = 30;
MountAngle = 0; %+ve clockwise
% Orientation = 0;
Orientation = atan(-(1/b))*(180/pi) +90;
Gamma = 0.1;

Alpha = ((SenVert/2) + MountAngle + Orientation)*(pi/180);
Beta = ((SenVert/2) - MountAngle - Orientation)*(pi/180);

% DistanceHi = linspace(0.1,200,3999); %increment 50mm
% DistanceHi = linspace(0.1,20,399); %increment 50mm
DistanceHi = linspace(0,5,1911); %increment 10mm
DistanceHiT = transpose(DistanceHi);

% ZPos = linspace(0.1,2.4,461); %increment 5mm
% % ZPos = linspace(0.1,2.4,231); %increment 10mm
% ZPosT = transpose(ZPos);
ZPos = 0.5;

ObjHeightPersep = 0.3;
ObjDistancePersep = 4.75;

l = tan((Alpha-Beta)/2)*DistanceHiT + ZPos;
y1 = -tan(Beta)*DistanceHiT + ZPos;
y2 = tan(Alpha)*DistanceHiT + ZPos;
% g = 0*DistanceHiT ;
% g = -(1/40)*DistanceHiT.^2 + 0.1*DistanceHiT;
g = a*(DistanceHiT.^2) + b*DistanceHiT;
% dg = gradient(g)
dg = 2*a*DistanceHiT +b;

grad = 2*a*ObjDistancePersep +b

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

xq = DistanceHiT;
yq = g;

[in,on] = inpolygon(xq,yq,xv,yv);

inGnd = xq(in);
if norm(inGnd) > 0
    Gnd = inGnd(1);
else
    Gnd = NaN;
end

figure

plot(xv,yv) % polygon
axis equal

hold on
plot(xq(in),yq(in),'r+') % points inside
plot(xq(~in),yq(~in),'bo') % points outside
plot(DistanceHiT,l,'--')
plot(xo,yObj,'o')
hold off