function [D,T] = GTS7(this,MASS)
%
%     Thermospheric portion of NRLMSISE-00
%     See GTD7 for more extensive comments
%
%        OUTPUT IN M-3 and KG/M3:   CALL METERS(.TRUE.)
% 
%     INPUT VARIABLES:
%        IYD - YEAR AND DAY AS YYDDD (day of year from 1 to 365 (or 366))
%              (Year ignored in current model)
%        SEC - UT(SEC)
%        this.ALT - ALTITUDE(KM) (>72.5 km)
%        this.GLAT - GEODETIC LATITUDE(DEG)
%        GLONG - GEODETIC LONGITUDE(DEG)
%        STL - LOCAL APPARENT SOLAR TIME(HRS; see Note below)
%        this.F107A - 81 day AVERAGE OF F10.7 FLUX (centered on day DDD)
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
%        UT, Local Time, and Longitude are used independently in the
%        model and are not of equal importance for every situation.  
%        For the most physically realistic calculation these three
%        variables should be consistent (STL=SEC/3600+GLONG/15).
%        The Equation of Time departures from the above formula
%        for apparent local time can be included if available but
%        are of minor importance.
%
%        F107 and this.F107A values used to generate the model correspond
%        to the 10.7 cm radio flux at the actual distance of the Earth
%        from the Sun rather than the radio flux at 1 AU. The following
%        site provides both classes of values:
%        ftp://ftp.ngdc.noaa.gov/STP/SOLAR_DATA/SOLAR_RADIO/FLUX/
%
%        F107, this.F107A, and AP effects are neither large nor well
%        established below 80 km and these parameters should be set to
%        150., 150., and 4. respectively.
%
%     OUTPUT VARIABLES:
%        D(1) - HE NUMBER DENSITY(CM-3)
%        D(2) - O NUMBER DENSITY(CM-3)
%        D(3) - N2 NUMBER DENSITY(CM-3)
%        D(4) - O2 NUMBER DENSITY(CM-3)
%        D(5) - AR NUMBER DENSITY(CM-3)                       
%        D(6) - TOTAL MASS DENSITY(GM/CM3) [Anomalous O NOT included]
%        D(7) - H NUMBER DENSITY(CM-3)
%        D(8) - N NUMBER DENSITY(CM-3)
%        D(9) - Anomalous oxygen NUMBER DENSITY(CM-3)
%        T(1) - EXOSPHERIC TEMPERATURE
%        T(2) - TEMPERATURE AT this.ALT
%


D = zeros(9,1);
T = zeros(2,1);

% /MESO7/ these are the temperatures at the spline nodes
% TN1 = zeros(5,1);
% TN2 = zeros(4,1);
% TN3 = zeros(5,1);
% TGN1 = zeros(2,1);
% TGN2 = zeros(2,1);
% TGN3 = zeros(2,1);
        
MT = [48,0,4,16,28,32,40,1,49,14,17]';
ALTL = [ 200.0,300.0,160.0,250.0,240.0,450.0,320.0,450.0]';

DGTR = 1.74533E-2;
DR = 1.72142E-2;
ALPHA = [-0.38,0.0,0.0,0.0,0.17,0.0,-0.38,0.0,0.0]';
      
% Test for changed input
V2 = this.flagVTST7;

% mnoah - removed this logic and set the value of ZN1(1) = 123.4350 km
% since that was the only value it could be as PDL is not overwritten
% ZA = this.PDL(16,2);
% this.ZN1(1) = ZA;

D = zeros(9,1);
T = zeros(2,1);

% TINF VARIATIONS NOT IMPORTANT BELOW ZA OR ZN1(1)
if ( this.ALT > this.ZN1(1))  % THEN
    %if ( V2 == 1.0 || this.LAST_ALT_GTS7<= this.ZN1(1))
        TINF=this.PTM(1)*this.PT(1)*(1.+this.SW(16)*this.GLOBE7(this.PT));
    %end
else
    TINF = this.PTM(1)*this.PT(1);
end
T(1) = TINF;
      
% GRADIENT VARIATIONS NOT IMPORTANT BELOW ZN1(5)
if ( this.ALT > this.ZN1(5) )   
    %if ( V2 == 1 || this.LAST_ALT_GTS7 <= this.ZN1(5))
        G0=this.PTM(4)*this.PS(1)*(1.+this.SW(19)*this.GLOBE7(this.PS));
    %end
else
    G0=this.PTM(4)*this.PS(1);
end

% Calculate these temperatures only if input changed
%if ( V2 == 1.0  ||  this.ALT < 300.0 )
    TLB=this.PTM(2)*(1.0+this.SW(17)*this.GLOBE7(this.PD(:,4)))*this.PD(1,4);
