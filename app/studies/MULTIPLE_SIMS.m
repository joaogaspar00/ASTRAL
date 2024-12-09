clc
clear
close all

INPUTS.init_height = 75000;
INPUTS.M_payload = 20;
INPUTS.vehicleDrag = 1;

% Rotor
INPUTS.openRotor = 1;
INPUTS.R_rotor = 1.5;
INPUTS.c_rotor = 0.2;

INPUTS.Nb = 2;

% Blade

INPUTS.tc = 0.12;
INPUTS.No_elements = 100;
INPUTS.root_theta = -10;
INPUTS.tip_theta = 5;   
INPUTS.twistDistribution = 2;
INPUTS.c_rotor = 0.2;

INPUTS.prandtlTipLosses = 0;

% Earth Properties  
INPUTS.M_terra = 5.972e+24 ;
INPUTS.R_terra = 6.371e+06;
INPUTS.G = 6.674e-11;

% Extract and calculate derived parameters
INPUTS.solver = 10;
INPUTS.atmosphereModelSelector = 1;
INPUTS.time_limit_sim = 10000;

INPUTS.init_values = 0 ;

% Time
INPUTS.dt = 0.025;   

% AERODAS
INPUTS.outputFile_AERODAS = [];
INPUTS.cmd_debug_AERODAS = 0;

INPUTS.cdm_general_debbug = 0;


%-----
t_deploy_rotor = [10 50 80 100 150 200 250 300 350 400 450 500 550 600 650 700];

terminal_velocities = zeros(1, length(t_deploy_rotor));

multiple_sims = tic;

for i=1:length(t_deploy_rotor)
 
    INPUTS.t_deploy_rotor = t_deploy_rotor(i);

    fprintf("Simuation No. %d - Rotor Deploy at t = %.2f\n", i, INPUTS.t_deploy_rotor)

    OUTPUTS = run_simulation(INPUTS);

    fprintf("Terminal velocity is v = %.2f\n\n",  OUTPUTS.velocity(end, 3))
    
    terminal_velocities(i) = OUTPUTS.velocity(end, 3);

    file = ['sim\saves\data\sim_t_' num2str(INPUTS.t_deploy_rotor) '.mat'];
    
    save(file, 'INPUTS', 'OUTPUTS', '-v7.3')
end

fprintf("\n-----------------------------------------\n\n");

time_elapsed_multiple = toc(multiple_sims);

hours = floor(time_elapsed_multiple / 3600);
minutes = floor(mod(time_elapsed_multiple, 3600) / 60);
seconds = round(mod(time_elapsed_multiple, 60));

fprintf("time: %02dh:%02dm:%02ds\n", hours, minutes, seconds);

%%



figure()
plot(t_deploy_rotor, -terminal_velocities, "ko-", "LineWidth",1.2)
xlabel("Time [s]")
ylabel("Velocity [m/s]")
ylim([0 3])

title("Terminal Velocity vs Deploy Rotor Time")



