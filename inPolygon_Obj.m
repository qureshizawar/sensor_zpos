clear

SenVert = 30;
MountAngle = 0; %+ve clockwise
Gamma = 0.1;

Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);

% DistanceHi = linspace(0.1,200,3999); %increment 50mm
% DistanceHi = linspace(0.1,20,399); %increment 50mm
DistanceHi = linspace(0,2,1911); %increment 10mm
DistanceHiT = transpose(DistanceHi);

% ZPos = linspace(0.1,2.4,461); %increment 5mm
% % ZPos = linspace(0.1,2.4,231); %increment 10mm
% ZPosT = transpose(ZPos);
ZPos = 0.4;

l = tan((Alpha-Beta)/2)*DistanceHiT + ZPos;
y1 = -tan(Beta)*DistanceHiT + ZPos;
y2 = tan(Alpha)*DistanceHiT + ZPos;
g = 0*DistanceHiT ;
obj = linspace(0,0.5,101);

xv = [0 max(DistanceHiT) max(DistanceHiT) 0]';
yv = [ZPos min(y1) max(y2) ZPos]';

% xq = DistanceHiT;
xq = 1.4*ones(size(obj));
% yq = g;
yq = obj;

[in,on] = inpolygon(xq,yq,xv,yv);

% inGnd = xq(in);
% Gnd = inGnd(1);

inObj = yq(in);
if norm(inObj) > 0
    Obj = inObj(1)
else
    Obj = NaN;
end
figure

plot(xv,yv) % polygon
axis equal

hold on
plot(xq(in),yq(in),'r+') % points inside
plot(xq(~in),yq(~in),'bo') % points outside
plot(DistanceHiT,l,'--')
plot(DistanceHiT,g,'g--')
hold off