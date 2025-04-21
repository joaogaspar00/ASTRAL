function [D,T] = GTD7(this)
%
%     NRLMSISE-00
%     -----------
%        Neutral Atmosphere Empirical Model from the surface to lower
%        exosphere
%
%        NEW FEATURES:
%          *Extensive satellite drag database used in model generation
%          *Revised O2 (and O) in lower thermosphere
%          *Additional nonlinear solar activity term
%          *"ANOMALOUS OXYGEN" NUMBER DENSITY, OUTPUT D(9)
%           At high altitudes (> 500 km), hot atomic oxygen or ionized
%           oxygen can become appreciable for some ranges of subroutine
%           inputs, thereby affecting drag on satellites and debris. We
%           group these species under the term "anomalous oxygen," since
%           their individual variations are not presently separable with
%           the drag data used to define this model component.
%
%        SUBROUTINES FOR SPECIAL OUTPUTS:
%
%        HIGH ALTITUDE DRAG: EFFECTIVE TOTAL this.MASS DENSITY
%        (SUBROUTINE GTD7D, OUTPUT D(6))
%           For atmospheric drag calculations at altitudes above 500 km,
%           call SUBROUTINE GTD7D to compute the "effective total mass
%           density" by including contributions from "anomalous oxygen."
%           See "NOTES ON OUTPUT VARIABLES" below on D(6).
%
%        PRESSURE GRID (SUBROUTINE GHP7)
%          See subroutine GHP7 to specify outputs at a pressure level
%          rather than at an altitude.
%
%        OUTPUT IN M-3 and KG/M3:   CALL METERS(.TRUE.)
%
%     INPUT VARIABLES:
%        IYD - YEAR AND DAY AS YYDDD (day of year from 1 to 365 (or 366))
%              (Year ignored in current model)
%        SEC - UT(SEC)
%        this.ALT - ALTITUDE(KM)
%        this.GLAT - GEODETIC LATITUDE(DEG)
%        this.GLONG - GEODETIC LONGITUDE(DEG)
%        STL - LOCAL APPARENT SOLAR TIME(HRS; see Note below)
%        this.F107A - 81 day AVERAGE OF F10.7 FLUX (centered on day DDD)
%        this.F107 - DAILY F10.7 FLUX FOR PREVIOUS DAY
%        this.AP - MAGNETIC INDEX(DAILY) OR WHEN SW(9)=-1. :
%           - ARRAY CONTAINING:
%             (1) DAILY this.AP
%             (2) 3 HR this.AP INDEX FOR CURRENT TIME
%             (3) 3 HR this.AP INDEX FOR 3 HRS BEFORE CURRENT TIME
%             (4) 3 HR this.AP INDEX FOR 6 HRS BEFORE CURRENT TIME
%             (5) 3 HR this.AP INDEX FOR 9 HRS BEFORE CURRENT TIME
%             (6) AVERAGE OF EIGHT 3 HR this.AP INDICIES FROM 12 TO 33 HRS PRIOR
%                    TO CURRENT TIME
%             (7) AVERAGE OF EIGHT 3 HR this.AP INDICIES FROM 36 TO 57 HRS PRIOR
%                    TO CURRENT TIME
%        this.MASS - this.MASS NUMBER (ONLY DENSITY FOR SELECTED GAS IS
%                 CALCULATED.  this.MASS 0 IS TEMPERATURE.  this.MASS 48 FOR ALL.
%                 this.MASS 17 IS Anomalous O ONLY.)
%
%     NOTES ON INPUT VARIABLES:
%        UT, Local Time, and Longitude are used independently in the
%        model and are not of equal importance for every situation.
%        For the most physically realistic calculation these three
%        variables should be consistent (STL=SEC/3600+this.GLONG/15).
%        The Equation of Time departures from the above formula
%        for apparent local time can be included if available but
%        are of minor importance.
%
%        this.F107 and this.F107A values used to generate the model correspond
%        to the 10.7 cm radio flux at the actual distance of the Earth
%        from the Sun rather than the radio flux at 1 AU. The following
%        site provides both classes of values:
%        ftp://ftp.ngdc.noaa.gov/STP/SOLAR_DATA/SOLAR_RADIO/FLUX/
%
%        this.F107, this.F107A, and this.AP effects are neither large nor well
%        established below 80 km and these parameters should be set to
%        150., 150., and 4. respectively.
%
%     OUTPUT VARIABLES:
%        D(1) - HE NUMBER DENSITY(CM-3)
%        D(2) - O NUMBER DENSITY(CM-3)
%        D(3) - N2 NUMBER DENSITY(CM-3)
%        D(4) - O2 NUMBER DENSITY(CM-3)
%        D(5) - AR NUMBER DENSITY(CM-3)
%        D(6) - TOTAL this.MASS DENSITY(GM/CM3)
%        D(7) - H NUMBER DENSITY(CM-3)
%        D(8) - N NUMBER DENSITY(CM-3)
%        D(9) - Anomalous oxygen NUMBER DENSITY(CM-3)
%        T(1) - EXOSPHERIC TEMPERATURE
%        T(2) - TEMPERATURE AT this.ALT
%
%     NOTES ON OUTPUT VARIABLES:
%        TO GET OUTPUT IN M-3 and KG/M3:   CALL METERS(.TRUE.)
%
%        O, H, and N are set to zero below 72.5 km
%
%        T(1), Exospheric temperature, is set to global average for
%        altitudes below 120 km. The 120 km gradient is left at global
%        average value for altitudes below 72 km.
%
%        D(6), TOTAL this.MASS DENSITY, is NOT the same for subroutines GTD7
%        and GTD7D
%
%          SUBROUTINE GTD7 -- D(6) is the sum of the mass densities of the
%          species labeled by indices 1-5 and 7-8 in output variable D.
%          This includes He, O, N2, O2, Ar, H, and N but does NOT include
%          anomalous oxygen (species index 9).
%
%          SUBROUTINE GTD7D -- D(6) is the "effective total mass density
%          for drag" and is the sum of the mass densities of all species
%          in this model, INCLUDING anomalous oxygen.
%

