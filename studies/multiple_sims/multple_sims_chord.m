clc
clear
close all

tic

airfoils_vec = {"naca2412", "n0012", "mh78"};
lambda_vec = [0.05 0.25 0.5 0.75 1];
RootBladeDistance_vec = [0 0.05 0.1 0.2 0.3];
lambda_vec = [0.05 0.25 0.5 0.75 1];
twist_vec = [0 5 10 15];

sim_counter = 0;

for ii = 1:length(airfoils_vec)
for jj = 1:length(lambda_vec)
for kk = 1:length(lambda_vec)
for ll = 1:length(lambda_vec)
    % Constantes da simulação
    Nb = 4;
    Span = 1;
    root_theta = -10;
    root_chord = 0.17;

    dt = 0.025;
    t_deploy_rotor = 3;
    mass_payload = 20;

    % Parâmetros variáveis
    airfoil_name = airfoils_vec{ii};  % corrigido: acesso ao conteúdo da célula
    RootBladeDistance =RootBladeDistance_vec(kk);
    blade_twist_rate = twist_vec_(ll);
    lambda_chord = lambda_vec(jj);

    sim_counter = sim_counter + 1;

    sim_file = airfoil_name + "_lambdachord_" + num2str(lambda_chord) + ".mat";
    disp(sim_file)
    fprintf("Running simulation no.  %d - %s | e = %.3f | twist = %.3f | lambda = %.3f\n", ...
        sim_counter, airfoil_name, RootBladeDistance, blade_twist_rate, lambda_chord)

    multiple_sims_init_inputs
    out = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);

    save(sim_file, "out")


end
end
end
end

elapsed_time = toc;
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = mod(elapsed_time, 60);

fprintf("\n\nElapsed time: %02d:%02d:%05.2f (HH:MM:SS)\n", hours, minutes, seconds);


