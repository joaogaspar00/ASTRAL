% Vehicle

VEHICLE.M_payload = INPUTS.M_payload;
VEHICLE.dragMode = INPUTS.vehicleDrag;

VEHICLE.InitPosition = [0; 0; INPUTS.init_height];
VEHICLE.InitVelocity = [INPUTS.Vx; INPUTS.Vy; INPUTS.Vz];
VEHICLE.InitOrientation = [INPUTS.phi; INPUTS.theta; 0];
VEHICLE.InitAngularVelocity  = [0; 0; 0];

% Rotor
ROTOR.openRotor = INPUTS.openRotor;
ROTOR.chord = INPUTS.c_rotor;
ROTOR.t_deploy_rotor = INPUTS.t_deploy_rotor;
ROTOR.Nb = INPUTS.Nb;

ROTOR.InitPosition = 0;
ROTOR.InitVelocity = 0;

% Blade

BLADE.Span = INPUTS.BladeLength;
BLADE.RootBladeDistance = INPUTS.RootBladeDistance;
BLADE.tc = INPUTS.tc;
BLADE.No_elements = INPUTS.No_elements;
BLADE.root_theta = INPUTS.root_theta;
BLADE.tip_theta = INPUTS.tip_theta;   
BLADE.twistDistribution = INPUTS.twistDistribution;
BLADE.chord = INPUTS.c_rotor;
BLADE.prandtlTipLosses = INPUTS.prandtlTipLosses;

airfoil = load('./airfoils/naca0012.mat').airfoil;

BLADE.airfoil_name = airfoil.name;
BLADE.airfoil_data = airfoil.data;

disp(BLADE.airfoil_data)

% ADDITIONAL PARAMETERS

ROTOR.AR = BLADE.Span / ROTOR.chord;
ROTOR.M_blades = ROTOR.Nb * 0.4 * ( BLADE.Span^(2.6) ); 
ROTOR.M_controller = 2.75 * ( BLADE.Span^(1.8) );
ROTOR.M = ROTOR.M_blades + ROTOR.M_controller;
ROTOR.I_rotor = (1/12) * ROTOR.M_blades * (4 * BLADE.Span^2 + ROTOR.chord^2);

BLADE.dy = BLADE.Span / BLADE.No_elements;
BLADE.dA = BLADE.dy * ROTOR.chord;
BLADE.pos_sec = (0:BLADE.No_elements) * BLADE.dy + BLADE.RootBladeDistance;
BLADE.theta = twist_distribution(BLADE, ROTOR);

VEHICLE.M = ROTOR.M + VEHICLE.M_payload;

% Earth Properties
EARTH.M = INPUTS.M_terra;
EARTH.R = INPUTS.R_terra;
EARTH.G = INPUTS.G;

% Extract and calculate derived parameters
SIM.solver = INPUTS.solver;
SIM.atmosphereModelSelector = INPUTS.atmosphereModelSelector;
SIM.time_limit_sim = INPUTS.time_limit_sim;
SIM.cdm_general_debbug = INPUTS.cdm_general_debbug;
SIM.init_vaues = INPUTS.init_values ;
SIM.AerodynamicModelSelector = INPUTS.AerodynamicModel;

% Time
TIME.dt = INPUTS.dt;   
TIME.initial = 0;
TIME.clock =  0;

% AERODAS
AERODAS.outputFile_AERODAS = INPUTS.outputFile_AERODAS;
AERODAS.cmd_debug_AERODAS = INPUTS.cmd_debug_AERODAS;

