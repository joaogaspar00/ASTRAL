% init manual simulation
airfoil_name_toLoad = 'n0012';
airfoil_data_file = "./airfoils/data/" + airfoil_name_toLoad + ".mat";
airfoil = load(airfoil_data_file).airfoil;

VEHICLE.mass_payload = mass_payload;
VEHICLE.dragMode = true;
VEHICLE.InitPosition = [0; 0; 0];
VEHICLE.InitVelocity = [0; 0; 0];
VEHICLE.InitOrientation = [0; 0; 0];
VEHICLE.InitAngularVelocity  = [0; 0; 0];

VEHICLE.position = vehicle_position;
VEHICLE.velocity = vehicle_velocity;
VEHICLE.orientation = vehicle_orientation;

% Rotor
ROTOR.openRotor = true;
ROTOR.Nb = Nb;
ROTOR.azimutal_points = azimutal_points;

ROTOR.velocity = RPM * 2*pi/60;

ROTOR.induced_velocity = induced_velocity;


% Blade

BLADE.Span = Span;
BLADE.RootBladeDistance = RootBladeDistance;
BLADE.No_elements = No_elements;
BLADE.root_theta = root_theta;
BLADE.twist_rate = twist_rate;
BLADE.root_chord = root_chord;
BLADE.lambda_chord = lambda_chord;

BLADE.prandtlTipLosses = false;
BLADE.airfoil_name = airfoil.name;
BLADE.airfoil_data = airfoil.data;
BLADE.tc = 0.12;

BLADE.dy = BLADE.Span / BLADE.No_elements;



BLADE.pos_sec = (0:BLADE.No_elements) * BLADE.dy + BLADE.RootBladeDistance;
BLADE.pos_sec = [zeros(1, length(BLADE.pos_sec)); BLADE.pos_sec; zeros(1, length(BLADE.pos_sec))];

BLADE = planform_distribution(BLADE);

BLADE.AR = BLADE.Span / BLADE.root_chord;
BLADE.fixed_positions = get_blades_position(ROTOR.Nb);
BLADE.thickness =  BLADE.tc * BLADE.chord;

BLADE.dA = BLADE.dy * BLADE.chord;


BLADE.mass =  0.4 * (BLADE.Span^(2.6));

ROTOR.mass = BLADE.mass * ROTOR.Nb;


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
SIM.blade_integrator = blade_integrator;
SIM.debbug_cmd = false;

% Time
TIME.limit_sim = inf;
TIME.dt = 0.01; 
TIME.t_deploy_rotor = 5;
TIME.clock = 0;


%--------------------------------------------------------------------------

azimutes = ROTOR.azimutal_positions;
rho = BLADE.pos_sec(2, :);
[ATMOSPHERE] = atmosphereModel_selector(TIME, SIM, VEHICLE);

