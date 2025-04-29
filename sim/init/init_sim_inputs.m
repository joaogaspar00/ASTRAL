function  [SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH] = init_sim_inputs(inData)

% Vehicle

VEHICLE.mass_payload = inData.sim_payload_mass;

%VEHICLE.dragMode = app.vehicleDrag;

VEHICLE.InitPosition = [0; 0; inData.sim_init_height];

VEHICLE.InitVelocity = [inData.sim_ini_vel_x; inData.sim_ini_vel_y; inData.sim_ini_vel_z];

VEHICLE.InitOrientation = [inData.sim_init_roll_phi; inData.sim_init_pitch_theta; 0];

VEHICLE.InitAngularVelocity  = [0; 0; 0];


% Rotor
ROTOR.openRotor = inData.openRotor_mode;

ROTOR.rotorIsOpen = false;

ROTOR.Nb = inData.rotor_no_blades;

% Blade

BLADE.Span = inData.blade_span;

BLADE.RootBladeDistance = inData.blade_epsilon;

BLADE.tc = inData.blade_airfoil_tickness;

BLADE.No_elements = inData.blade_no_points;

BLADE.root_theta = inData.blade_theta;

BLADE.twist_rate = inData.blade_twist_rate;

BLADE.root_chord = inData.blade_chord;
BLADE.lambda_chord = inData.blade_lambda_chord;

BLADE.prandtlTipLosses = inData.rotor_tipLosses_mode;

airfoil_name_toLoad = inData.blade_airfoil;
airfoil_data_file = "./airfoils/data/" + airfoil_name_toLoad + ".mat";
airfoil = load(airfoil_data_file).airfoil;

BLADE.airfoil_name = airfoil.name;
BLADE.airfoil_data = airfoil.data;

ROTOR.induced_velocity = 0;

% ADDITIONAL PARAMETERS


BLADE.AR = BLADE.Span / BLADE.root_chord;

BLADE.thickness =  BLADE.tc * BLADE.root_chord;

BLADE.dy = BLADE.Span / BLADE.No_elements;


BLADE.pos_sec = (0:BLADE.No_elements) * BLADE.dy + BLADE.RootBladeDistance;
BLADE.pos_sec = [zeros(1, length(BLADE.pos_sec)); BLADE.pos_sec; zeros(1, length(BLADE.pos_sec))];

BLADE = planform_distribution(BLADE);

BLADE.dA = BLADE.dy .* BLADE.chord;

BLADE.mass =  0.4 * (BLADE.Span^(2.6));


ROTOR.mass = BLADE.mass * ROTOR.Nb;
ROTOR.azimutal_points = inData.rotor_azimutal_points;


ROTOR.azimutal_positions = azimutalDescretization(ROTOR.azimutal_points, 0);

for k = 1:ROTOR.azimutal_points    

    ROTOR.R_r_b(:, :, k) = rotationMatrix_generator(ROTOR.azimutal_positions(k), 0, 0, "DEG");
    ROTOR.R_b_r(:, :, k) = inv(ROTOR.R_r_b(:, :, k));
end

for k = 1:ROTOR.azimutal_points
    for i = 1:length(BLADE.pos_sec)
        BLADE.pos_sec_r(:, i, k) = ROTOR.R_b_r(:, :, k) * BLADE.pos_sec(:, i);
    end
end

[ROTOR.II, ROTOR.II_inv] = inertia_tensor(ROTOR, BLADE);


ROTOR.disk_area = pi * (BLADE.Span^2 + 2*BLADE.Span*BLADE.RootBladeDistance);

ROTOR.operation_mode = -1;
ROTOR.vi_error = 0;

VEHICLE.mass = ROTOR.mass + VEHICLE.mass_payload;

% Earth Properties
EARTH.R = inData.earth_radius;

EARTH.M = inData.earth_mass;
EARTH.G = inData.earth_gravitational_constant;

% SIM 

SIM.init_vaues = inData.sim_res_val ;

SIM.atmosphereModelSelector = inData.sim_atmos_model;

SIM.AerodynamicModelSelector = inData.sim_aero_model;

SIM.solver = inData.sim_ode_solver;

SIM.blade_integrator = inData.sim_blade_integrator;

SIM.debbug_cmd = false;

% TIME

TIME.time_limit_sim = inData.sim_time_limit;

TIME.dt = inData.sim_time_step;  

TIME.t_deploy_rotor = inData.sim_deploy_time;

TIME.clock = 0;

TIME.stop_flag = false;

end