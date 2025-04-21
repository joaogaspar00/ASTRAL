%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% force_torque_integration.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function integrates the aerodynamic forces and torques over the length 
% of a blade using different numerical integration methods. The resulting 
% forces and torques are then computed and returned for further analysis. 
% The user can choose from various integration methods such as the Rectangle 
% rule, Trapezoidal rule, Simpson's rule, or Boole's rule, depending on 
% the specified integrator method in the input `SIM`.
%
% Inputs:
% - SIM: A structure containing simulation settings, including the 
%        selected blade integrator method (e.g., "Rectangle", "Trapezoidal", 
%        "Simpson", or "Boole").
% - BLADE: A structure containing blade properties, including the position 
%          of the blade sections (BLADE.pos_sec) and other relevant parameters.
% - dF_i: A 3xN matrix of aerodynamic forces (in the inertial reference frame), 
%         where N is the number of blade sections.
% - dT_r: A 3xN matrix of aerodynamic torques (in the rotor reference frame), 
%         where N is the number of blade sections.
%
% Outputs:
% - Force_blade: A 3x1 vector containing the total aerodynamic force on the blade 
%                in the x, y, and z directions, respectively.
% - Torque_blade: A 3x1 vector containing the total aerodynamic torque on the blade 
%                 in the x, y, and z directions, respectively.
%
% Errors:
% - If the integration method specified in `SIM.blade_integrator` is not 
%   recognized, an error message is displayed.
%
% Methodology:
% The function applies the specified integration method (Rectangle, Trapezoidal, 
% Simpson, or Boole) to numerically integrate the aerodynamic forces and torques 
% over the blade sections. The results are stored in the `Force_blade` and 
% `Torque_blade` outputs.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Force_blade, Torque_blade] = force_torque_integration(SIM, BLADE, dF_i, dT_r)

    % Check the selected integration method in SIM
    if strcmp(SIM.blade_integrator, "Rectangle")
        % Use the Rectangle method for integration
        [f_x, ~, ~] = rectangle_integration(BLADE.pos_sec(2,:), dF_i(1, :));
        [f_y, ~, ~] = rectangle_integration(BLADE.pos_sec(2,:), dF_i(2, :));
        [f_z, ~, ~] = rectangle_integration(BLADE.pos_sec(2,:), dF_i(3, :));

        [t_x, ~, ~] = rectangle_integration(BLADE.pos_sec(2,:), dT_r(1,:));
        [t_y, ~, ~] = rectangle_integration(BLADE.pos_sec(2,:), dT_r(2,:));
        [t_z, ~, ~] = rectangle_integration(BLADE.pos_sec(2,:), dT_r(3,:));

    elseif strcmp(SIM.blade_integrator, "Trapezoidal")
        % Use the Trapezoidal method for integration
        [f_x, ~, ~] = trapezoidal_integration(BLADE.pos_sec(2,:), dF_i(1, :));
        [f_y, ~, ~] = trapezoidal_integration(BLADE.pos_sec(2,:), dF_i(2, :));
        [f_z, ~, ~] = trapezoidal_integration(BLADE.pos_sec(2,:), dF_i(3, :));

        [t_x, ~, ~] = trapezoidal_integration(BLADE.pos_sec(2,:), dT_r(1,:));
        [t_y, ~, ~] = trapezoidal_integration(BLADE.pos_sec(2,:), dT_r(2,:));
        [t_z, ~, ~] = trapezoidal_integration(BLADE.pos_sec(2,:), dT_r(3,:));

    elseif strcmp(SIM.blade_integrator, "Simpson")
        % Use the Simpson method for integration
        [f_x, ~, ~] = simpson_integration(BLADE.pos_sec(2,:), dF_i(1, :));
        [f_y, ~, ~] = simpson_integration(BLADE.pos_sec(2,:), dF_i(2, :));
        [f_z, ~, ~] = simpson_integration(BLADE.pos_sec(2,:), dF_i(3, :));

        [t_x, ~, ~] = simpson_integration(BLADE.pos_sec(2,:), dT_r(1,:));
        [t_y, ~, ~] = simpson_integration(BLADE.pos_sec(2,:), dT_r(2,:));
        [t_z, ~, ~] = simpson_integration(BLADE.pos_sec(2,:), dT_r(3,:));

    elseif strcmp(SIM.blade_integrator, "Boole")
        % Use the Boole method for integration
        [f_x, ~, ~] = boole_integration(BLADE.pos_sec(2,:), dF_i(1, :));
        [f_y, ~, ~] = boole_integration(BLADE.pos_sec(2,:), dF_i(2, :));
        [f_z, ~, ~] = boole_integration(BLADE.pos_sec(2,:), dF_i(3, :));

        [t_x, ~, ~] = boole_integration(BLADE.pos_sec(2,:), dT_r(1,:));
        [t_y, ~, ~] = boole_integration(BLADE.pos_sec(2,:), dT_r(2,:));
        [t_z, ~, ~] = boole_integration(BLADE.pos_sec(2,:), dT_r(3,:));

    else
        % Error handling for unrecognized integrator methods
        error("Integration rule not defined")
    end

    % Combine the integrated force components into the result vector
    Force_blade = [f_x; f_y; f_z];
    
    % Combine the integrated torque components into the result vector
    Torque_blade = [t_x; t_y; t_z];

end
