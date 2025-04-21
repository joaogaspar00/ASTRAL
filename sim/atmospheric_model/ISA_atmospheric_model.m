function [T, a, p, rho, nu, mu] = ISA_atmospheric_model(height)
    % Function to compute atmospheric properties using the International
    % Standard Atmosphere (ISA) model.
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
    % The 'atmosisa' function provides properties directly in SI units.

    % Call the ISA model with extended range enabled
    [T, a, p, rho, nu, mu] = atmosisa(height, 'extended', true);

    % Outputs are already in SI units:
    %   T (K), a (m/s), p (Pa), rho (kg/m^3), nu (m^2/s), mu (kg/(m*s))
end