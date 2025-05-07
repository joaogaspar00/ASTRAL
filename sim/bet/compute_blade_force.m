%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute_blade_force.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function computes the aerodynamic forces and torques acting on a
% single blade of a rotor, based on the local flow conditions at each
% blade section. The method considers inflow velocity, induced velocity,
% rotation, Prandtl tip loss correction, and aerodynamic coefficients
% obtained from external models (e.g., NeuralFoil or Hybrid).
%
% The result includes force and torque in the inertial frame, and detailed
% per-section distributions used for debugging or visualization.
%
% Inputs:
% - index_blade: index of the current blade (azimuthal position)
% - SIM: structure with simulation settings and selected aerodynamic model
% - VEHICLE: structure with vehicle state in the current simulation step
% - ROTOR: structure with rotor kinematics and transformations
% - BLADE: structure with geometry and aerodynamic data of the blade
% - ATMOSPHERE: structure with atmospheric conditions
%
% Outputs:
% - Force_blade: [3x1] total aerodynamic force on the blade in inertial frame
% - Torque_blade: [3x1] total aerodynamic torque of the blade in rotor frame
% - blade_distribution: BladeDistribution object with per-section details
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Force_blade, Torque_blade, blade_distribution] = ... 
    compute_blade_force(index_blade, SIM, VEHICLE, ROTOR, BLADE, ATMOSPHERE)

% Preallocate memory for aerodynamic variables along the blade span
total_velocity = zeros(1, BLADE.No_elements+1); % Velocity norm
dL = zeros(1, BLADE.No_elements+1); % Lift
dD = zeros(1, BLADE.No_elements+1); % Drag
phi = zeros(1, BLADE.No_elements+1); % Inflow angle
alpha = zeros(1, BLADE.No_elements+1); % Angle of attack
element_state = zeros(1, BLADE.No_elements+1); % Blade element flow regime

Ma = zeros(1, BLADE.No_elements+1); % Mach number
Re = zeros(1, BLADE.No_elements+1); % Reynolds number
Cl = zeros(1, BLADE.No_elements+1); % Lift coefficient
Cd = zeros(1, BLADE.No_elements+1); % Drag coefficient

U_T = zeros(1, BLADE.No_elements+1); % Tangential velocity
U_R = zeros(1, BLADE.No_elements+1); % Radial velocity (unused here)
U_P = zeros(1, BLADE.No_elements+1); % Axial (parallel) velocity

v_i = zeros(1, BLADE.No_elements+1); % Induced velocity at each section
flow_mode = zeros(1, BLADE.No_elements+1); % Forward or reverse flow flag

dF_a = zeros(3, BLADE.No_elements+1); % Element force in aerodynamic frame
dF_e = zeros(3, BLADE.No_elements+1); % Element force in element frame
dF_b = zeros(3, BLADE.No_elements+1); % Element force in blade frame
dF_r = zeros(3, BLADE.No_elements+1); % Element force in rotor frame
dF_i = zeros(3, BLADE.No_elements+1); % Element force in inertial frame

dT_r = zeros(3, BLADE.No_elements+1); % Element torque in rotor frame

% Rotor angular velocity vector
vec_angular_velocity = [0; 0; ROTOR.velocity];

