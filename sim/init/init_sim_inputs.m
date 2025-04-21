function  [SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH] = init_sim_inputs(inData)

% Vehicle

VEHICLE.mass_payload = inData.sim_payload_mass;

%-> VEHICLE.dragMode = app.vehicleDrag;

VEHICLE.InitPosition = [0; 0; inData.sim_init_height];

VEHICLE.InitVelocity = [inData.sim_ini_vel_x; inData.sim_ini_vel_y; inData.sim_ini_vel_z];

VEHICLE.InitOrientation = [inData.sim_init_roll_phi; inData.sim_init_pitch_theta; 0];

VEHICLE.InitAngularVelocity  = [0; 0; 0];


% Rotor
ROTOR.openRotor = inData.openRotor_mode;

ROTOR.Nb = inData.rotor_no_blades;

% Blade

BLADE.Span = inData.blade_span;

BLADE.RootBladeDistance = inData.blade_epsilon;

BLADE.tc = inData.blade_airfoil_tickness;

BLADE.No_elements = inData.blade_no_points;

BLADE.theta = inData.blade_theta;

BLADE.twist_rate = inData.blade_twist_rate;

BLADE.chord = inData.blade_chord;

BLADE.prandtlTipLosses = inData.rotor_tipLosses_mode;

airfoil_name_toLoad = inData.blade_airfoil;
airfoil_data_file = "./airfoils/data/" + airfoil_name_toLoad + ".mat";
airfoil = load(airfoil_data_file).airfoil;

BLADE.airfoil_name = airfoil.name;
BLADE.airfoil_data = airfoil.data;

ROTOR.induced_velocity = 0;


% ADDITIONAL PARAMETERS

BLADE.AR = BLADE.Span / BLADE.chord;

BLADE.fixed_positions = get_blades_position(ROTOR.Nb);

BLADE.thickness =  BLADE.tc * BLADE.chord;

BLADE.dy = BLADE.Span / BLADE.No_elements;
BLADE.dA = BLADE.dy * BLADE.chord;

BLADE.pos_sec = (0:BLADE.No_elements) * BLADE.dy + BLADE.RootBladeDistance;
BLADE.pos_sec = [zeros(1, length(BLADE.pos_sec)); BLADE.pos_sec; zeros(1, length(BLADE.pos_sec))];

BLADE.mass =  0.4 * (BLADE.Span^(2.6));

BLADE.theta = twist_distribution(BLADE);

ROTOR.mass = BLADE.mass * ROTOR.Nb;
ROTOR.azimutal_points = inData.rotor_azimutal_points;


ROTOR.II = inertia_tensor(BLADE);
ROTOR.II_inv = inv(ROTOR.II);


ROTOR.azimutal_positions = azimutalDescretization(ROTOR.azimutal_points, 0);

for k = 1:ROTOR.azimutal_points    

     R_r_b = rotationMatrix_generator(ROTOR.azimutal_positions(k), 0, 0, "DEG");

     ROTOR.R_r_b(:, :, k) = R_r_b;
     ROTOR.R_b_r(:, :, k) = transpose(R_r_b);
end


for k = 1:ROTOR.azimutal_points
    for i = 1:length(BLADE.pos_sec)
        BLADE.pos_sec_r(:, i, k) = ROTOR.R_b_r(:, :, k) * BLADE.pos_sec(:, i);
    end
end

ROTOR.disk_area = pi * (BLADE.Span + BLADE.RootBladeDistance)^2;

VEHICLE.mass = ROTOR.mass + VEHICLE.mass_payload;

% Earth Properties
EARTH.R = inData.earth_radius;
EARTH.M = inData.earth_mass;
EARTH.G = inData.earth_gravitational_constant;

% Extract and calculate derived parameters
SIM.solver = inData.sim_ode_solver;
SIM.atmosphereModelSelector = inData.sim_atmos_model;

SIM.init_vaues = inData.sim_res_val ;
SIM.AerodynamicModelSelector = inData.sim_aero_model;

SIM.blade_integrator = inData.sim_blade_integrator;

% Time
TIME.time_limit_sim = inData.sim_time_limit;

TIME.dt = inData.sim_time_step;  

TIME.t_deploy_rotor = inData.sim_deploy_time;

TIME.clock = 0;

TIME.stop_flag = false;




end