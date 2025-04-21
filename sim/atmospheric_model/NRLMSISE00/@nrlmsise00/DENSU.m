%% *DENSU*
%% *function*
function [DD,TZ] = DENSU(ALT,DLB,TINF,TLB,XM,ALPHA,TZ0,tZLB,S2,tMN1,tZN1,tTN1,tTGN1,RE,GSURF)
%% *purpose*
%  To calculate Temperature and Density Profiles for altitudes
%  above 72.5 km (upper atmosphere)
%% *inputs*
%
%  ALT   - [km] altitude of the air parcel
%  DLB   - [cm^-3] density at a reference lower boundary altitude  
%  TINF  - [K] 
%  TLB   - [K] temperature at a reference lower boundary altitude
%  XM    - [g/mol] mean molecular molar mass of air particle OR full mixed
%                  molecular weight ???
%  ALPHA - [unitless] species dependent exponential factor
%  TZ0   - [K] a temperature that is not really used but somehow required
%              by this code
%
%  Upper Stratosphere and Mesosphere
%  Inverse temperature a linear function of spherical harmonics
%  tMN1  - dimension of ZN1 and TN1 (class constant)
%  tZN1  - [km] Altitude of nodes (class constant)
%  tTN1  - [K] Temperature at nodes (scenario variable)
%  tTGN1 - [K] (2x1) Temperature gradients at end nodes (scenario variable)
%
%  Earth size and shape
%  RE    - [km] effective Earth radius
%  GSURF - [cm/s^2 or gal] acceleration due to gravity at this latitude
%
%% *outputs*
%  DD - [cm^-3] density or temperature at altitude (XM~=0)
%  TZ - [K] temperature at altitude ALT (XM==0)
%% *history*
%  when     who   why
%  20190602 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*

XS = zeros(5,1);YS = zeros(5,1);Y2OUT = zeros(5,1);
TZ = TZ0;

RGAS = 831.4;
%ZETA(ZZ,ZL)=(ZZ-ZL)*(RE+ZL)/(RE+ZZ);
%CCCCCWRITE(6,*) 'DB',ALT,DLB,TINF,TLB,XM,ALPHA,ZLB,S2,MN1,ZN1,TN1
DD=1.0;
% Joining altitude of Bates and spline
ZA=tZN1(1);
Z=max([ALT,ZA]);
% Geopotential altitude difference from ZLB
ZG2=nrlmsise00.ZETA(Z,tZLB);
% Bates temperature
TT=TINF-(TINF-TLB)*exp(-S2*ZG2);
TA=TT;
TZ=TT;
DD=TZ;
if (ALT < ZA)
    % CALCULATE TEMPERATURE BELOW ZA
    % Temperature gradient at ZA from Bates profile
    DTA=(TINF-TA)*S2*((RE+tZLB)/(RE+ZA))^2;
    tTGN1(1)=DTA;
    tTN1(1)=TA;
    Z=max([ALT,tZN1(tMN1)]);
    MN=tMN1;
    Z1=tZN1(1);
    Z2=tZN1(MN);
    T1=tTN1(1);
    T2=tTN1(MN);
    % Geopotental difference from Z1
    ZG = nrlmsise00.ZETA(Z,Z1);
    ZGDIF = nrlmsise00.ZETA(Z2,Z1);
    % Set up spline nodes
    for K=1:MN
        XS(K) = nrlmsise00.ZETA(tZN1(K),Z1)/ZGDIF;
        YS(K) = 1.0/tTN1(K);
    end
    
    % End node derivatives
    YD1=-tTGN1(1)/(T1*T1)*ZGDIF;
    YD2=-tTGN1(2)/(T2*T2)*ZGDIF*((RE+Z2)/(RE+Z1))^2;
    % Calculate spline coefficients
    Y2OUT = nrlmsise00.SPLINE(XS,YS,MN,YD1,YD2);
    X=ZG/ZGDIF;
    Y = nrlmsise00.SPLINT(XS,YS,Y2OUT,MN,X);
    % temperature at altitude
    TZ=1.0/Y;
    DD=TZ;
end

if (XM == 0.0)
    return;
end

% CALCULATE DENSITY ABOVE ZA
GLB=GSURF/(1.+tZLB/RE)^2;
GAMMA=XM*GLB/(S2*RGAS*TINF);
expL=exp(-S2*GAMMA*ZG2);
if (expL> 50 || TT<= 0.0)
    expL=50.0;
end
% Density at altitude
DENSA=DLB*(TLB/TT)^(1.+ALPHA+GAMMA)*expL;
DD=DENSA;
if (ALT>= ZA)
    return;
end

% CALCULATE DENSITY BELOW ZA
GLB=GSURF/(1.+Z1/RE)^2;
GAMM=XM*GLB*ZGDIF/RGAS;
% integrate spline temperatures
YI = nrlmsise00.SPLINI(XS,YS,Y2OUT,MN,X);
expL=GAMM*YI;
if (expL> 50.0 || TZ<= 0.0)
    expL=50.0;
end

% Density at altitude
DD=DD*(T1/TZ)^(1.0+ALPHA)*exp(-expL);

end
