function [GLOBE7_TINF] = GLOBE7(this,P)

%       CALCULATE G(L) function
%       Upper Thermosphere Parameters

DGTR = 1.74533E-2;
DR   = 1.72142E-2;
XL   = 1000.0;
%TLL  = 1000.0;
SW9  = 1.0;
%this.DAYL = -1.0;
P14  = -1000.0;
P18  = -1000.0;
P32  = -1000.0;
HR   = 0.2618;
SR   = 7.2722E-5;
SV   = ones(25,1);
NSW  = 14;
P39  = -1000.0;
T = zeros(15,1);

if (this.ISW ~= 64999)
    this.TSELEC(SV);
end

for J=1:14
    T(J)=0;
end

if (this.SW(9)> 0)
    SW9=1.0;
end
if (this.SW(9)< 0)
    SW9=-1.0;
end

% mnoah - not needed
% this.IYR   = YRD/1000.0;
% this.DAY   = YRD - this.IYR*1000.0;
% XLONG = this.GLONG;

% mnoah - moved to initialization phase
% % Eq. A22 (remainder of code)
% if (XL ~= this.GLAT)
%     % CALCULATE LEGENDRE POLYNOMIALS
%     C = sin(this.GLAT*DGTR);
%     S = cos(this.GLAT*DGTR);
%     C2 = C*C;
%     C4 = C2*C2;
%     S2 = S*S;
%     this.PLG(2,1) = C;
%     this.PLG(3,1) = 0.5*(3.0*C2 -1.0);
%     this.PLG(4,1) = 0.5*(5.0*C*C2-3.0*C);
%     this.PLG(5,1) = (35.0*C4 - 30.0*C2 + 3.0)/8.0;
%     this.PLG(6,1) = (63.0*C2*C2*C - 70.0*C2*C + 15.0*C)/8.0;
%     this.PLG(7,1) = (11.0*C*this.PLG(6,1) - 5.0*this.PLG(5,1))/6.0;
%     %     this.PLG(8,1) = (13.*C*this.PLG(7,1) - 6.*this.PLG(6,1))/7.
%     this.PLG(2,2) = S;
%     this.PLG(3,2) = 3.0*C*S;
%     this.PLG(4,2) = 1.5*(5.0*C2-1.0)*S;
%     this.PLG(5,2) = 2.5*(7.0*C2*C-3.0*C)*S;
%     this.PLG(6,2) = 1.875*(21.0*C4 - 14.0*C2 +1.0)*S;
%     this.PLG(7,2) = (11.0*C*this.PLG(6,2)-6.0*this.PLG(5,2))/5.0;
%     %     this.PLG(8,2) = (13.*C*this.PLG(7,2)-7.*this.PLG(6,2))/6.
%     %     this.PLG(9,2) = (15.*C*this.PLG(8,2)-8.*this.PLG(7,2))/7.
%     this.PLG(3,3) = 3.0*S2;
%     this.PLG(4,3) = 15.0*S2*C;
%     this.PLG(5,3) = 7.5*(7.0*C2 -1.0)*S2;
%     this.PLG(6,3) = 3.0*C*this.PLG(5,3)-2.0*this.PLG(4,3);
%     this.PLG(7,3) = (11.0*C*this.PLG(6,3)-7.0*this.PLG(5,3))/4.0;
%     this.PLG(8,3) = (13.0*C*this.PLG(7,3)-8.0*this.PLG(6,3))/5.0;
%     this.PLG(4,4) = 15.0*S2*S;
%     this.PLG(5,4) = 105.0*S2*S*C;
%     this.PLG(6,4) = (9.0*C*this.PLG(5,4)-7.0*this.PLG(4,4))/2.0;
%     this.PLG(7,4) = (11.0*C*this.PLG(6,4)-8.0*this.PLG(5,4))/3.0;
%     %XL=this.GLAT;
% end



% if ((TLL == this.LOCALSOLARTIME) || (this.SW(7) == 0 && this.SW(8) == 0 && this.SW(14) == 0))
% else
%     this.STLOC = sin(HR*this.LOCALSOLARTIME);
%     this.CTLOC = cos(HR*this.LOCALSOLARTIME);
%     this.S2TLOC = sin(2.*HR*this.LOCALSOLARTIME);
%     this.C2TLOC = cos(2.*HR*this.LOCALSOLARTIME);
%     this.S3TLOC = sin(3.*HR*this.LOCALSOLARTIME);
%     this.C3TLOC = cos(3.*HR*this.LOCALSOLARTIME);
    %TLL = this.LOCALSOLARTIME;
% end

%if (this.DAY ~= this.DAYL || P(14) ~= P14)
    CD14=cos(DR*(this.DAY-P(14)));
% end
% if (this.DAY ~= this.DAYL || P(18) ~= P18)
    CD18=cos(2.*DR*(this.DAY-P(18)));
