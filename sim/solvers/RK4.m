%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RK4.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function numerically integrates the vehicle and rotor dynamics using
% the classical 4th-order Runge-Kutta (RK4) method. It iteratively updates
% the state of the system until the vehicle's vertical position (altitude)
% drops to or below zero or until an external stop condition is triggered.
% The solver includes an inner loop for convergence of the induced velocity
% if the rotor is active ("open").
%
% Inputs:
% - SIM: structure containing simulation configuration and flags
% - TIME: structure with time step size and clock management
% - VEHICLE: structure with initial state
% - ROTOR: structure with rotor state and properties
% - BLADE: structure describing the rotor blades
% - EARTH: structure with environmental constants
%
% Outputs:
% - OUTPUT: structure storing simulation results at each time step
% - rotor_data: structure with rotor distribution data collected during flight
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [OUTPUT, rotor_data] = RK4(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH)

% Initialize the output 
OUTPUT = init_sim_outputs();

% Initialize vehicle and rotor state
VEHICLE.velocity = VEHICLE.InitVelocity;
VEHICLE.position = VEHICLE.InitPosition;
VEHICLE.orientation = VEHICLE.InitOrientation;
VEHICLE.ang_velocity = VEHICLE.InitAngularVelocity;
ROTOR.velocity = 0;
ROTOR.induced_velocity = 0;

% Store per-timestep rotor data (if active)
rotor_data_vec = [];
rotor_data_time = [];

% Constants for RK4
var_constants = [1, 1/2, 1/2, 1];

% Main integration loop
while VEHICLE.position(3) > 0 && ~TIME.stop_flag

    fprintf(">> [%.2f] Altitude: %.4f [V = %.2f | %.2f RPM]\n", ...
        TIME.clock, VEHICLE.position(3), VEHICLE.velocity(3), ROTOR.velocity * 60/(2*pi));

    % Get atmospheric conditions at current state
    ATMOSPHERE = atmosphereModel_selector(TIME, SIM, VEHICLE);

    % Save current state
    CURRENT = struct( ...
        'vehicle_position', VEHICLE.position, ...
        'vehicle_velocity', VEHICLE.velocity, ...
        'vehicle_orientation', VEHICLE.orientation, ...
        'vehicle_ang_velocity', VEHICLE.ang_velocity, ...
        'rotor_velocity', ROTOR.velocity, ...
        'rotor_induced_velocity', ROTOR.induced_velocity, ...
        'clock', TIME.clock);

    vi_convergency = false;
    counter_vi = 1;

    % Loop for convergence of induced velocity if rotor is open
    while ~vi_convergency

        % RK4 integration matrices
        k = zeros(3, 4); % linear acceleration
        l = zeros(3, 4); % linear velocity
        m = zeros(3, 4); % angular acceleration
        n = zeros(3, 4); % angular velocity
        p = zeros(1, 4); % rotor acceleration

        for i = 1:4
            if i == 1
                VEHICLE.velocity = CURRENT.vehicle_velocity;
                VEHICLE.ang_velocity = CURRENT.vehicle_ang_velocity;
                ROTOR.velocity = CURRENT.rotor_velocity;
                SIM.debbug_cmd = false;
            else
                VEHICLE.velocity = CURRENT.vehicle_velocity + var_constants(i-1) * k(:, i-1);
                VEHICLE.ang_velocity = CURRENT.vehicle_ang_velocity + var_constants(i-1) * m(:, i-1);
                ROTOR.velocity = CURRENT.rotor_velocity + var_constants(i-1) * p(i-1);
                SIM.debbug_cmd = false;
            end

            [F_total, F_rotor, F_gravity, F_drag_cilinder, ...
             T_total, T_rotor, rotorIsOpen, rotor_distribution_data] = ...
                compute_forces_torques(SIM, TIME, VEHICLE, ROTOR, BLADE, ATMOSPHERE, EARTH);

            % Rotation matrix for Euler angle derivatives
            phi = VEHICLE.orientation(1);
            theta = VEHICLE.orientation(2);
            RR = [1   tand(theta)*sind(phi)   tand(theta)*cosd(phi);
                  0   cosd(phi)               -sind(phi);
                  0   sind(phi)/cosd(theta)   cosd(phi)/cosd(theta)];

            k(:, i) = (1 / VEHICLE.mass) * F_total;
            m(:, i) = ROTOR.II_inv * (T_total - cross(VEHICLE.ang_velocity, ROTOR.II * VEHICLE.ang_velocity));

            k(:, i) = k(:, i) * TIME.dt;
            m(:, i) = m(:, i) * TIME.dt;
            p(i) = (T_rotor / ROTOR.II(3, 3)) * TIME.dt;           

            if i == 1
                l(:, i) = VEHICLE.velocity;
                n(:, i) = RR * VEHICLE.ang_velocity;
            else
                l(:, i) = VEHICLE.velocity + var_constants(i-1) * k(:, i-1);
                n(:, i) = RR * VEHICLE.ang_velocity + var_constants(i-1) * m(:, i-1);
            end

            l(:, i) = l(:, i) * TIME.dt;
            n(:, i) = n(:, i) * TIME.dt;

            % Save output at the first RK4 stage
            if i == 1
          
                VEHICLE.acceleration = k(:, i);
                ROTOR.acceleration = m(:, i);

                OUTPUT = saveAsOUTPUT(OUTPUT, TIME, VEHICLE, ROTOR, ATMOSPHERE, ...
                    F_total, F_rotor, F_gravity, F_drag_cilinder, T_total, T_rotor);
                if rotorIsOpen
                    rotor_data_vec = [rotor_data_vec; rotor_distribution_data];
                    rotor_data_time = [rotor_data_time TIME.clock];
                end
            end
        end

        % Final RK4 state updates
        VEHICLE.velocity = CURRENT.vehicle_velocity + (1/6) * (k(:,1) + 2*k(:,2) + 2*k(:,3) + k(:,4));
        VEHICLE.position = CURRENT.vehicle_position + (1/6) * (l(:,1) + 2*l(:,2) + 2*l(:,3) + l(:,4));
        VEHICLE.ang_velocity = CURRENT.vehicle_ang_velocity + (1/6) * (m(:,1) + 2*m(:,2) + 2*m(:,3) + m(:,4));
        VEHICLE.orientation  = CURRENT.vehicle_orientation  + (1/6) * (n(:,1) + 2*n(:,2) + 2*n(:,3) + n(:,4));
        ROTOR.velocity = CURRENT.rotor_velocity + (1/6) * (p(1) + 2*p(2) + 2*p(3) + p(4));

        % Compute new induced velocity if rotor is active
        if rotorIsOpen
            ROTOR.induced_velocity = compute_rotor_induced_velocity(VEHICLE, ROTOR, ATMOSPHERE, BLADE, F_rotor);
        end

        % Check for convergence of induced velocity
        if rotorIsOpen
            [vi_convergency, counter_vi] = check_induced_velocity_convergency(CURRENT, VEHICLE, ROTOR, counter_vi);
        else
            vi_convergency = true;
        end
    end

    % Advance simulation time
    TIME = time_controller(TIME);

    % Update visual progress bar
    update_progressBar(VEHICLE, ROTOR, rotorIsOpen);
end

% Final output for rotor-related data
rotor_data.data = rotor_data_vec;
rotor_data.time = rotor_data_time;

end