%end
S=G0/(TINF-TLB);
% Lower thermosphere temp variations not significant for
% density above 300 km
if ( this.ALT < 300.0 )  % THEN
    if ( V2 == 1.0 || this.LAST_ALT_GTS7 >= 300.0 )
        this.TN1(2) = this.PTM(7)*this.PTL(1,1)/(1.0-this.SW(18)*this.GLOB7S(this.PTL(:,1)));
        this.TN1(3) = this.PTM(3)*this.PTL(1,2)/(1.0-this.SW(18)*this.GLOB7S(this.PTL(:,2)));
        this.TN1(4) = this.PTM(8)*this.PTL(1,3)/(1.0-this.SW(18)*this.GLOB7S(this.PTL(:,3)));
        this.TN1(5) = this.PTM(5)*this.PTL(1,4)/(1.0-this.SW(18)*this.SW(20)*this.GLOB7S(this.PTL(:,4)));
        this.TGN1(2) = this.PTM(9)*this.PMA(1,9)*(1.0+this.SW(18)*this.SW(20)*this.GLOB7S(this.PMA(:,9)))*this.TN1(5)*this.TN1(5)/(this.PTM(5)*this.PTL(1,4))^2;
    end
else
    this.TN1(2)=this.PTM(7)*this.PTL(1,1);
    this.TN1(3)=this.PTM(3)*this.PTL(1,2);
    this.TN1(4)=this.PTM(8)*this.PTL(1,3);
    this.TN1(5)=this.PTM(5)*this.PTL(1,4);
    this.TGN1(2)=this.PTM(9)*this.PMA(1,9)*this.TN1(5)*this.TN1(5)/(this.PTM(5)*this.PTL(1,4))^2;
end
%
Z0 = this.ZN1(4);
T0 = this.TN1(4);
TR12 = 1.0;
TZ = 0.0;

if (MASS == 0)
    Z = abs(this.ALT);
    [~,T(2)] = nrlmsise00.DENSU(Z, 1.0, TINF, TLB, 0.0, 0.0, T(2), this.PTM(6), S, this.MN1, this.ZN1, this.TN1, this.TGN1, this.RE, this.GSURF);
    this.LAST_ALT_GTS7=this.ALT;
    return;
end
      
% N2 variation factor at Zlb
G28 = this.SW(21)*this.GLOBE7(this.PD(:,3));

     
% VARIATION OF TURBOPAUSE HEIGHT
ZHF = this.PDL(25,2)*(1.0+this.SW(5)*this.PDL(25,1)*sin(DGTR*this.GLAT)*cos(DR*(this.DAY-this.PT(14))));

T(1) = TINF;
XMM = this.PDM(5,3);
Z = this.ALT;
      
% %
% J = find(MASS == MT);
% if (isempty(J))
%     fprintf(1,'MASS %f NOT VALID\n',MASS);
%     % ADJUST DENSITIES FROM CGS TO KGM
%     if (this.IMR == 1)
%         for I=1:9
%             D(I)=D(I)*1.E6;
%         end
%         D(6)=D(6)/1000.0;
%     end
%     this.LAST_ALT_GTS7=this.ALT;
%     return;
% end

