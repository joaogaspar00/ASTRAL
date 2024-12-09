function dydt = motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS)

global sim_data

sim_data.iterationCounter = sim_data.iterationCounter + 1;

%--------------------------------------------------------------------------

% Initialize the derivative vector
dydt = zeros(12,1);

% Extract state variables
vehicle_position = y(1:3);        % Position [x, y, z]
vehicle_velocity = y(4:6);        % Velocity [vx, vy, vz]
vehicle_eulerAngles = y(7:9);     % Euler angles [roll, pitch, yaw]
vehicle_angularVelocity = y(10:12); % Angular velocity [wx, wy, wz]

rotor_position = y(13);
rotor_velocity = y(14);

% Compute atmosphere proprieties
ATMOSPHERE = atmosphereModel(vehicle_position(3), SIM);

[F_total, F_rotor, F_gravity, F_drag_cilinder, ~, T_rotor, ~, T_shaft, rotorIsOpen, stall_percentage] ...
    = compute_forces_torques(t, vehicle_position, vehicle_velocity, rotor_velocity, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS, ATMOSPHERE);

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------

a = F_total / VEHICLE.M; % Gravitational acceleration


I_cilindro = (1/2) * VEHICLE.M * 1^2; % Momento de inércia do cilindro
dw = T_rotor / (ROTOR.I_rotor + I_cilindro); % Aceleração angular total

rotor_acceleration = T_shaft/ROTOR.I_rotor;



% Update derivatives - vehicle
dydt(1:3) = vehicle_velocity;            % dx/dt = velocity
dydt(4:6) = a;                           % dv/dt = acceleration

dydt(7:9) = vehicle_angularVelocity;     % d(Euler angles)/dt = angular velocities
dydt(10:12) = dw;                        % No torques applied, d(angular velocity)/dt = 0

dydt(13) = rotor_velocity;            % domega/dt = rotor acceleration
dydt(14) = rotor_acceleration;        % dv/dt = acceleration

%--------------------------------------------------------------------------

sim_data.height = [sim_data.height; vehicle_position(3)];
sim_data.t = [sim_data.t; t];    
sim_data.a = [sim_data.a; a'];
sim_data.dw = [sim_data.dw; dw'];

sim_data.rotor_acceleration = [sim_data.rotor_acceleration; rotor_acceleration'];

sim_data.rotor_torque = [sim_data.rotor_torque;T_rotor'];

sim_data.t_shaft = [sim_data.t_shaft; T_shaft];

sim_data.stall_percentage = [sim_data.stall_percentage ; stall_percentage];

sim_data.F_rotor = [sim_data.F_rotor; F_rotor'];
sim_data.F_g = [sim_data.F_g; F_gravity'];
sim_data.F_drag_cilinder = [sim_data.F_drag_cilinder; F_drag_cilinder'];
sim_data.F_total = [sim_data.F_total; F_total'];

update_progressBar(y(3), F_rotor(3), rotor_velocity, VEHICLE, rotorIsOpen)

end
