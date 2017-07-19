clear

SenVert = 30;
MountAngle = 0; %+ve clockwise
Gamma = 0.1;

Alpha = ((SenVert/2) + MountAngle)*(pi/180);
Beta = ((SenVert/2) - MountAngle)*(pi/180);

% DistanceHi = linspace(0.1,200,3999); %increment 50mm
% DistanceHi = linspace(0.1,20,399); %increment 50mm
DistanceHi = linspace(0.1,20,1911); %increment 10mm
DistanceHiT = transpose(DistanceHi);

ZPos = linspace(0.1,2.4,461); %increment 5mm
% ZPos = linspace(0.1,2.4,231); %increment 10mm
ZPosT = transpose(ZPos);

% ZPos = 0.5;
ix = zeros(399,461);
tic
for s = 1:size(ZPos,2)
    y1(:,s) = -tan(Beta)*DistanceHiT + ZPos(s);
    y2(:,s) = tan(Alpha)*DistanceHiT + ZPos(s);
    g(:,s) = 0*DistanceHiT;
%     i(1,s) = intersect(round(y1(:,s),3),round(g(:,s),3));

%     k(:,s) = y1(:,s) - g(:,s);
%     ix(s) = find(k(:,s) > -.001 & k(:,s) < .001);
%     x_sol = DistanceHiT(ix)
%     y1_sol = y1(ix)
%     g_sol = g(ix)

%     x(s) = -(ZPos(s) - min(ZPos)) /(-tan(Beta) -tan(Alpha));

% [in,on] = inpolygon(DistanceHiT,g(:,s),xv,yv);

xv = [0 max(DistanceHiT) max(DistanceHiT) 0]';
yv = [ZPos(s) min(y1(:,s)) max(y2(:,s)) ZPos(s)]';

xq = DistanceHiT;
yq = g(:,s);

[in,on] = inpolygon(xq,yq,xv,yv);

inGnd = xq(in);
Gnd(s) = inGnd(1);
end
toc

% d = size(DistanceHiT,1);
% z = size(ZPos,2);
% 
% i(d,z) = intersect(round(y1,2),round(g,3));
% i = intersect(round(y1,3),round(g,3))

% plot(DistanceHiT,y1,DistanceHiT,y2,DistanceHiT,g)
plot(Gnd,ZPos)
% hold on
% % h = refline([0 -ZPos - min(ZPos)]); 
% 
% intersect(y1,g)