function [T, a, p, rho, nu, mu] = EAM_atmospheric_model(height)
    % Function to compute atmospheric properties using the EAM model.
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
    % The function calculates temperature, pressure, density, speed of sound,
    % and viscosities using the EAM model, with results in SI units.

    gamma = 1.4; % Specific heat ratio for air
    R = 287.053; % Specific gas constant for air in J/(kg*K)

    % Altitude-dependent temperature and pressure calculations
    if height <= 11000
        T = 15.04 - 0.00649 * height;
        p = 101.29 * ((T + 273.15) / 288.08)^5.256 * 1e3; % Convert from kPa to Pa
    elseif height > 11000 && height <= 25000
        T = -56.46;
        p = 22.65 * exp(1.73 - 0.000157 * height) * 1e3; % Convert from kPa to Pa
    else
        T = -131.21 + 0.00299 * height;
        p = 2.488 * ((T + 273.15) / 216.6)^(-11.388) * 1e3; % Convert from kPa to Pa
    end

    T = T + 273.15; % Convert temperature from Celsius to Kelvin

    rho = p / (R * T); % Calculate density in kg/m^3

    a = sqrt(gamma * R * T); % Speed of sound in m/s

    mu = 1.716e-5 * (T / 273.15)^(3/2) * (384.15 / (T + 111)); % Dynamic viscosity in Pa.s

    nu = mu / rho; % Kinematic viscosity in m^2/s
    
end
