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

VEHICLE.ang_acceleration = [0;0;0];
VEHICLE.acceleration = [0;0;0];

ROTOR.velocity = 0;
ROTOR.induced_velocity = 0; 

% Variables for vi convergency
ROTOR.prev_induced_velocity = 0;
VEHICLE.prev_velocity = VEHICLE.velocity;
ROTOR.vi_array = [];

% Store per-timestep rotor data (if active)
rotor_data_vec = [];
rotor_data_time = [];

var_constants = [1, 1/2, 1/2, 1];

% Main integration loop
while VEHICLE.position(3) > 0 && ~TIME.stop_flag

    if ROTOR.operation_mode == -1
         s_operation_mode = "off";
    elseif ROTOR.operation_mode == 0
        s_operation_mode = "wbs";
    elseif ROTOR.operation_mode == 1
        s_operation_mode = "vrs";
    end

    fprintf(">> [%.2f] Altitude: %.4f [%s | %.2f | %.2f RPM]\n", ...
        TIME.clock, VEHICLE.position(3), s_operation_mode, VEHICLE.velocity(3), ROTOR.velocity * 60/(2*pi));

    % Save current state
    PREVIOUS_STATE = struct( ...
        'vehicle_position', VEHICLE.position, ...
        'vehicle_velocity', VEHICLE.velocity, ...
        'vehicle_orientation', VEHICLE.orientation, ...
        'vehicle_ang_velocity', VEHICLE.ang_velocity, ...
        'rotor_velocity', ROTOR.velocity, ...
        'rotor_induced_velocity', ROTOR.induced_velocity, ...
        'clock', TIME.clock);

    VEHICLE.prev_velocity = VEHICLE.velocity;
    ROTOR.prev_induced_velocity = ROTOR.induced_velocity;
    
    % Get atmospheric conditions at current state
    ATMOSPHERE = atmosphereModel_selector(TIME, SIM, VEHICLE);  

    % Restart variables for vi convergency
    ROTOR.vi_convergency = false;
    ROTOR.vi_iter_counter = 0;
   
    % Restart vectors for vi convergency
    VEHICLE.conv_velocity_vec = [];
    ROTOR.conv_velocity_vec = [];

    % Check rotor operation start time
    if TIME.clock >= TIME.t_deploy_rotor && ROTOR.openRotor
        ROTOR.rotorIsOpen = true;
    end

    % Loop for convergence of rotor's induced velocity if rotor is open
    while ~ROTOR.vi_convergency
        
        % RK4 integration matrices
        k = zeros(3, 4); % linear acceleration
        l = zeros(3, 4); % linear velocity
        m = zeros(3, 4); % angular acceleration
        n = zeros(3, 4); % angular velocity
        p = zeros(1, 4); % rotor acceleration
        
        for i = 1:4

            
            if i == 1
                VEHICLE.velocity = VEHICLE.velocity;                
                ROTOR.velocity = ROTOR.velocity;

                VEHICLE.ang_velocity = PREVIOUS_STATE.vehicle_ang_velocity;
            else
                VEHICLE.velocity = VEHICLE.velocity + var_constants(i) * k(:, i-1);                
                ROTOR.velocity = ROTOR.velocity + var_constants(i) * p(i-1);

                VEHICLE.ang_velocity = PREVIOUS_STATE.vehicle_ang_velocity + var_constants(i) * m(:, i-1);
            end
               
            % fprintf("\t{Inputs } V [%.2f | %.2f | %.2f ] AG [%.2f | %.2f | %.2f ] RV [%.2f] Vi [%.2e]\n", VEHICLE.velocity, VEHICLE.ang_velocity, ROTOR.velocity, ROTOR.induced_velocity)

            [F_total, F_rotor, F_gravity, F_drag_cilinder, ...
             T_total, T_rotor, rotor_distribution_data] = ...
                compute_forces_torques(SIM, VEHICLE, ROTOR, BLADE, ATMOSPHERE, EARTH);

            % fprintf("\t{Outputs} F [%.2f %.2f %.2f] | T [%.2f %.2f %.2f] | Fr [%.2f %.2f %.2f] | Tr %.2f \n", F_total, T_total, F_rotor, T_rotor)

            % Rotation matrix for Euler angle derivatives
            phi = VEHICLE.orientation(1);
            theta = VEHICLE.orientation(2);
            RR = [1   tand(theta)*sind(phi)   tand(theta)*cosd(phi);
                  0   cosd(phi)               -sind(phi);
                  0   sind(phi)/cosd(theta)   cosd(phi)/cosd(theta)];

            k(:, i) = (1 / VEHICLE.mass) * F_total;
            m(:, i) = ROTOR.II_inv * (T_total - cross(VEHICLE.ang_velocity, ROTOR.II * VEHICLE.ang_velocity));
            p(i) = (T_rotor / ROTOR.II(3, 3)); 

            k(:, i) = k(:, i) * TIME.dt;
            m(:, i) = m(:, i) * TIME.dt;
            p(i) = p(i)  * TIME.dt;

            if norm(m(:, i)) < 1e-2
                m(:, i) = [0;0;0];
            end
                        
            if i == 1
                l(:, i) = VEHICLE.velocity;
                n(:, i) = RR * VEHICLE.ang_velocity;
            else
                l(:, i) = VEHICLE.velocity + var_constants(i) * k(:, i-1);
                n(:, i) = RR * VEHICLE.ang_velocity + var_constants(i) * m(:, i-1);
            end

            l(:, i) = l(:, i) * TIME.dt;
            n(:, i) = n(:, i) * TIME.dt;

            % fprintf("\t{RK4    } K [%.2f | %.2f | %.2f ] L [%.2f | %.2f | %.2f ] M [%.2f | %.2f | %.2f] N [%.2f | %.2f | %.2f ] P [%.2f ]\n\n", k(:, i), l(:, i), m(:, i), n(:, i) , p(i))

            % Save output at the first RK4 stage
            if i == 1          
                VEHICLE.acceleration = k(:, i);
                VEHICLE.ang_acceleration = m(:, i);
                ROTOR.acceleration = p(i);

                AUX_OUTPUT = saveAsOUTPUT(OUTPUT, TIME, VEHICLE, ROTOR, ATMOSPHERE, ...
                    F_total, F_rotor, F_gravity, F_drag_cilinder, T_total, T_rotor);
                if ROTOR.rotorIsOpen
                    rotor_data_vec = [rotor_data_vec; rotor_distribution_data];
                    rotor_data_time = [rotor_data_time TIME.clock];
                end
            end
        end                
        
        % if rotor is not open than vi doed not need to be converged or
        % converged then flag turns true and the next time iteration should
        % be computed
        if ~ROTOR.rotorIsOpen  
            ROTOR.vi_convergency = true;
        else

            % RK4 vehicle velocity and rotor velocity state updates 
            VEHICLE.velocity = PREVIOUS_STATE.vehicle_velocity + (1/6) * (k(:,1) + 2*k(:,2) + 2*k(:,3) + k(:,4));
            ROTOR.velocity = PREVIOUS_STATE.rotor_velocity + (1/6) * (p(1) + 2*p(2) + 2*p(3) + p(4));

            % Compute the rotor's induced velocity 
            ROTOR = compute_rotor_induced_velocity(VEHICLE, ROTOR, ATMOSPHERE);

            % Check for convergence of induced velocity
            ROTOR = check_induced_velocity_convergency(PREVIOUS_STATE, VEHICLE, ROTOR);     

            % if has not reach convergency
            if ~ROTOR.vi_convergency

                VEHICLE.conv_velocity_vec = [VEHICLE.conv_velocity_vec  VEHICLE.velocity];
                ROTOR.conv_velocity_vec = [ROTOR.conv_velocity_vec ROTOR.velocity]; 

                % vi convergency algorithm
                [VEHICLE, ROTOR] = vi_convergency_helper(VEHICLE, ROTOR);

            end        
            
        end

    end

    % When vi has converged save AUX_OUTPUT as OUTPUT
     OUTPUT = AUX_OUTPUT;

    % If the rotor is not open then the vehicle position is 
    if ~ROTOR.rotorIsOpen
        VEHICLE.velocity = PREVIOUS_STATE.vehicle_velocity + (1/6) * (k(:,1) + 2*k(:,2) + 2*k(:,3) + k(:,4));

        % In this case the rotor velocity is 0 by default to save
        % computational effort (small point, but still...)
        ROTOR.velocity = 0;  
    end

    % Other solver updtades using RK4 method
    VEHICLE.position = PREVIOUS_STATE.vehicle_position + (1/6) * (l(:,1) + 2*l(:,2) + 2*l(:,3) + l(:,4));
    VEHICLE.ang_velocity = PREVIOUS_STATE.vehicle_ang_velocity + (1/6) * (m(:,1) + 2*m(:,2) + 2*m(:,3) + m(:,4));
    VEHICLE.orientation  = PREVIOUS_STATE.vehicle_orientation  + (1/6) * (n(:,1) + 2*n(:,2) + 2*n(:,3) + n(:,4));
      
    % Update visual progress bar
    update_progressBar(VEHICLE, ROTOR);

    % Advance simulation time
    TIME = time_controller(TIME);

end

% Final output for rotor-related data
rotor_data.data = rotor_data_vec;
rotor_data.time = rotor_data_time;

end
