clc
clear
close all

tic

airfoils_vec = {"naca2412", "naca4412"};
tapper_vec = [0.25 0.5 0.75 1];

sim_counter = 0;

for ii = 1:length(airfoils_vec)
for jj = 1:length(tapper_vec)
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
    lambda_chord = tapper_vec(jj);

    sim_counter = sim_counter + 1;
   

    sim_file = airfoil_name + "_tapper_" + num2str(lambda_chord);
    sim_file = strrep(sim_file, '.', '_') + ".mat";
    % disp(sim_file)

    fprintf("Running simulation no.  %d - %s | lambda = %.2f [%s]\n", ...
    sim_counter, airfoil_name, lambda_chord, char(sim_file))

    multiple_sims_init_inputs
    out = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);

    save(sim_file, "out")
end
end

elapsed_time = toc;
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = mod(elapsed_time, 60);

fprintf("\n\nElapsed time: %02d:%02d:%05.2f (HH:MM:SS)\n", hours, minutes, seconds);


