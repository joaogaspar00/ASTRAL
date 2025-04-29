%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MachNumber_func.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function calculates the Mach number (Ma) given the velocity and temperature
% using the formula:
% 
%                   Ma = V / sqrt(gamma * R * T)
%
% where:
% - V: Velocity of the fluid (m/s)
% - T: Temperature of the fluid (K)
% - gamma: Ratio of specific heats (1.4 for air)
% - R: Specific gas constant for dry air (287.053 J/kg·K)
%
% Inputs:
% - V: Velocity of the fluid [m/s]
% - ATMOSPHERE: structure with atmospheric conditions
%
% Outputs:
% - Ma: Mach number (dimensionless)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Ma = MachNumber(V, ATMOSPHERE)

Ma = V / (sqrt( 1.4 * 287.053* ATMOSPHERE.temperature));

end