% if ( Z <= ALTL(6) && (MASS == 28 || MASS == 48)) <- mnoah removed logic
% constraint
    % N2 DENSITY
    % Diffusive density at Zlb
    DB28 = this.PDM(1,3)*exp(G28)*this.PD(1,3);
    % Diffusive density at Alt
    [D(3),T(2)]=nrlmsise00.DENSU(Z,DB28,TINF,TLB,28.0,ALPHA(3),T(2), ...
        this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
    DD = D(3);
    % Turbopause
    ZH28 = this.PDM(3,3)*ZHF;
    ZHM28 = this.PDM(4,3)*this.PDL(6,2);
    XMD = 28.0 - XMM;
    % Mixed density at Zlb
    B28=nrlmsise00.DENSU(ZH28,DB28,TINF,TLB,XMD,ALPHA(3)-1.0,TZ,this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
    if ( (Z <= ALTL(3)) && (this.SW(15) ~= 0.0) )
        % Mixed density at Alt
        [this.DM28,TZ] = nrlmsise00.DENSU(Z,B28,TINF,TLB,XMM,ALPHA(3),TZ,this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        % Net density at Alt
        D(3) = this.DNET(D(3),this.DM28,ZHM28,XMM,28.0);
    end
% end

      
%        MT = [48, 0, 4,16,28,32,40, 1,49,14,17];
%       GO TO (20,50,20,25,90,35,40,45,25,48,46),  J
%    20 CONTINUE

% HE DENSITY
if (MASS == 4 || MASS >= 48)
    % Density variation factor at Zlb
    G4 = this.SW(21)*this.GLOBE7(this.PD(:,1));
    % Diffusive density at Zlb
    DB04 = this.PDM(1,1)*exp(G4)*this.PD(1,1);
    % Diffusive density at Alt
    D(1) = nrlmsise00.DENSU(Z,DB04,TINF,TLB,4.0,ALPHA(1),T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
    DD=D(1);
    if ( (Z <= ALTL(1)) && (this.SW(15) ~= 0) )
        % Turbopause
        ZH04 = this.PDM(3,1);
        % Mixed density at Zlb
        [B04,T(2)] = nrlmsise00.DENSU(ZH04,DB04,TINF,TLB,4.0-XMM,ALPHA(1)-1.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        % Mixed density at Alt
        [DM04,T(2)] = nrlmsise00.DENSU(Z,B04,TINF,TLB,XMM,0.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        ZHM04 = ZHM28;
        % Net density at Alt
        D(1) = nrlmsise00.DNET(D(1),DM04,ZHM04,XMM,4.0);
        % Correction to specified mixing ratio at ground
        RL = log(B28*this.PDM(2,1)/B04);
        ZC04 = this.PDM(5,1)*this.PDL(1,2);
        HC04 = this.PDM(6,1)*this.PDL(2,2);
        % Net density corrected at Alt
        D(1) = D(1)*nrlmsise00.CCOR(Z,RL,HC04,ZC04);
    end
end
   
% O DENSITY
if (MASS == 16 || MASS >= 48)
    % Density variation factor at Zlb
    G16 = this.SW(21)*this.GLOBE7(this.PD(:,2));
    % Diffusive density at Zlb
    DB16 = this.PDM(1,2)*exp(G16)*this.PD(1,2);
    % Diffusive density at Alt
    [D(2),T(2)] = nrlmsise00.DENSU(Z,DB16,TINF,TLB, 16.,ALPHA(2),T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
    DD = D(2);
    if ( (Z <= ALTL(2)) && (this.SW(15) ~= 0.0) )
        % Corrected from this.PDM(3,1) to this.PDM(3,2)  12/2/85
        % Turbopause
        ZH16 = this.PDM(3,2);
        % Mixed density at Zlb
        [B16,T(2)] = nrlmsise00.DENSU(ZH16,DB16,TINF,TLB,16-XMM,ALPHA(2)-1.0,T(2),this.PTM(6),S, ...
            this.MN1,this.ZN1,this.TN1,this.TGN1, ...
            this.RE, this.GSURF);
        % Mixed density at Alt
        [DM16,T(2)] = nrlmsise00.DENSU(Z,B16,TINF,TLB,XMM,0.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        ZHM16 = ZHM28;
        % Net density at Alt
        D(2) = nrlmsise00.DNET(D(2),DM16,ZHM16,XMM,16.0);
        % 3/16/99 Change form to match O2 departure 
        %         from diff equil near 150 km and add dependence on F10.7
        %         RL=ALOG(B28*this.PDM(2,2)*ABS(this.PDL(17,2))/B16)
        RL = this.PDM(2,2)*this.PDL(17,2)*(1.0+this.SW(1)*this.PDL(24,1)*(this.F107A-150.0));
        HC16 = this.PDM(6,2)*this.PDL(4,2);
        ZC16 = this.PDM(5,2)*this.PDL(3,2);
        HC216 = this.PDM(6,2)*this.PDL(5,2);
        D(2) = D(2)*nrlmsise00.CCOR2(Z,RL,HC16,ZC16,HC216);
        % Chemistry correction
        HCC16 = this.PDM(8,2)*this.PDL(14,2);
        ZCC16 = this.PDM(7,2)*this.PDL(13,2);
        RC16 = this.PDM(4,2)*this.PDL(15,2);
        % Net density corrected at Alt
        D(2) = D(2)*nrlmsise00.CCOR(Z,RC16,HCC16,ZCC16);
    end
end
   
% O2 DENSITY
if (MASS == 32 || MASS >= 48)
    % Density variation factor at Zlb
    G32 = this.SW(21)*this.GLOBE7(this.PD(:,5));
    % Diffusive density at Zlb
    DB32 = this.PDM(1,4)*exp(G32)*this.PD(1,5);
    % Diffusive density at Alt
    [D(4),T(2)] = nrlmsise00.DENSU(Z,DB32,TINF,TLB, 32.0,ALPHA(4),T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
    if (MASS == 49)  % THEN
        DD = DD + 2.0*D(4);
    else
        DD = D(4);
    end
    if (this.SW(15) ~= 0.0)
        if (Z <= ALTL(4))
            % Turbopause
            ZH32=this.PDM(3,4);
            % Mixed density at Zlb
            [B32,T(2)] = nrlmsise00.DENSU(ZH32,DB32,TINF,TLB,32.0-XMM,ALPHA(4)-1.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
            % Mixed density at Alt
            [DM32,T(2)] = nrlmsise00.DENSU(Z,B32,TINF,TLB,XMM,0.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
            ZHM32 = ZHM28;
            % Net density at Alt
            D(4) = nrlmsise00.DNET(D(4),DM32,ZHM32,XMM,32.0);
            % Correction to specified mixing ratio at ground
            RL = log(B28*this.PDM(2,4)/B32);
            HC32 = this.PDM(6,4)*this.PDL(8,2);
            ZC32 = this.PDM(5,4)*this.PDL(7,2);
            D(4) = D(4)*nrlmsise00.CCOR(Z,RL,HC32,ZC32);
        end
        % Correction for general departure from diffusive equilibrium above Zlb
        HCC32 = this.PDM(8,4)*this.PDL(23,2);
        HCC232 = this.PDM(8,4)*this.PDL(23,1);
        ZCC32 = this.PDM(7,4)*this.PDL(22,2);
        RC32 = this.PDM(4,4)*this.PDL(24,2)*(1.0+this.SW(1)*this.PDL(24,1)*(this.F107A-150.0));
        % Net density corrected at Alt
        D(4) = D(4)*nrlmsise00.CCOR2(Z,RC32,HCC32,ZCC32,HCC232);
    end
end
   
% AR DENSITY
if (MASS == 40 || MASS >= 48)
    % Density variation factor at Zlb
    G40= this.SW(21)*this.GLOBE7(this.PD(:,6));
    % Diffusive density at Zlb
    DB40 = this.PDM(1,5)*exp(G40)*this.PD(1,6);
    % Diffusive density at Alt
    [D(5),T(2)] = nrlmsise00.DENSU(Z,DB40,TINF,TLB,40.0,ALPHA(5),T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
    DD = D(5);
    if ( (Z <= ALTL(5)) && (this.SW(15) ~= 0.0 ))
        % Turbopause
        ZH40=this.PDM(3,5);
        % Mixed density at Zlb
        [B40,T(2)] = nrlmsise00.DENSU(ZH40,DB40,TINF,TLB,40.-XMM,ALPHA(5)-1.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        % Mixed density at Alt
        [DM40,T(2)] = nrlmsise00.DENSU(Z,B40,TINF,TLB,XMM,0.,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        ZHM40 = ZHM28;
        % Net density at Alt
        D(5) = nrlmsise00.DNET(D(5),DM40,ZHM40,XMM,40.0);
        % Correction to specified mixing ratio at ground
        RL = log(B28*this.PDM(2,5)/B40);
        HC40 = this.PDM(6,5)*this.PDL(10,2);
        ZC40 = this.PDM(5,5)*this.PDL(9,2);
        % Net density corrected at Alt
        D(5) = D(5)*nrlmsise00.CCOR(Z,RL,HC40,ZC40);
    end
end



%  HYDROGEN DENSITY
if (MASS == 1 || MASS >= 48)
    % Density variation factor at Zlb
    G1 = this.SW(21)*this.GLOBE7(this.PD(:,7));
    % Diffusive density at Zlb
    DB01 = this.PDM(1,6)*exp(G1)*this.PD(1,7);
    % Diffusive density at Alt
    [D(7),T(2)]=nrlmsise00.DENSU(Z,DB01,TINF,TLB,1.,ALPHA(7),T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
    DD = D(7);
    if ( (Z <= ALTL(7)) && (this.SW(15) ~= 0.0) )
        % Turbopause
        ZH01 = this.PDM(3,6);
        % Mixed density at Zlb
        [B01,T(2)] = nrlmsise00.DENSU(ZH01,DB01,TINF,TLB,1.-XMM,ALPHA(7)-1.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        % Mixed density at Alt
        [DM01,T(2)] = nrlmsise00.DENSU(Z,B01,TINF,TLB,XMM,0.,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        ZHM01 = ZHM28;
        % Net density at Alt
        D(7) = nrlmsise00.DNET(D(7),DM01,ZHM01,XMM,1.0);
        % Correction to specified mixing ratio at ground
        RL = log(B28*this.PDM(2,6)*abs(this.PDL(18,2))/B01);
        HC01 = this.PDM(6,6)*this.PDL(12,2);
        ZC01 = this.PDM(5,6)*this.PDL(11,2);
        D(7) = D(7)*nrlmsise00.CCOR(Z,RL,HC01,ZC01);
        % Chemistry correction
        HCC01 = this.PDM(8,6)*this.PDL(20,2); % mnoah - check this index - should it be this.PDL(20,2) ????
        ZCC01 = this.PDM(7,6)*this.PDL(19,2);
        RC01 = this.PDM(4,6)*this.PDL(21,2);
        % Net density corrected at Alt
        D(7) = D(7)*nrlmsise00.CCOR(Z,RC01,HCC01,ZCC01);
    end
end
      
% ATOMIC NITROGEN DENSITY
if (MASS == 14 || MASS >= 48)
    % Density variation factor at Zlb
    G14 = this.SW(21)*this.GLOBE7(this.PD(:,8));
    % Diffusive density at Zlb
    DB14 = this.PDM(1,7)*exp(G14)*this.PD(1,8);
    % Diffusive density at Alt
    [D(8),T(2)] = nrlmsise00.DENSU(Z,DB14,TINF,TLB,14.0,ALPHA(8),T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
    DD = D(8);
    if ( (Z <= ALTL(8)) || (this.SW(15) ~= 0.0) )
        % Turbopause
        ZH14 = this.PDM(3,7);
        % Mixed density at Zlb
        [B14,T(2)] = nrlmsise00.DENSU(ZH14,DB14,TINF,TLB,14.0-XMM,ALPHA(8)-1.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        % Mixed density at Alt
        [DM14,T(2)] = nrlmsise00.DENSU(Z,B14,TINF,TLB,XMM,0.0,T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
        ZHM14 = ZHM28;
        % Net density at Alt
        D(8) = nrlmsise00.DNET(D(8),DM14,ZHM14,XMM,14.0);
        % Correction to specified mixing ratio at ground
        RL = log(B28*this.PDM(2,7)*abs(this.PDL(3,1))/B14);
        HC14 = this.PDM(6,7)*this.PDL(2,1);
        ZC14 = this.PDM(5,7)*this.PDL(1,1);
        D(8) = D(8)*nrlmsise00.CCOR(Z,RL,HC14,ZC14);
        % Chemistry correction
        HCC14 = this.PDM(8,7)*this.PDL(5,1);
        ZCC14 = this.PDM(7,7)*this.PDL(4,1);
        RC14 = this.PDM(4,7)*this.PDL(6,1);
        % Net density corrected at Alt
        D(8) = D(8)*nrlmsise00.CCOR(Z,RC14,HCC14,ZCC14);
    end
end
      
% Anomalous OXYGEN DENSITY 
if (MASS == 17 || MASS >= 48)
      G16H = this.SW(21)*this.GLOBE7(this.PD(:,9));
      DB16H = this.PDM(1,8)*exp(G16H)*this.PD(1,9);
      THO = this.PDM(10,8)*this.PDL(7,1);
      [DD,T(2)] = nrlmsise00.DENSU(Z,DB16H,THO,THO,16.0,ALPHA(9),T(2),this.PTM(6),S,this.MN1,this.ZN1,this.TN1,this.TGN1, this.RE, this.GSURF);
      ZSHT = this.PDM(6,8);
      ZMHO = this.PDM(5,8);
      ZSHO = this.SCALH(ZMHO,16.0,THO);
      D(9) = DD*exp(-ZSHT/ZSHO*(exp(-(Z-ZMHO)/ZSHT)-1.0));
end        
          
% TOTAL MASS DENSITY
if (MASS >= 48)
    D(6) = 1.66E-24*(4.0*D(1)+16.0*D(2)+28.0*D(3)+32.0*D(4)+40.0*D(5)+D(7)+14.0*D(8));
    DB48 = 1.66E-24*(4.0*DB04+16.0*DB16+28.0*DB28+32.0*DB32+40.0*DB40+DB01+14.0*DB14);
end

%       GO TO 90
% %       TEMPERATURE AT ALTITUDE
%    50 CONTINUE
       Z = abs(this.ALT);
       [DDUM,T(2)] = nrlmsise00.DENSU(Z, 1.0, TINF, TLB, 0.0, 0.0, T(2), this.PTM(6), S, this.MN1, this.ZN1, this.TN1, this.TGN1, this.RE, this.GSURF);
%    90 CONTINUE
   
% ADJUST DENSITIES FROM CGS TO KGM
if (this.IMR == 1)  % THEN
    for I=1:9
        D(I)=D(I)*1.E6;
    end
    D(6)=D(6)/1000.0;
end
this.LAST_ALT_GTS7=this.ALT;
      
end