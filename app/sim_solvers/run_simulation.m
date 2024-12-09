function outputData = run_simulation(INPUTS)
close all
tic

% Sim inputs reading
init_SIM;

% AERODAS INIT
AERODAS.data = load('naca0012.mat').aerodas_data;

% if SIM.cdm_general_debbug
%     show_SIM_variables;
% end

global sim_data
global progress_bar

%--------------------------------------------------------------------------
if SIM.cdm_general_debbug
    fprintf('==================================================\n');
    fprintf('                    SIMULATION START                   \n');
    fprintf('==================================================\n\n');
    
    fprintf('Running Simulation...\n\n');
end

% Progress bar pop-up
progress_bar = waitbar(0, sprintf('Height: %.2f m | 0 RPM', VEHICLE.InitPosition(3)));

% Define the time span for the simulation
if SIM.time_limit_sim == inf
    tspan = 0:TIME.dt:1e6;  % Time span for the simulation
else
    tspan = 0:TIME.dt:SIM.time_limit_sim;
end
% Initial conditions
init_conditions = [VEHICLE.InitPosition; VEHICLE.InitVelocity; VEHICLE.InitOrientation; VEHICLE.InitAngularVelocity; 0; 0];

% ODE solver options
options = odeset('RelTol',1e-8, 'AbsTol', 1e-8,'Events', @height_event);

%select solver
if SIM.solver == 1
    [t, y] = ode23( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 2
    [t, y] = ode45( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 3
    [t, y] = ode78( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 4
    [t, y] = ode89( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 5
    [t, y] = ode113( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 6
    [t, y] = ode15s( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 7
    [t, y] = ode23s( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 8
    [t, y] = ode23t( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 9
    [t, y] = ode23tb( ...
        @(t, y) motionKinematics(t, y, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS), ...
        tspan, ...
        init_conditions, ...
        options);

elseif SIM.solver == 10
    
    [t, y] = analitic_solver(SIM, TIME, VEHICLE, EARTH, BLADE, ROTOR, AERODAS);

elseif SIM.solver == 11
    
    [t, y] = runge_kutta_4th_order_solver(SIM, TIME, VEHICLE, EARTH, BLADE, ROTOR, AERODAS);

end

% Close the progress bar
close(progress_bar);

generate_output_data

if SIM.cdm_general_debbug
    fprintf('Job done successfully\n\n');
    
    fprintf('==================================================\n');
    fprintf('              SIMULATION OUTPUT DATA              \n');
    fprintf('==================================================\n\n');
       
    disp(outputData)
    
    fprintf('==================================================\n');
    fprintf('          EXIT SIMULATION WITH NO ERRORS           \n');
    fprintf('==================================================\n\n');
end

end
