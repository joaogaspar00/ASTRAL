clc
clear
close all

tic

twist_vec = [0 12 15 10 10 22 25];

sim_counter = 0;

for jj = 1:length(twist_vec)

    Nb = 4;
    Span = 1;
    root_theta = -20;
    root_chord = 0.17;

    init_height = 500;
    init_vel = 0;
    dt = 0.025;
    t_deploy_rotor = 3;
    mass_payload = 20;

    time_limit_sim = inf;

    airfoil_name = "n0012";
    RootBladeDistance = 0;
    blade_twist_rate = twist_vec(jj);
    lambda_chord = 1;

    sim_counter = sim_counter + 1;

    sim_file = "twist_" + num2str(blade_twist_rate) + ".mat";
    sim_file = strrep(sim_file, '.', '_') + ".mat";

    fprintf("Running simulation no.  %d - %s | e = %.3f | twist = %.3f | lambda = %.3f\n", ...
        sim_counter, airfoil_name, RootBladeDistance, blade_twist_rate, lambda_chord)

    multiple_sims_init_inputs
    out = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);

    save(sim_file, "out")

end

elapsed_time = toc;
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = mod(elapsed_time, 60);

fprintf("\n\nElapsed time: %02d:%02d:%05.2f (HH:MM:SS)\n", hours, minutes, seconds);