%--------------------------------------------------------------------------
if SIM.cdm_general_debbug
    % Display the initialization message
    fprintf('==================================================\n');
    fprintf('               SIMULATION INITIALIZATION          \n');
    fprintf('==================================================\n\n');
    
    
    fprintf('Vehicle Configuration:\n');
    fprintf('  - Drag Mode: %d \n\n', VEHICLE.dragMode);
    
    fprintf('Rotor Configuration:\n');
    fprintf('  - Rotor Deployment Time: %.2f s\n', ROTOR.t_deploy_rotor);    
    fprintf('  - Number of Blades: %d\n', ROTOR.Nb);
    fprintf('  - Rotor Inertia: %.5f kg.m^2\n', ROTOR.I_rotor);    
    fprintf('  - Rotor Radius: %.2f m\n', BLADE.Span); 
    fprintf('  - Rotor Enabled: %d\n\n', ROTOR.openRotor);
       
    fprintf('Mass Properties:\n');
    fprintf('  - Vehicle Mass: %.2f kg\n', VEHICLE.M);
    fprintf('  - Rotor Mass: %.2f kg\n', ROTOR.M);
    fprintf('  - Total System Mass: %.2f kg\n\n', VEHICLE.M + ROTOR.M);   
    
    fprintf('Blade Parameters:\n');
    fprintf('  - Airfoil: %s\n', BLADE.airfoil_name);
    fprintf('  - Number of Elements: %d\n', BLADE.No_elements);
    fprintf('  - Root Angle: %.2f degrees\n', BLADE.root_theta);
    fprintf('  - Tip Angle: %.2f degrees\n', BLADE.tip_theta);
    fprintf('  - Airfoil Chord: %.2f m\n', ROTOR.chord);
    fprintf('  - Aspect Ratio (AR): %.2f\n', ROTOR.AR);
    fprintf('  - Thickness-to-Chord Ratio (tc): %.2f\n', BLADE.tc);

    if BLADE.prandtlTipLosses == 0
        ptl = 'Off';
    else
        ptl = 'On';
    end
    
    fprintf('  - Prandtl Tip Losses: %d\n', ptl);
    
    if BLADE.twistDistribution == 1
        td = 'No Twist';
    elseif BLADE.twistDistribution == 2
        td = 'Linear';
    end
    
    fprintf('  - Twist Distribution: %s\n\n', td);
    
    fprintf('Gravitational Parameters:\n');
    fprintf('  - Earth Mass: %.3e kg\n', EARTH.M);
    fprintf('  - Earth Radius: %.3e m\n', EARTH.R);
    fprintf('  - Gravitational Constant: %.2e m^3/kg/s^2\n\n', EARTH.G);
    
    fprintf('Simulation Init Parameters:\n');
    fprintf('  - Vehicle Initial Position: [%.2f %.2f %.2f] m\n', VEHICLE.InitPosition(1),VEHICLE.InitPosition(2),VEHICLE.InitPosition(3));
    fprintf('  - Vehicle Initial Velocity: [%.2f %.2f %.2f] m/s \n', VEHICLE.InitVelocity(1), VEHICLE.InitVelocity(2), VEHICLE.InitVelocity(3));
    fprintf('  - Vehicle Initial Orientation: [%.2f %.2f %.2f] deg\n\n', VEHICLE.InitOrientation(1),VEHICLE.InitOrientation(2),VEHICLE.InitOrientation(3));
    
    fprintf('  - Rotor Initial Position: %.2f deg/s \n', ROTOR.InitPosition);
    fprintf('  - Rotor Initial Velocity: %.2f deg/s \n\n', ROTOR.InitVelocity);
       
    
    fprintf('AERODAS Configuration:\n');
    fprintf('  - Output file: %s \n', AERODAS.outputFile_AERODAS);
    fprintf('  - Enable cmd debug: %d \n\n', AERODAS.cmd_debug_AERODAS);
    
    fprintf('Simulation Configuration:\n');
    
    fprintf('  - Simulation Inital Variables Values: %.2e\n', SIM.init_vaues);
    
    fprintf('  - Maximum Simulation Time: %.2f s\n', SIM.time_limit_sim);
    
    if SIM.solver == 1
        ss_solver = 'ODE 23';
    elseif SIM.solver == 2
        ss_solver = 'ODE 45';
    elseif SIM.solver == 3
        ss_solver = 'ODE 78';
    elseif SIM.solver == 4
        ss_solver = 'ODE 89';
    elseif SIM.solver == 5
        ss_solver = 'ODE 113';
    elseif SIM.solver == 6
        ss_solver = 'ODE 15s';
    elseif SIM.solver == 7
        ss_solver = 'ODE 23s';
    elseif SIM.solver == 8
        ss_solver = 'ODE 23t';
    elseif SIM.solver == 9
        ss_solver = 'ODE 23tb';
    elseif SIM.solver == 10
        ss_solver = 'Analytic Equations';
    elseif SIM.solver == 11
        ss_solver = 'Runge-Kutta 4th Order';
    end
    
    fprintf('  - Solver Method: %s\n', ss_solver);   
    
    if SIM.atmosphereModelSelector == 1
        ss_atmosphereModel = 'Earth Atmospheric Model - NASA';
    elseif SIM.atmosphereModelSelector == 2
        ss_atmosphereModel = 'Standard Atmosphere - 1976';
    end
    
    fprintf('  - Atmosphere Model: %s\n', ss_atmosphereModel);

    if SIM.AerodynamicModelSelector == 1
        ss_aeromodel = 'Aerodas Model';
    elseif SIM.AerodynamicModelSelector == 2
        ss_aeromodel = 'NeuralFoil Model';
    end
    
    fprintf('  - Aerodynamic Model: %s\n\n', ss_aeromodel);
end




%% SIMULATION OUTPUT VETOR

global sim_data

% SIM

sim_data.iterationCounter = 0;

% KINEMATIC 

sim_data.t = [];
sim_data.height = [];
sim_data.a = [];
sim_data.dw = [];

sim_data.rotor_acceleration = [];

sim_data.rotor_torque = [];
sim_data.t_shaft = [];

sim_data.stall_percentage = [];

% FORCES
sim_data.F_rotor = [];
sim_data.F_g  = [];
sim_data.F_drag_cilinder = [];
sim_data.F_total = [];

% ATMOSPHERE
sim_data.temperature = [];
sim_data.pressure = [];
sim_data.density = [];
sim_data.dynamicVisvosity = [];
sim_data.kinecticViscosity = [];
sim_data.soundSpeed = [];
sim_data.height = [];

% BLADE
sim_data.b_time = ROTOR.t_deploy_rotor;

sim_data.b_df_x = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_df_y = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_df_z = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_dtau_x = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_dtau_y = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_dtau_z = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_v_x = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_v_y = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_v_z = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_ang_v = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_total_v = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_dL = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_dD = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_alpha = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_theta = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_phi = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_element_state = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_Ma = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_Re = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_Cl = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_Cd = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_U_T = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_U_R = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_U_P = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_f_prandtl = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_df_z_prandtl = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);

sim_data.b_stallAngle = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);
sim_data.b_stallMode = zeros(ROTOR.Nb, BLADE.No_elements+1, 1);