function [T, a, p, rho, nu, mu] = NRLMSISE00_atmos_model(height)
    % Function to compute atmospheric properties using the NRLMSISE-00 model.
    %
    % Inputs:
    %   height - Altitude in meters
    % Outputs:
    %   T  - Temperature in Kelvin
    %   a  - Speed of sound in m/s
    %   p  - Pressure in Pascals
    %   rho - Density in kg/m^3
    %   nu - Kinematic viscosity in m^2/s
    %   mu - Dynamic viscosity in Pa.s (kg/(m*s))
    %
    % The function uses the NRLMSISE-00 atmospheric model to calculate
    % temperature, pressure, density, speed of sound, and viscosities in SI units.


    IDAY = 172;
    SEC = 1.5*3600;
    ALT = height/1000;
    GLAT = 60;
    GLONG = 90; %360-70;
    F107A = 150;
    F107 = 150;
    AP = 4*ones(7,1);  
    MASS = 48;   % 


    % Run the NRLMSISE-00 atmospheric model
    % Source : https://www.mathworks.com/matlabcentral/fileexchange/71629-atmosphere-profiles-sonde-nrlmsise-00?s_tid=FX_rc2_behav
    myNRLMSISE00 = nrlmsise00(IDAY,SEC,ALT,GLAT,GLONG,F107A,F107,AP,MASS);
    calculated = myNRLMSISE00.calculateProfile(ALT);
    
    rho = calculated.rho * 1e3;
    T = calculated.T_neutral;

    % Constants for calculations
    R = 287.053; % Specific gas constant for air in J/(kg*K)
    gamma = 1.4; % Specific heat ratio for air

    % Compute pressure using ideal gas law (p = rho * R_specific * T)
    p = rho * R * T; % Pressure in Pascals

    % Compute speed of sound (a = sqrt(gamma * R_specific * T))
    a = sqrt(gamma * R * T); % Speed of sound in m/s

    % Compute dynamic viscosity using Sutherland's formula (mu)
    mu = 1.716e-5 * (T / 273.15)^(3/2) * (384.15 / (T + 111)); % Dynamic viscosity in Pa.s

    % Compute kinematic viscosity (nu = mu / rho)
    nu = mu / rho; % Kinematic viscosity in m^2/s
end
