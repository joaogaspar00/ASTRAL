clc
clear
close all

tic


rootcut_out = [0 0.02 0.05 0.1 0.15 0.2 0.25 0.3];

sim_counter = 0;

for ii = 1:length(rootcut_out)
    % Constantes da simulação
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
    airfoil_name = "n0012";  % corrigido: acesso ao conteúdo da célula
    RootBladeDistance = rootcut_out(ii);
    blade_twist_rate = 0;
    lambda_chord = 1;

    sim_counter = sim_counter + 1;

    sim_file = "rootcut_case1_" + num2str(rootcut_out(ii)) + ".mat";
    sim_file = strrep(sim_file, '.', '_') + ".mat";

    disp(sim_file)

    fprintf("Running simulation no.  %d - %s | e = %.3f | r = %.3f \n", ...
        sim_counter, airfoil_name, RootBladeDistance, Span)

    multiple_sims_init_inputs
    out = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);

    save(sim_file, "out")

end

elapsed_time = toc;
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = mod(elapsed_time, 60);

fprintf("\n\nElapsed time: %02d:%02d:%05.2f (HH:MM:SS)\n", hours, minutes, seconds);


