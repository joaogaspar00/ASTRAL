clc
clear
close all

tic

airfoils_vec = {"naca0010", "n0012", "naca2412", "naca4412"};

sim_counter = 0;

for ii = 1:length(airfoils_vec)
    Nb = 4;
    Span = 1;
    root_theta = -10;
    root_chord = 0.17;

    init_height = 500;
    init_vel = 0;

    dt = 0.025;
    t_deploy_rotor = 3;
    mass_payload = 20;

    time_limit_sim = inf;

    % Parâmetros variáveis
    airfoil_name = airfoils_vec{ii};  
    RootBladeDistance = 0;
    blade_twist_rate = 0;
    lambda_chord = 1;

    sim_counter = sim_counter + 1;

    sim_file = "sim_" + airfoil_name + ".mat";
    disp(sim_file)
    fprintf("Running simulation no.  %d - %s \n", ...
        sim_counter, airfoil_name)

    multiple_sims_init_inputs
    out = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);

    save(sim_file, "out")

end

elapsed_time = toc;
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = mod(elapsed_time, 60);

fprintf("\n\nElapsed time: %02d:%02d:%05.2f (HH:MM:SS)\n", hours, minutes, seconds);


