%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run_simulation.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function runs the complete aerospace simulation. It starts a timer, 
% opens a progress bar, calls the physics solver (based on 4th-order 
% Runge-Kutta), and performs post-processing on the simulation data.
% It prints updates to the console and closes the progress bar when finished.
%
% Inputs:
% - SIM: structure containing simulation parameters 
% - TIME: structure with time-related parameters
% - VEHICLE: structure with vehicle properties
% - ROTOR: structure containing rotor characteristics
% - BLADE: structure with blade-specific data
% - EARTH: structure with environmental parameters
%
% Outputs:
% - OUTPUT: structure containing the simulation results
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function OUTPUT = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH)

% Start general simulation clock
tic

% Progress bar, global variable initialization
global progress_bar

% fprintf('==================================================\n');
% fprintf('                    SIMULATION START              \n');
% fprintf('==================================================\n\n');
% fprintf('Running Simulation...\n\n');

% Progress bar pop-up
progress_bar = waitbar(0, sprintf('Height: %.2f m | 0 RPM', VEHICLE.InitPosition(3)));

% Physics Solver
[OUTPUT, rotor_data] = RK4(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);

% Close the progress bar
close(progress_bar);

fprintf('Job done successfully\n\n');
 
% fprintf('==================================================\n');
% fprintf('              SIMULATION POST-PROCESSING              \n');
% fprintf('==================================================\n\n');

% Post-processing

% Output variable creation
OUTPUT = pos_sim_processing(OUTPUT, rotor_data);

% fprintf('==================================================\n');
% fprintf('              SIMULATION OUTPUT DATA              \n');
% fprintf('==================================================\n\n');
% 
% disp(OUTPUT)
% disp(OUTPUT.rotor_data)
% 
% fprintf('==================================================\n');
% fprintf('          EXIT SIMULATION WITH NO ERRORS           \n');
% fprintf('==================================================\n\n');


end
