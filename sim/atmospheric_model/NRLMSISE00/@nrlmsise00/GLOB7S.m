%% *GLOB7S*
%% *function*
function [TT] = GLOB7S(this,P)
%% *purpose*
% VERSION OF GLOBE FOR LOWER ATMOSPHERE 10/26/99

DR = 2.0*pi/365.0; % [2*pi/365] days to radians conversion = 1.72142E-2
DGTR = pi/180.0;   % [pi/180] degrees to radians conversion = 1.74533E-2
PSET = 2.0;

% CONFIRM PARAMETER SET
if (P(100)==0)
    P(100) = PSET;
end
if (P(100) ~= PSET)
    fprintf(1,'WRONG PARAMETER SET FOR GLOB7S %10.1f %10.1f\n', PSET,P(100));
    error('unable to continue');
end

T = zeros(14,1);
        
CD32=cos(DR*(this.DAY-P(32)));
CD18=cos(2.*DR*(this.DAY-P(18)));
CD14=cos(DR*(this.DAY-P(14)));
CD39=cos(2.*DR*(this.DAY-P(39)));

% F10.7
T(1)=P(22)*this.DFA;
% TIME INDEPENDENT
T(2)=P(2)*this.PLG(3,1)+P(3)*this.PLG(5,1)+P(23)*this.PLG(7,1)+P(27)*this.PLG(2,1)+P(15)*this.PLG(4,1)+P(60)*this.PLG(6,1);
% SYMMETRICAL ANNUAL
T(3)=(P(19)+P(48)*this.PLG(3,1)+P(30)*this.PLG(5,1))*CD32;
% SYMMETRICAL SEMIANNUAL
T(4)=(P(16)+P(17)*this.PLG(3,1)+P(31)*this.PLG(5,1))*CD18;
% ASYMMETRICAL ANNUAL
T(5)=(P(10)*this.PLG(2,1)+P(11)*this.PLG(4,1)+P(21)*this.PLG(6,1))*CD14;
% ASYMMETRICAL SEMIANNUAL
T(6)=(P(38)*this.PLG(2,1))*CD39;
% DIURNAL
if (this.SW(7) ~= 0)
    T71 = P(12)*this.PLG(3,2)*CD14*this.SWC(5);
    T72 = P(13)*this.PLG(3,2)*CD14*this.SWC(5);
    T(7) = ((P(4)*this.PLG(2,2) + P(5)*this.PLG(4,2) + T71)*this.CTLOC + (P(7)*this.PLG(2,2) + P(8)*this.PLG(4,2)+ T72)*this.STLOC);
end
% SEMIDIURNAL
if (this.SW(8) ~= 0)
    T81 = (P(24)*this.PLG(4,3)+P(36)*this.PLG(6,3))*CD14*this.SWC(5);
    T82 = (P(34)*this.PLG(4,3)+P(37)*this.PLG(6,3))*CD14*this.SWC(5);
    T(8) = ((P(6)*this.PLG(3,3) + P(42)*this.PLG(5,3) + T81)*this.C2TLOC +(P(9)*this.PLG(3,3) + P(43)*this.PLG(5,3) + T82)*this.S2TLOC);
end

% TERDIURNAL
if (this.SW(14) ~= 0)
    T(14) = P(40)*this.PLG(4,4)*this.S3TLOC+P(41)*this.PLG(4,4)*this.C3TLOC;
end

% MAGNETIC ACTIVITY
if (this.SW(9) ~= 0)
    if (this.SW(9) == 1)
        T(9)=this.APDF*(P(33)+P(46)*this.PLG(3,1)*this.SWC(2));
    end
    if (this.SW(9) == -1)
        T(9)=(P(51)*this.APT(1)+P(97)*this.PLG(3,1)*this.APT(1)*this.SWC(2));
    end
end

if ( this.SW(10) == 0 || this.SW(11) == 0 || this.GLONG <= -1000.0 )
else
    % LONGITUDINAL
    T(11) = (1.0 ... 
        + this.PLG(2,1)*(P(81)*this.SWC(5)*cos(DR*(this.DAY-P(82))) ...
        + P(86)*this.SWC(6)*cos(2.*DR*(this.DAY-P(87)))) ...
        + P(84)*this.SWC(3)*cos(DR*(this.DAY-P(85))) ...
        + P(88)*this.SWC(4)*cos(2.*DR*(this.DAY-P(89))))*((P(65)*this.PLG(3,2)+P(66)*this.PLG(5,2)+P(67)*this.PLG(7,2) ...
        + P(75)*this.PLG(2,2)+P(76)*this.PLG(4,2)+P(77)*this.PLG(6,2))*cos(DGTR*this.GLONG) ...
        + (P(91)*this.PLG(3,2)+P(92)*this.PLG(5,2)+P(93)*this.PLG(7,2) ...
        + P(78)*this.PLG(2,2)+P(79)*this.PLG(4,2)+P(80)*this.PLG(6,2))*sin(DGTR*this.GLONG));
end

TT=0.0;
for I=1:14
    TT=TT+abs(this.SW(I))*T(I);
end

end