D = zeros(9,1);
T = zeros(2,1);
TZ = 0;


ZMIX = 62.5;

MSSL = -999;

if (this.ISW ~= 64999)
    SV = ones(25,1);
    this.TSELEC(SV);
end


% Put identification data into common/datime/
% for I=1:3
%     ISDATE(I) = ISD(I);
% end
% for I=1:2
%     ISTIME(I) = IST(I);
%     NAME(I) = NAM(I);
% end


% Test for changed input
V1 = this.flagVTST7;

% Latitude variation of gravity (none for this.SW(2)=0)
XLAT = this.GLAT;
if (this.SW(2) == 0)
    XLAT=45.0;
end
[this.RE,this.GSURF] = nrlmsise00.GLATF(XLAT);


XMM=this.PDM(5,3);

% THERMOSPHERE/MESOSPHERE (above ZN2(1))
ALTT=max([this.ALT,this.ZN2(1)]);
MSS=this.MASS;

% % Only calculate N2 in thermosphere if alt in mixed region
% if (this.this.ALT< ZMIX && this.MASS> 0)
%     MSS = 28;
% end

% Only calculate thermosphere if input parameters changed
% or altitude above ZN2(1) in mesosphere
if (V1 == 1.0 || this.ALT > this.ZN2(1) || this.LAST_ALT_GTD7 > this.ZN2(1) || MSS ~= MSSL)
    [DS,TS] = this.GTS7(MSS);
    DM28M=this.DM28;
    % metric adjustment
    if (this.IMR == 1)
        DM28M=this.DM28*1.0E6;
    end
end
this.flagVTST7 = 0;
T(1)=TS(1);
T(2)=TS(2);

%% *check altitude*
% if ALT >= 72.5 km (above middle mesosphere) the calculation is complete
if (this.ALT >= this.ZN2(1))
    for J=1:9
        D(J)=DS(J);
    end
    this.LAST_ALT_GTD7=this.ALT;
    return;
end

%% *lower mesosphere and upper stratosphere*
% LOWER MESOSPHERE/UPPER STRATOSPHERE [between ZN3(1) and ZN2(1)]
% Temperature at nodes and gradients at end nodes
% Inverse temperature a linear function of spherical harmonics
% Only calculate nodes if input changed
if (V1 == 1.0 || this.LAST_ALT_GTD7>= this.ZN2(1))
    this.TGN2(1)=this.TGN1(2);
    this.TN2(1)=this.TN1(5);
    this.TN2(2)=this.PMA(1,1)*this.PAVGM(1)/(1.0-this.SW(20)*this.GLOB7S(this.PMA(:,1)));
    this.TN2(3)=this.PMA(1,2)*this.PAVGM(2)/(1.0-this.SW(20)*this.GLOB7S(this.PMA(:,2)));
    this.TN2(4)=this.PMA(1,3)*this.PAVGM(3)/(1.0-this.SW(20)*this.SW(22)*this.GLOB7S(this.PMA(:,3)));
    this.TGN2(2)=this.PAVGM(9)*this.PMA(1,10)*(1.0+this.SW(20)*this.SW(22)*this.GLOB7S(this.PMA(:,10)))*this.TN2(4)*this.TN2(4)/(this.PMA(1,3)*this.PAVGM(3))^2;
    this.TN3(1)=this.TN2(4);
