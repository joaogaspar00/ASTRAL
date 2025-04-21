function [D,T] = GTD7D(this)
%% *purpose*
%  This subroutine provides Effective Total Mass Density for
%  output D(6) which includes contributions from "anomalous
%  oxygen" which can affect satellite drag above 500 km.  This
%  subroutine is part of the distribution package for the
%  Neutral Atmosphere Empirical Model from the surface to lower
%  exosphere.  See subroutine GTD7 for more extensive comments.
%
%     INPUT VARIABLES:
%        IYD - YEAR AND DAY AS YYDDD (day of year from 1 to 365 (or 366))
%              (Year ignored in current model)
%        SEC - UT(SEC)
%        ALT - ALTITUDE(KM)
%        GLAT - GEODETIC LATITUDE(DEG)
%        GLONG - GEODETIC LONGITUDE(DEG)
%        STL - LOCAL APPARENT SOLAR TIME(HRS; see Note below)
%        F107A - 81 day AVERAGE OF F10.7 FLUX (centered on day DDD)
%        F107 - DAILY F10.7 FLUX FOR PREVIOUS DAY
%        AP - MAGNETIC INDEX(DAILY) OR WHEN SW(9)=-1. :
%           - ARRAY CONTAINING:
%             (1) DAILY AP
%             (2) 3 HR AP INDEX FOR CURRENT TIME
%             (3) 3 HR AP INDEX FOR 3 HRS BEFORE CURRENT TIME
%             (4) 3 HR AP INDEX FOR 6 HRS BEFORE CURRENT TIME
%             (5) 3 HR AP INDEX FOR 9 HRS BEFORE CURRENT TIME
%             (6) AVERAGE OF EIGHT 3 HR AP INDICIES FROM 12 TO 33 HRS PRIOR
%                    TO CURRENT TIME
%             (7) AVERAGE OF EIGHT 3 HR AP INDICIES FROM 36 TO 57 HRS PRIOR
%                    TO CURRENT TIME
%        MASS - MASS NUMBER (ONLY DENSITY FOR SELECTED GAS IS
%                 CALCULATED.  MASS 0 IS TEMPERATURE.  MASS 48 FOR ALL.
%                 MASS 17 IS Anomalous O ONLY.)
%
%     NOTES ON INPUT VARIABLES:

%

%
%     OUTPUT VARIABLES:
%        D(1) - HE NUMBER DENSITY(CM-3)
%        D(2) - O NUMBER DENSITY(CM-3)
%        D(3) - N2 NUMBER DENSITY(CM-3)
%        D(4) - O2 NUMBER DENSITY(CM-3)
%        D(5) - AR NUMBER DENSITY(CM-3)
%        D(6) - TOTAL MASS DENSITY(GM/CM3) [includes anomalous oxygen]
%        D(7) - H NUMBER DENSITY(CM-3)
%        D(8) - N NUMBER DENSITY(CM-3)
%        D(9) - Anomalous oxygen NUMBER DENSITY(CM-3)
%        T(1) - EXOSPHERIC TEMPERATURE
%        T(2) - TEMPERATURE AT ALT
%

[D,T] = this.GTD7();

% Total Mass Density for satellite drag calculations
if (this.MASS == 48)
    D(6) = 1.66E-24*(4.0*D(1)+16.0*D(2)+28.0*D(3)+32.0*D(4)+40.0*D(5)+D(7)+14.0*D(8)+16.0*D(9));
    if (this.IMR == 1)
        D(6)=D(6)/1000.0; % [kg/m3] SI units
    end
end

end
