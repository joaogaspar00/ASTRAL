clc
clear
close all

tic

init_height_vec = [10000 20000 50000 60000 75000];

sim_counter = 0;

t = zeros(length(init_height_vec));
v = zeros(length(init_height_vec));
rpm = zeros(length(init_height_vec));
f_max = zeros(length(init_height_vec));
t_max = zeros(length(init_height_vec));

for jj = 1:length(init_height_vec)
    
    % Constantes da simulação   
    
    Nb = 4;
    Span = 1 ;
    root_theta = -10;
    root_chord = 0.17;

    init_height = init_height_vec(jj);
    init_vel = -50;
    dt = 0.05;
    time_limit_sim = Inf;

    t_deploy_rotor = 1;

    mass_payload = 20;
                    

    % Parâmetros variáveis
    airfoil_name = "n0012";
    RootBladeDistance = 0;
    blade_twist_rate = 0;
    lambda_chord = 1;

    sim_counter = sim_counter + 1;

    fprintf("Running simulation no. %d - %s | h = %.2f\n", ...
        sim_counter, airfoil_name, init_height)

    multiple_sims_init_inputs
    out = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);

    t(jj) = out.main_clock(end);

    v(jj) = out.vehicle_velocity(end, 3);
    rpm(jj) = out.rotor_velocity(end);

    f_max(jj) = out.F_rotor(end, 3);
    t_max(jj) = out.T_rotor(end);

    % Geração do nome do ficheiro com substituição de '.' por '_'
    filename_raw = sprintf("sim_%s_h_%.0f", airfoil_name, init_height);
    filename = strrep(filename_raw, '.', '_') + ".mat"

    fprintf("\t >> saving to %s\n", filename)

    % save(filename, "out");  % descomenta quando tiveres o 'out'

end

save("multiple_sims_results_height.mat", "t", "v", "rpm", "f_max", "t_max")

elapsed_time = toc;
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = mod(elapsed_time, 60);

fprintf("\n\nElapsed time: %02d:%02d:%05.2f (HH:MM:SS)\n", hours, minutes, seconds);
