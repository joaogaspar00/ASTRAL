%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gravitic_force.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function computes the gravitational force acting on the vehicle
% as a function of its altitude. The force is calculated based on Newton's
% law of universal gravitation, taking into account the distance from the
% center of the Earth.
%
% Inputs:
% - VEHICLE: structure containing the current vehicle state, including mass
%            and position in the vertical (z) direction.
% - EARTH: structure containing planetary constants:
%          - G: gravitational constant [m^3/kg/s^2]
%          - M: mass of the Earth [kg]
%          - R: mean radius of the Earth [m]
%
% Output:
% - F_g: gravitational force vector [3x1] in the body frame (z-negative)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function F_g = gravitic_force(VEHICLE, EARTH)

% Distance from the center of the Earth
r = EARTH.R + VEHICLE.position(3);

% Compute the gravitational force in vector form
F_g = [0; 0; -(EARTH.G * EARTH.M * VEHICLE.mass) / (r^2)]; 

end