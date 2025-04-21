function [ALT,D,T] = GHP7(this,PRESS)
%% *purpose*
%  To find the altitude of a pressure surface (PRESS) from GTD7
%% *inputs*
%  PRESS - PRESSURE LEVEL(MB)
%% *variables used*
%  IYD - YEAR AND DAY AS YYDDD
%  SEC - UT(SEC)
%  GLAT - GEODETIC LATITUDE(DEG)
%  GLONG - GEODETIC LONGITUDE(DEG)
%  STL - LOCAL APPARENT SOLAR TIME(HRS)
%  F107A - 3 MONTH AVERAGE OF F10.7 FLUX
%  F107 - DAILY F10.7 FLUX FOR PREVIOUS DAY
%  AP - MAGNETIC INDEX(DAILY) OR WHEN SW(9)=-1. :
%       - ARRAY CONTAINING:
%             (1) DAILY AP
%             (2) 3 HR AP INDEX FOR CURRENT TIME
%             (3) 3 HR AP INDEX FOR 3 HRS BEFORE CURRENT TIME
%             (4) 3 HR AP INDEX FOR 6 HRS BEFORE CURRENT TIME
%             (5) 3 HR AP INDEX FOR 9 HRS BEFORE CURRENT TIME
%             (6) AVERAGE OF EIGHT 3 HR AP INDICIES FROM 12 TO 33 HRS PRIOR
%                    TO CURRENT TIME
%             (7) AVERAGE OF EIGHT 3 HR AP INDICIES FROM 36 TO 59 HRS PRIOR
%                    TO CURRENT TIME
%% *outputs calculated*
%  ALT - ALTITUDE(KM)
%  D(1) - HE NUMBER DENSITY(CM-3)
%  D(2) - O NUMBER DENSITY(CM-3)
%  D(3) - N2 NUMBER DENSITY(CM-3)
%  D(4) - O2 NUMBER DENSITY(CM-3)
%  D(5) - AR NUMBER DENSITY(CM-3)
%  D(6) - TOTAL MASS DENSITY(GM/CM3)
%  D(7) - H NUMBER DENSITY(CM-3)
%  D(8) - N NUMBER DENSITY(CM-3)
%  D(9) - HOT O NUMBER DENSITY(CM-3)
%  T(1) - EXOSPHERIC TEMPERATURE
%  T(2) - TEMPERATURE AT ALT
%% *history*
%  when     who   why
%  20190610 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*

BM = this.Boltzmann*1e4; % [1e4 J/K] = 1.3806E-19;

TEST = 0.00043;
LTEST = 12;

PL=log10(PRESS); % [log10(mb)]

% Initial altitude estimate
if (PL >= -5.0)
    switch true
        case (PL > 2.5)
            ZI = 18.06*(3.00-PL);
        case (PL > 0.75 && PL <= 2.5)
            ZI = 14.98*(3.08-PL);
        case (PL > -1.0 && PL <= 0.75)
            ZI = 17.8*(2.72-PL);
        case (PL > -2.0 && PL <= -1.0)
            ZI = 14.28*(3.64-PL);
        case (PL > -4.0 && PL <= -2.0)
            ZI = 12.72*(4.32-PL);
        case (PL <= -4.0)
            ZI = 25.3*(0.11-PL);
    end
   
    CL = this.GLAT/90.0;
    CL2 = CL*CL;
    if (this.DAY < 182)
        CD = 1.0 - this.DAY/91.25;
    elseif (this.DAY >= 182)
        CD = this.DAY/91.25 - 3.0;
    end
    CA = 0;
    switch true
        case (PL > -1.11 && PL <= -0.23)
            CA = 1.0;
        case (PL > -.23)
            CA = (2.79-PL)/(2.79+0.23);
        case (PL <= -1.11 && PL > -3.0)
            CA = (-2.93-PL)/(-2.93+1.11);
    end
    Z = ZI-4.87*CL*CD*CA-1.64*CL2*CA+0.31*CA*CL;
else
    % (PL < -5.0)
    Z = 22.0*(PL+4.0)^2+110.0;
end

% ITERATION LOOP
L=0;
flagGo = true;
while (flagGo == true)
    L=L+1;
    [D,T] = this.GTD7(48);
    XN = D(1)+D(2)+D(3)+D(4)+D(5)+D(7)+D(8);
    P = BM*XN*T(2);
    if (this.IMR == 1)
        P=P*1.0E-6;
    end
    DIFF = PL - log10(P);
    if ( abs(DIFF)< TEST  ||  L == LTEST)
        flagGo = false;
    else
        XM=(D(6)/XN)/1.66E-24;
        if (this.IMR == 1)
            XM = XM*1.E3;
        end
        G = this.GSURF/(1.0 + Z/this.RE)^2;
        SH = 100.0*this.RGAS*T(2)/(XM*G);
        % New altitude estimate using scale height
        if (L < 6)
            Z = Z - SH*DIFF*2.302;
        else
            Z = Z - SH*DIFF;
        end
    end
end

if (L == LTEST)
    fprintf(1,'GHP7 NOT CONVERGING FOR PRESS, %12.2e, %12.2e\n', PRESS,DIFF);
    %     WRITE(6,100) PRESS,DIFF
    %   100 FORMAT(1X,29HGHP7 NOT CONVERGING FOR PRESS, 1PE12.2,E12.2)
end

ALT = Z;

end


