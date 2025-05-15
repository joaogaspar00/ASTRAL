
VEHICLE.mass_payload = mass_payload;

VEHICLE.dragMode = false;

VEHICLE.InitPosition = [0; 0; init_height];

VEHICLE.InitVelocity = [0; 0; init_vel];

VEHICLE.InitOrientation = [0; 0; 0];

VEHICLE.InitAngularVelocity  = [0; 0; 0];


% Rotor
ROTOR.openRotor = true;

ROTOR.rotorIsOpen = false;

ROTOR.Nb = Nb;
ROTOR.azimutal_points = 8;


% Blade

BLADE.Span = Span;

BLADE.RootBladeDistance = RootBladeDistance;

BLADE.tc = 0.12;

BLADE.No_elements = 50;

BLADE.root_theta = root_theta;

BLADE.twist_rate = blade_twist_rate;

BLADE.root_chord = root_chord;
BLADE.lambda_chord = lambda_chord;

BLADE.prandtlTipLosses = false;

airfoil_name_toLoad = airfoil_name;
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


ROTOR.mass = BLADE.mass * ROTOR.Nb + 2.75*(BLADE.Span^(1.8));


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
EARTH.R = 6371000;
EARTH.M = 5.972e+24;
EARTH.G = 6.674184e-11;

% Extract and calculate derived parameters
SIM.solver = 'RK4';
SIM.atmosphereModelSelector = 'ISA';
SIM.init_vaues = 0 ;
SIM.AerodynamicModelSelector = 'Hybrid';
SIM.blade_integrator = "Trapezoidal";
SIM.debbug_cmd = false;

% Time
TIME.time_limit_sim = time_limit_sim;
TIME.dt = dt; 
TIME.t_deploy_rotor = t_deploy_rotor;
TIME.clock = 0;
TIME.stop_flag = false;