end

if (this.ALT < this.ZN3(1))
    % LOWER STRATOSPHERE AND TROPOSPHERE [below ZN3(1)]
    % Temperature at nodes and gradients at end nodes
    % Inverse temperature a linear function of spherical harmonics
    % Only calculate nodes if input changed
    if ( V1 == 1.0 || this.LAST_ALT_GTD7>= this.ZN3(1) )
        this.TGN3(1)=this.TGN2(2);
        this.TN3(2)=this.PMA(1,4)*this.PAVGM(4)/(1.-this.SW(22)*this.GLOB7S(this.PMA(:,4)));
        this.TN3(3)=this.PMA(1,5)*this.PAVGM(5)/(1.-this.SW(22)*this.GLOB7S(this.PMA(:,5)));
        this.TN3(4)=this.PMA(1,6)*this.PAVGM(6)/(1.-this.SW(22)*this.GLOB7S(this.PMA(:,6)));
        this.TN3(5)=this.PMA(1,7)*this.PAVGM(7)/(1.-this.SW(22)*this.GLOB7S(this.PMA(:,7)));
        this.TGN3(2)=this.PMA(1,8)*this.PAVGM(8)*(1.+this.SW(22)*this.GLOB7S(this.PMA(:,8)))*this.TN3(5)*this.TN3(5)/(this.PMA(1,7)*this.PAVGM(7))^2;
    end
end

if (this.MASS == 0)
    [~,TZ] = nrlmsise00.DENSM(this.ALT,1.0,0, ...
        this.MN3,this.ZN3,this.TN3,this.TGN3, ...
        this.MN2,this.ZN2,this.TN2,this.TGN2, ...
        this.RE,this.GSURF);
    T(2) = TZ;
    this.LAST_ALT_GTD7 = this.ALT;
    return
end

% LINEAR TRANSITION TO FULL MIXING BELOW ZN2(1)
DMC=0;
if ( this.ALT > ZMIX )
    DMC = 1.0 - (this.ZN2(1)-this.ALT)/(this.ZN2(1)-ZMIX);
end

DZ28 = DS(3);
% N2 DENSITY
DMR = DS(3)/DM28M-1.0;
[D(3),TZ] = nrlmsise00.DENSM(this.ALT,DM28M,XMM, ...
    this.MN3,this.ZN3,this.TN3,this.TGN3, ...
    this.MN2,this.ZN2,this.TN2,this.TGN2, ...
    this.RE,this.GSURF);
D(3)=D(3)*(1.+DMR*DMC);

% HE DENSITY
D(1) = 0;
if (this.MASS == 4 || this.MASS == 48)
    DMR=DS(1)/(DZ28*this.PDM(2,1))-1.0;
    D(1)=D(3)*this.PDM(2,1)*(1.+DMR*DMC);
end

% O DENSITY
D(2) = 0;
D(9) = 0;

% O2 DENSITY
D(4) = 0;
if (this.MASS == 32 || this.MASS == 48)
    DMR=DS(4)/(DZ28*this.PDM(2,4))-1.0;
    D(4)=D(3)*this.PDM(2,4)*(1.+DMR*DMC);
end

% AR DENSITY
D(5) = 0;
if (this.MASS == 40 || this.MASS == 48)
    DMR = DS(5)/(DZ28*this.PDM(2,5)) - 1.0;
    D(5) = D(3)*this.PDM(2,5)*(1.+DMR*DMC);
end

% HYDROGEN DENSITY
D(7) = 0;

% ATOMIC NITROGEN DENSITY
D(8) = 0;

% TOTAL this.MASS DENSITY
% ignores the anamolous oxygen contribution D(9)
if (this.MASS == 48)
    D(6) = 1.66E-24*(4.0*D(1)+16.0*D(2)+28.0*D(3)+32.0*D(4)+40.0*D(5)+D(7)+14.0*D(8));
end

if (this.IMR == 1)
    D(6) = D(6)/1000.0;
end

T(2) = TZ;
this.LAST_ALT_GTD7 = this.ALT;

end