% end
% if (this.DAY ~= this.DAYL || P(32) ~= P32)
    CD32=cos(DR*(this.DAY-P(32)));
% end
% if (this.DAY ~= this.DAYL || P(39) ~= P39)
    CD39=cos(2.*DR*(this.DAY-P(39)));
% end

%this.DAYL = this.DAY;
% P14 = P(14);
% P18 = P(18);
% P32 = P(32);
% P39 = P(39);

% this.TN1 = zeros(5,1);
% this.TN2 = zeros(4,1);
% this.TN3 = zeros(5,1);
% this.TGN1 = zeros(2,1);
% this.TGN2 = zeros(2,1);
% this.TGN3 = zeros(2,1);

T(1) =  P(20)*this.DF*(1.+P(60)*this.DFA) + P(21)*this.DF*this.DF + P(22)*this.DFA + P(30)*this.DFA^2;
F1 = 1.0 + (P(48)*this.DFA +P(20)*this.DF+P(21)*this.DF*this.DF)*this.SWC(1);
F2 = 1.0 + (P(50)*this.DFA+P(20)*this.DF+P(21)*this.DF*this.DF)*this.SWC(1);

% TIME INDEPENDENT
T(2) = (P(2)*this.PLG(3,1) + P(3)*this.PLG(5,1)+P(23)*this.PLG(7,1)) + ...
    (P(15)*this.PLG(3,1))*this.DFA*this.SWC(1) + P(27)*this.PLG(2,1);

% SYMMETRICAL ANNUAL
T(3) = (P(19) )*CD32;
% SYMMETRICAL SEMIANNUAL
T(4) = (P(16)+P(17)*this.PLG(3,1))*CD18;
% ASYMMETRICAL ANNUAL
T(5) =  F1*(P(10)*this.PLG(2,1)+P(11)*this.PLG(4,1))*CD14;
% ASYMMETRICAL SEMIANNUAL
T(6) =  P(38)*this.PLG(2,1)*CD39;

% DIURNAL
if (this.SW(7) ~= 0)
    T71 = (P(12)*this.PLG(3,2))*CD14*this.SWC(5);
    T72 = (P(13)*this.PLG(3,2))*CD14*this.SWC(5);
    T(7) = F2*((P(4)*this.PLG(2,2) + P(5)*this.PLG(4,2) + P(28)*this.PLG(6,2) + T71)*this.CTLOC + ...
        (P(7)*this.PLG(2,2) + P(8)*this.PLG(4,2) +P(29)*this.PLG(6,2) + T72)*this.STLOC);
end

% SEMIDIURNAL
if (this.SW(8) ~= 0)
    T81 = (P(24)*this.PLG(4,3)+P(36)*this.PLG(6,3))*CD14*this.SWC(5);
    T82 = (P(34)*this.PLG(4,3)+P(37)*this.PLG(6,3))*CD14*this.SWC(5);
    T(8) = F2*((P(6)*this.PLG(3,3) + P(42)*this.PLG(5,3) + T81)*this.C2TLOC + ...
        (P(9)*this.PLG(3,3) + P(43)*this.PLG(5,3) + T82)*this.S2TLOC);
end

% TERDIURNAL
if (this.SW(14) ~= 0) 
    T(14) = F2*((P(40)*this.PLG(4,4)+(P(94)*this.PLG(5,4)+ ...
        P(47)*this.PLG(7,4))*CD14*this.SWC(5))*this.S3TLOC+(P(41)*this.PLG(4,4)+ ...
        (P(95)*this.PLG(5,4)+P(49)*this.PLG(7,4))*CD14*this.SWC(5))*this.C3TLOC);
end

% MAGNETIC ACTIVITY BASED ON DAILY this.AP
if (SW9 ~= -1.0)
    this.APD=(this.AP(1)-4.0);
    P44=P(44);
    P45=P(45);
    if (P44< 0)
        P44=1.E-5;
    end
    this.APDF = this.APD+(P45-1.0)*(this.APD+(exp(-P44*this.APD)-1.0)/P44);
    if (this.SW(9) ~= 0)
        T(9)=this.APDF*(P(33)+P(46)*this.PLG(3,1)+P(35)*this.PLG(5,1)+ ...
            (P(101)*this.PLG(2,1)+P(102)*this.PLG(4,1)+P(103)*this.PLG(6,1))*CD14*this.SWC(5)+ ...
            (P(122)*this.PLG(2,2)+P(123)*this.PLG(4,2)+P(124)*this.PLG(6,2))*this.SWC(7)* ...
            cos(HR*(this.LOCALSOLARTIME-P(125))));
    end