% fprintf("\n\t\tBlade position - %.2f\n", ROTOR.azimutal_positions(index_blade))
% Loop over all blade elements (radial sections)
for i = 1:length(BLADE.pos_sec)

    % Induced velocity is assumed constant for now
    v_i(i) = ROTOR.induced_velocity;
    v_i_vec = [0; 0; ROTOR.induced_velocity];

    % Relative rotational velocity at blade element
    VR_e = cross(BLADE.pos_sec(:, i), vec_angular_velocity);
    
    % Effective velocity in blade element frame
    V_e = VEHICLE.velocity_b + VR_e - v_i_vec + ATMOSPHERE.wind_velocity_b;
    
    % Decompose effective velocity
    U_T(i) = V_e(1);
    U_R(i) = V_e(2);
    U_P(i) = V_e(3);

    % fprintf("\t Ut = %.2f |  Ur = %.2f |  Up = %.2f\n", U_T(i), U_R(i),U_P(i))
    
    % Determine flow direction (0 = forward, 1 = reversed)
    flow_mode(i) = U_T(i) < 0;

    % Compute magnitude of relative velocity
    total_velocity(i) = sqrt(U_T(i)^2 + U_P(i)^2);
    
    % Compute angle of attack and inflow angle
    [alpha(i), phi(i), element_state(i)] = getFlowAngles(U_T(i), U_P(i), BLADE.theta(i));

    % Compute Mach and Reynolds numbers
    Ma(i) = MachNumber(total_velocity(i), ATMOSPHERE);
    Re(i) = ReynoldsNumber_func(i, total_velocity(i), BLADE, ATMOSPHERE);

    % Retrieve aerodynamic coefficients
    if total_velocity(i) == 0 || isnan(total_velocity(i))
        Cl(i) = 0; Cd(i) = 0;
    else
        if strcmp(SIM.AerodynamicModelSelector, "NeuralFoil")
            [Cl(i), Cd(i), ~] = NeuralFoil(BLADE.airfoil_name, Re(i), 0, alpha(i));
        elseif strcmp(SIM.AerodynamicModelSelector, "Hybrid")
            [Cl(i), Cd(i), ~] = AerodynamicModel(alpha(i), Re(i), BLADE.airfoil_data, false);
        else
            error("Invalid aerodynamic model selected.");
        end
    end

    % Compute elemental lift and drag forces
    dL(i) = 0.5 * ATMOSPHERE.density * (total_velocity(i)^2) * Cl(i) * BLADE.chord(i);
    dD(i) = 0.5 * ATMOSPHERE.density * (total_velocity(i)^2) * Cd(i) * BLADE.chord(i);

    % Force vector in aerodynamic frame (X = Drag, Z = Lift)
    dF_a(:, i) = [dD(i); 0; dL(i)];

    
    % fprintf("\t\t [%d|%d] Vi = %.2f | U [%.2f %.2f %.2f] | |U| = %.2f | Theta = %.2f | Phi = %.2f | Alpha = %.2f |  Re = %.2f |  Ma = %.2f |  Cl = %.2f |  Cd = %.2f\n", ...
    %     i, flow_mode(i), ROTOR.induced_velocity, V_e, total_velocity(i), BLADE.theta(i), phi(i), alpha(i), Re(i), Ma(i), Cl(i), Cd(i))    
end

% Apply Prandtl tip loss correction if enabled
if BLADE.prandtlTipLosses
    f_prandtl = prandtl_function(phi(1), phi(end), ROTOR, BLADE);
    dF_a(3, :) = f_prandtl .* dF_a(3, :) ;
else
    % this lines is used to filled f_prandtl for saving variables
    f_prandtl = ones(1, length(dF_a(3, :) ));
end

% Apply tip correction to aerodynamic forces


% fprintf("\n")
% Rotate from aerodynamic to element frame
for i = 1:length(BLADE.pos_sec)
    R_a_e = rotationMatrix_generator(0, phi(:, i), 0, "deg");

    % disp(phi(:, i))
    % disp(R_a_e)

    dF_e(:, i) = R_a_e * dF_a(:, i);

    dF_b(:, i) = dF_e(:, i);

    dF_r(:, i) = ROTOR.R_b_r(:, :, index_blade) * dF_b(:, i);

    dF_i(:, i) = ROTOR.R_r_i * dF_r(:, i);

    dT_r(:, i) = cross(BLADE.pos_sec_r(:, i, index_blade), dF_r(:, i));

    % fprintf("\t\t\t [%d] dFa [%.2f %.2f %.2f] dFe [%.2f %.2f %.2f] dFb [%.2f %.2f %.2f] dFi [%.2e %.2e %.2e] - dTr [%.2e %.2e %.2e] \n", i, dF_a(:, i), dF_e(:, i), dF_r(:, i), dF_i(:, i), dT_r(:, i));
end
% fprintf("\n")

% Compute torque from position vector and force in rotor frame
for i = 1:length(BLADE.pos_sec)
    
end

% Integrate forces and torques over the blade
[Force_blade, Torque_blade] = force_torque_integration(SIM, BLADE, dF_i, dT_r);

% Pack all per-element variables into a distribution object for output
blade_distribution = BladeDistribution(total_velocity, dL, dD, phi, alpha, BLADE.theta, ...
                                       element_state, Ma, Re, Cl, Cd, ...
                                       U_T, U_R, U_P, flow_mode, v_i, ...
                                       dF_a, dF_e, dF_i, dT_r, ...
                                       f_prandtl);
end
