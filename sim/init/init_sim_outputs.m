function OUTPUT = init_sim_outputs()

% SIMULATION DATA MATRIX

% KINEMATIC 

OUTPUT.main_clock = [];

OUTPUT.vehicle_position = [];
OUTPUT.vehicle_velocity = [];
OUTPUT.vehicle_acceleration = [];

OUTPUT.vehicle_orientation = [];
OUTPUT.vehicle_ang_acceleration = [];
OUTPUT.vehicle_ang_velocity = [];

% FORCES
OUTPUT.F_rotor = [];
OUTPUT.F_gravity  = [];
OUTPUT.F_drag_cilinder = [];
OUTPUT.F_total = [];

OUTPUT.T_rotor = [];
OUTPUT.T_total = [];

% ATMOSPHERE
OUTPUT.temperature = [];
OUTPUT.pressure = [];
OUTPUT.density = [];
OUTPUT.dynamic_visvosity = [];
OUTPUT.kinematic_viscosity = [];
OUTPUT.sound_speed = [];

OUTPUT.rotor_velocity = [];
OUTPUT.rotor_acceleration = [];

OUTPUT.rotor_induced_velocity = [];

OUTPUT.wind_velocity = [];

end