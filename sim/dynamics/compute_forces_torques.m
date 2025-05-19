%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute_forces_torques.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function computes the total forces and torques acting on the vehicle.
% It considers gravity, aerodynamic drag (currently zero), and rotor forces.
% The rotor contributions are included only after deployment time and if
% the rotor is flagged as open. The rotor torque is returned as scalar (z-axis).
%
% Inputs:
% - SIM: structure containing simulation configuration and flags
% - TIME: structure with time step size and clock management
% - VEHICLE: structure with initial state
% - ROTOR: structure with rotor state and properties
% - BLADE: structure describing the rotor blades
% - EARTH: structure with environmental constants
% - ATMOSPHERE: structure containing atmospheric properties at current altitude
%
% Outputs:
% - F_total: total force vector
% - F_rotor: force vector from rotor
% - F_gravity: gravitational force vector
% - F_drag_cilinder: aerodynamic drag force
% - T_total: total torque vector
% - T_rotor: scalar torque from rotor about z-axis
% - rotorIsOpen: flag indicating whether rotor is active at this time step
% - rotor_distribution_data: struct storing rotor distribution (azimuthal)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [F_total, F_rotor, F_gravity, F_drag, ...
          T_total, T_rotor, rotor_distribution_data] = ...
          compute_forces_torques(SIM, VEHICLE, ROTOR, BLADE, ATMOSPHERE, EARTH)

% Default initialization
F_rotor = [0; 0; 0];
T_rotor = [0; 0; 0];
F_drag = [0; 0; 0];

% Compute gravitational force
F_gravity = gravitic_force(VEHICLE, EARTH);

% Compute drag force
if VEHICLE.dragMode
    F_drag = drag_force(VEHICLE, ATMOSPHERE);
end

% Empty rotor distribution structure
rotor_distribution_data = RotorAzimutalDistribution([], []);

% Activate rotor if deployment time has passed
if ROTOR.rotorIsOpen
    [F_rotor, T_rotor, rotor_distribution_data] = ...
        compute_rotor_force(SIM, VEHICLE, ROTOR, BLADE, ATMOSPHERE);
end

% Total force includes gravity, rotor (if active), and aerodynamic drag
F_total = F_gravity + F_drag + F_rotor;

% Total torque includes only rotor torque (x and y components kept, z zeroed)
% T_total = T_rotor;
% T_total(2) = 0;
% T_total(3) = 0;

T_total =[0; 0; 0];

% Return only the z-component of rotor torque as scalar
T_rotor = T_rotor(3);
end

