%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ReynoldsNumber_func.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function calculates the Reynolds number (Re) using the formula:
% 
%                   Re = (rho * V * c) / mu
%
% where:
% - rho: Fluid density (kg/m^3)
% - V: Fluid velocity (m/s)
% - c: Characteristic length (typically the chord length of the airfoil, in meters)
% - mu: Kinematic viscosity of the fluid (m^2/s)
%
% Inputs:
% - V: Fluid velocity [m/s]
% - BLADE: Structure containing the blade's characteristics
% - ATMOSPHERE: structure with atmospheric conditions
%
% Outputs:
% - Re: Reynolds number (dimensionless)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Re = ReynoldsNumber_func(index, V, BLADE, ATMOSPHERE)

    Re = ATMOSPHERE.density * V * BLADE.chord(index) / ATMOSPHERE.dynamic_viscosity;

end