function OUTPUT = saveAsOUTPUT(OUTPUT, TIME, VEHICLE, ROTOR, ATMOSPHERE, ...
    F_total, F_rotor, F_gravity, F_drag_cilinder, T_total, T_rotor)

OUTPUT.main_clock = [OUTPUT.main_clock; TIME.clock];

OUTPUT.F_total = [OUTPUT.F_total; F_total'];
OUTPUT.F_rotor = [OUTPUT.F_rotor; F_rotor'];
OUTPUT.F_gravity  = [OUTPUT.F_gravity; F_gravity'];
OUTPUT.F_drag_cilinder = [OUTPUT. F_drag_cilinder;  F_drag_cilinder'];

OUTPUT.T_total = [OUTPUT.T_total; T_total'];
OUTPUT.T_rotor = [OUTPUT.T_rotor; T_rotor'];

% OUTPUT.vehicle_acceleration = [OUTPUT.vehicle_acceleration; VEHICLE.acceleration'];
OUTPUT.vehicle_acceleration = [OUTPUT.vehicle_velocity; VEHICLE.acceleration'];
OUTPUT.vehicle_velocity = [OUTPUT.vehicle_velocity; VEHICLE.velocity'];
OUTPUT.vehicle_position = [OUTPUT.vehicle_position; VEHICLE.position'];

% OUTPUT.vehicle_ang_acceleration = [OUTPUT.vehicle_ang_acceleration; VEHICLE.angular_acceleration'];
OUTPUT.vehicle_ang_acceleration = [OUTPUT.vehicle_ang_velocity; VEHICLE.ang_acceleration'];
OUTPUT.vehicle_ang_velocity = [OUTPUT.vehicle_ang_velocity; VEHICLE.ang_velocity'];
OUTPUT.vehicle_orientation = [OUTPUT.vehicle_orientation; VEHICLE.orientation'];

OUTPUT.rotor_acceleration = [OUTPUT.rotor_acceleration;  ROTOR.acceleration];
OUTPUT.rotor_velocity = [OUTPUT.rotor_velocity; ROTOR.velocity'];
OUTPUT.rotor_operation_mode = [OUTPUT.rotor_operation_mode; ROTOR.operation_mode'];
OUTPUT.rotor_induced_velocity = [OUTPUT.rotor_induced_velocity; ROTOR.induced_velocity'];
OUTPUT.rotor_vi_error = [OUTPUT.rotor_vi_error; ROTOR.vi_error'];
OUTPUT.rotor_vi_iter_counter = [OUTPUT.rotor_vi_iter_counter; ROTOR.vi_iter_counter'];

OUTPUT.temperature = [OUTPUT.temperature; ATMOSPHERE.temperature];
OUTPUT.pressure = [OUTPUT.pressure; ATMOSPHERE.pressure];
OUTPUT.density = [OUTPUT.density; ATMOSPHERE.density];
OUTPUT.dynamic_viscosity = [OUTPUT.dynamic_viscosity; ATMOSPHERE.dynamic_viscosity];
OUTPUT.kinematic_viscosity = [OUTPUT.kinematic_viscosity; ATMOSPHERE.kinematic_viscosity];
OUTPUT.sound_speed = [OUTPUT.sound_speed; ATMOSPHERE.sound_speed];

OUTPUT.wind_velocity = [OUTPUT.wind_velocity; ATMOSPHERE.wind_velocity'];

end