else
    this.APD=this.AP(1);
    if (P(52) ~= 0)
        exp1 = exp(-10800.0*abs(P(52))/(1.0+P(139)*(45.0-abs(this.GLAT))));
        if (exp1 > 0.99999)
            exp1 = 0.99999;
        end
        if (P(25)< 1.E-4)
            P(25)=1.E-4;
        end
        this.APT(1) = this.SG0(exp1,P,this.AP);
        if (this.SW(9) ~= 0)
            T(9) = this.APT(1)*(P(51)+P(97)*this.PLG(3,1)+P(55)*this.PLG(5,1)+ ...
                (P(126)*this.PLG(2,1)+P(127)*this.PLG(4,1)+P(128)*this.PLG(6,1))*CD14*this.SWC(5)+ ...
                (P(129)*this.PLG(2,2)+P(130)*this.PLG(4,2)+P(131)*this.PLG(6,2))*this.SWC(7)* ...
                cos(HR*(this.LOCALSOLARTIME-P(132))));
        end
    end
end

if (this.SW(10) ~= 0 && this.GLONG > -1000.0)
    % LONGITUDINAL
    if (this.SW(11) ~= 0)
        T(11)= (1.+P(81)*this.DFA*this.SWC(1))* ...
            ((P(65)*this.PLG(3,2)+P(66)*this.PLG(5,2)+P(67)*this.PLG(7,2) ...
            +P(104)*this.PLG(2,2)+P(105)*this.PLG(4,2)+P(106)*this.PLG(6,2) ...
            +this.SWC(5)*(P(110)*this.PLG(2,2)+P(111)*this.PLG(4,2)+P(112)*this.PLG(6,2))*CD14)* ...
            cos(DGTR*this.GLONG) ...
            +(P(91)*this.PLG(3,2)+P(92)*this.PLG(5,2)+P(93)*this.PLG(7,2) ...
            +P(107)*this.PLG(2,2)+P(108)*this.PLG(4,2)+P(109)*this.PLG(6,2) ...
            +this.SWC(5)*(P(113)*this.PLG(2,2)+P(114)*this.PLG(4,2)+P(115)*this.PLG(6,2))*CD14)* ...
            sin(DGTR*this.GLONG));
    end
    
    % UT AND MIXED UT,LONGITUDE
    if (this.SW(12) ~= 0)
        T(12) = (1.+P(96)*this.PLG(2,1))*(1.+P(82)*this.DFA*this.SWC(1))* ...
            (1.+P(120)*this.PLG(2,1)*this.SWC(5)*CD14)* ...
            ((P(69)*this.PLG(2,1)+P(70)*this.PLG(4,1)+P(71)*this.PLG(6,1))* ...
            cos(SR*(this.SEC-P(72))));
        T(12) = T(12) +this.SWC(11)* ...
            (P(77)*this.PLG(4,3)+P(78)*this.PLG(6,3)+P(79)*this.PLG(8,3))* ...
            cos(SR*(this.SEC-P(80))+2.*DGTR*this.GLONG)*(1.+P(138)*this.DFA*this.SWC(1));
    end
    
    % UT,LONGITUDE MAGNETIC ACTIVITY
    if (this.SW(13) ~= 0)
        if (SW9 ~= -1.0)
            T(13)= this.APDF*this.SWC(11)*(1.+P(121)*this.PLG(2,1))* ...
                ((P( 61)*this.PLG(3,2)+P( 62)*this.PLG(5,2)+P( 63)*this.PLG(7,2))* ...
                cos(DGTR*(this.GLONG-P( 64)))) ...
                +this.APDF*this.SWC(11)*this.SWC(5)* ...
                (P(116)*this.PLG(2,2)+P(117)*this.PLG(4,2)+P(118)*this.PLG(6,2))* ...
                CD14*cos(DGTR*(this.GLONG-P(119))) ...
                + this.APDF*this.SWC(12)* ...
                (P( 84)*this.PLG(2,1)+P( 85)*this.PLG(4,1)+P( 86)*this.PLG(6,1))* ...
                cos(SR*(this.SEC-P( 76)));
        elseif (P(52) == 0)
            T(13)=this.APT(1)*this.SWC(11)*(1.+P(133)*this.PLG(2,1))* ...
                ((P(53)*this.PLG(3,2)+P(99)*this.PLG(5,2)+P(68)*this.PLG(7,2))* ...
                cos(DGTR*(this.GLONG-P(98)))) ...
                +this.APT(1)*this.SWC(11)*this.SWC(5)* ...
                (P(134)*this.PLG(2,2)+P(135)*this.PLG(4,2)+P(136)*this.PLG(6,2))* ...
                CD14*cos(DGTR*(this.GLONG-P(137))) ...
                +this.APT(1)*this.SWC(12)* ...
                (P(56)*this.PLG(2,1)+P(57)*this.PLG(4,1)+P(58)*this.PLG(6,1))* ...
                cos(SR*(this.SEC-P(59)));
        end
    end
    %  PARMS NOT USED: 83, 90,100,140-150
end

GLOBE7_TINF=P(31);
for I = 1:NSW
    GLOBE7_TINF = GLOBE7_TINF + abs(this.SW(I))*T(I);
end

end
