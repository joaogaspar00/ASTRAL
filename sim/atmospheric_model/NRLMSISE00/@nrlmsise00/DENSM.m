%% *DENSM*
%% *function*
function [DD,TZ] = DENSM(ALT,D0,XM,tMN3,tZN3,tTN3,tTGN3,tMN2,tZN2,tTN2,tTGN2,RE,GSURF)
%% *purpose*
%  To calculate Temperature and Density Profiles for geopotential altitudes
%  between 0 and 72.5 km (lower atmosphere)
%% *inputs*
%
%  ALT  - [km] altitude of the air parcel
%  D0   - [cm^-3] density  
%  XM   - [g/mol] mean molecular molar mass of air particle OR full mixed
%                  molecular weight ???
% 
%  LOWER STRATOSPHERE AND TROPOSPHERE (below zn3(0))
%  Inverse temperature a linear function of spherical harmonics
%  MN3  - dimension of ZN3 and TN3 (class constant)
%  ZN3  - [km] Altitude of nodes (class constant)
%  TN3  - [K] Temperature at nodes (scenario variable)
%  TGN3 - [K] (2x1) Temperature gradients at end nodes (scenario variable)
%
%  LOWER MESOSPHERE/UPPER STRATOSPHERE (between zn3(0) and zn2(0))
%  Inverse temperature a linear function of spherical harmonics
%  MN2  - dimension of ZN2 and TN2 (class constant)
%  ZN2  - [km] Altitude of nodes (class constant)
%  TN2  - [K] Temperature at nodes  (scenario variable)
%  TGN2 - [K] (2x1) Temperature gradients at end nodes (scenario variable) 
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

RGAS = 831.4;

%% *default values of density and temperature*
DD = D0;  % [cm^-3]
% TZ = TZ0; % [K]

%% *range check the altitude*
% Is above the lower mesosphere?  If it is above zn2 lower mesosphere to 
% upper stratosphere region (default is 72.5 km), then this routine
% is not applicable.
if (ALT > tZN2(1))
    % should not reach this condition
    error(['[ERROR] Called DENSM for altitude = ' num2str(ALT) ' km']);
end

%% *Stratosphere/Mesosphere Temperature*
Z = max([ALT,tZN2(tMN2)]);
MN = tMN2;            % [integer] dimensions of the arrays
Z1 = tZN2(1);         % [km]
Z2 = tZN2(MN);        % [km]
T1 = tTN2(1);         % [K]
T2 = tTN2(MN);        % [K]
ZG = nrlmsise00.ZETA(Z,Z1);     % [km]
ZGDIF = nrlmsise00.ZETA(Z2,Z1); % [km]

%% *set up spline nodes*
XS = zeros(MN,1);
YS = zeros(MN,1);
for K=1:MN
    XS(K) = nrlmsise00.ZETA(tZN2(K),Z1)/ZGDIF;
    YS(K) = 1.0/tTN2(K);
end
YD1 = -(tTGN2(1)/(T1*T1))*ZGDIF;
YD2 = -(tTGN2(2)/(T2*T2))*ZGDIF*((RE+Z2)/(RE+Z1))^2;

%% *calculate spline coefficients*

Y2OUT = nrlmsise00.SPLINE(XS,YS,MN,YD1,YD2);
X = ZG/ZGDIF;
Y = nrlmsise00.SPLINT(XS,YS,Y2OUT,MN,X);

%% *calculate temperature at altitude*
TZ = 1.0/Y; % [K]

if (XM ~= 0.0)
    
    % calculate Stratosphere/Mesosphere density
    GLB = GSURF/((1.0+Z1/RE)^2);
    GAMM = XM*GLB*ZGDIF/RGAS;
    
    % integrate temperature profile
    YI = nrlmsise00.SPLINI(XS,YS,Y2OUT,MN,X);
    expL = GAMM*YI;
    if (expL > 50.0)
        expL = 50.0;
    end
    
    % density at altitude
    DD = DD*(T1/TZ)*exp(-expL);
    
end

if (ALT <= tZN3(1))
    
    % TROPOSPHERE/STRATOSPHERE TEMPERATURE
    Z = ALT;
    MN = tMN3;
    Z1 = tZN3(1);
    Z2 = tZN3(MN);
    T1 = tTN3(1);
    T2 = tTN3(MN);
    ZG = nrlmsise00.ZETA(Z,Z1);
    ZGDIF = nrlmsise00.ZETA(Z2,Z1);
    
    % Set up spline nodes
    for K=1:MN
        XS(K) = nrlmsise00.ZETA(tZN3(K),Z1)/ZGDIF;
        YS(K) = 1.0/tTN3(K);
    end
    YD1 = -tTGN3(1)/(T1*T1)*ZGDIF;
    YD2 = -tTGN3(2)/(T2*T2)*ZGDIF*((RE+Z2)/(RE+Z1))^2;
    % Calculate spline coefficients
    Y2OUT = nrlmsise00.SPLINE(XS,YS,MN,YD1,YD2);
    X = ZG/ZGDIF;
    Y = nrlmsise00.SPLINT(XS,YS,Y2OUT,MN,X);
    % *temperature at altitude*
    TZ=1.0/Y;
    
    if (XM ~= 0.0)
        % CALCULATE TROPOSPHERIC/STRATOSPHERE DENSITY
        GLB = GSURF/(1.+Z1/RE)^2;
        GAMM = XM*GLB*ZGDIF/RGAS;
        % integrate temperature profile
        YI = nrlmsise00.SPLINI(XS,YS,Y2OUT,MN,X);
        expL=GAMM*YI;
        if (expL > 50.0)
            expL = 50.0;
        end
        % density at altitude
        DD=DD*(T1/TZ)*exp(-expL);
    end
end

end