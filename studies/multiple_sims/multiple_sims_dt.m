clc
clear
close all

tic

dt_vec = [0.1];
sim_counter = 0;

for jj = 1:length(dt_vec)
    
        % Constantes da simulação   
            
        Nb = 4;
        Span = 1 ;
        root_theta = -10;
        root_chord = 0.17;
    
        init_vel = 0;
        init_height = 500;
        dt = dt_vec(jj);
        time_limit_sim = Inf;
    
        t_deploy_rotor = 3;
    
        mass_payload = 20;                        
    
        % Parâmetros variáveis
        airfoil_name = "n0012";
        RootBladeDistance = 0;
        blade_twist_rate = 0;
        lambda_chord = 1;
    
        sim_counter = sim_counter + 1;
    
        fprintf("Running simulation no. %d - dt = %.3f\n", sim_counter, dt);
    
        multiple_sims_init_inputs
        out = run_simulation(SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH);
    
        t(jj) = out.main_clock(end);

        v(jj) = out.vehicle_velocity(end, 3);
        rpm(jj) = out.rotor_velocity(end);

        f_max(jj) = out.F_rotor(end, 3);
        t_max(jj) = out.T_rotor(end);
    
        % Geração do nome do ficheiro com substituição de '.' por '_'
        filename_raw = sprintf("sim_dt_%.3f", airfoil_name, dt_vec(jj));
        filename = strrep(filename_raw, '.', '_') + ".mat";
    
        fprintf("\t >> saving to %s\n", filename)
    
        save(filename, "out");  % descomenta quando tiveres o 'out'
end

save("multiple_sims_results_dt_2.mat", "dt_vec", "t", "v", "rpm", "f_max", "t_max")

elapsed_time = toc;
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = mod(elapsed_time, 60);

fprintf("\n\nElapsed time: %02d:%02d:%05.2f (HH:MM:SS)\n", hours, minutes, seconds);
