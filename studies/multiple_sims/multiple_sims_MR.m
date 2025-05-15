clc
clear
close all

tic

airfoils_vec = {"n0012", "naca2412", "mh78"};
root_vec = [0];
twist_vec = [0];
lambda_vec = [1];

MR = [10 20 50 75 100 150 200 250];

sim_counter = 0;

t = zeros(length(airfoils_vec), length(root_vec), length(twist_vec), length(lambda_vec));
v = zeros(length(airfoils_vec), length(root_vec), length(twist_vec), length(lambda_vec));
rpm = zeros(length(airfoils_vec), length(root_vec), length(twist_vec), length(lambda_vec));
f_max = zeros(length(airfoils_vec), length(root_vec), length(twist_vec), length(lambda_vec));
t_max = zeros(length(airfoils_vec), length(root_vec), length(twist_vec), length(lambda_vec));

for jj = 1:length(airfoils_vec)
    for kk = 1:length(MR)
    
        % Constantes da simulação   
        
    
        Nb = 4;
        Span = 1 ;
        root_theta = -10;
        root_chord = 0.17;
    
        dt = 0.025;
        time_limit_sim = Inf;
    
        t_deploy_rotor = 3;
    
        mass_payload = MR(kk) * Span;
                        
    
        % Parâmetros variáveis
        airfoil_name = airfoils_vec{jj};
        RootBladeDistance = root_vec(1);
        blade_twist_rate = twist_vec(1);
        lambda_chord = lambda_vec(1);
    
        sim_counter = sim_counter + 1;
    
        fprintf("Running simulation no. %d - %s | R = %.2f | M = %.2f | RM %.2f\n", ...
            sim_counter, airfoil_name, Span, mass_payload, MR(kk))
    
        multiple_sims_init_inputs
        out = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);
    
        t(jj, kk, ll, mm) = out.main_clock(end);

        v(jj, kk, ll, mm) = out.vehicle_velocity(end, 3);
        rpm(jj, kk, ll, mm) = out.rotor_velocity(end);

        f_max(jj, kk, ll, mm) = out.F_rotor(end, 3);
        t_max(jj, kk, ll, mm) = out.T_rotor(end);
    
        % Geração do nome do ficheiro com substituição de '.' por '_'
        filename_raw = sprintf("sim_%s_RM_%.2f", airfoil_name, MR(kk));
        filename = strrep(filename_raw, '.', '_') + ".mat";
    
        fprintf("\t >> saving to %s\n", filename)
    
        % save(filename, "out");  % descomenta quando tiveres o 'out'
    end
end

save("multiple_sims_results_MR.mat", "t", "v", "rpm", "f_max", "t_max")

elapsed_time = toc;
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = mod(elapsed_time, 60);

fprintf("\n\nElapsed time: %02d:%02d:%05.2f (HH:MM:SS)\n", hours, minutes, seconds);
