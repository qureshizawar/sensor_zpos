function [Ground,GroundCrit,ZPosGround] = GetMaxZPosition(BetaVar,GroundPresep,ZPosT,BHeight,BLength,WAngle)

% Alpha = ((SenVert/2) + MountAngle)*(pi/180);
% Beta = ((SenVert/2) - MountAngle)*(pi/180);
% MountAngleVar = linspace(-10,10,200);
% BetaVar = ((SenVert/2) - MountAngle)*(pi/180);
WAngle = WAngle*(pi/180);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for s = 1:size(BetaVar,2)

    Ground = ZPosT/tan(BetaVar);
    GroundCrit = NaN([size(Ground,1),1]);
    ZPosGround = NaN([size(ZPosT,1),1]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    cGnd = 1;
    for a = 1:size(Ground,1)
        if Ground(a,1) < GroundPresep
            GroundCrit(cGnd,1) = Ground(a,1);
            ZPosGround(cGnd,1) = ZPosT(a,1);
            if ZPosGround(cGnd,1) > BHeight
                Wx = (ZPosGround(cGnd,1) - BHeight)/tan(WAngle);
                if ZPosGround(cGnd,1) < BHeight + (BLength + Wx)*tan(BetaVar)
                    GroundCrit(cGnd,1) = NaN;
                    ZPosGround(cGnd,1) = NaN;
                end
            end

            cGnd = cGnd+1;
        end
    end

%     MaxGroundCrit(s,1) = max(GroundCrit);
%     MaxZPosGround(s,1) = max(ZPosGround);

%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end