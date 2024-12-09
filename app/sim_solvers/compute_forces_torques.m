function [F_total, F_rotor, F_gravity, F_drag_cilinder, F_blade, T_rotor, T_blade, T_shaft, rotorIsOpen, stall_percentage] ...
    = compute_forces_torques(t, vehicle_position, vehicle_velocity, rotor_velocity, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS, ATMOSPHERE)

F_blade = zeros(3, ROTOR.Nb);
T_blade = zeros(3, ROTOR.Nb);
stall_percentage = zeros(ROTOR.Nb);

F_rotor = [0;0;0];
T_rotor = [0;0;0];
T_shaft = 0;

rotorIsOpen = false;

% Compute Blade Force
if ROTOR.openRotor == true

    if t >= ROTOR.t_deploy_rotor 


        for current_blade = 1:(ROTOR.Nb)
            [F_blade(:, current_blade), T_blade(:, current_blade), stall_percentage(current_blade)] = compute_blade_force(t, vehicle_velocity, rotor_velocity, current_blade, SIM, ROTOR, BLADE, AERODAS, ATMOSPHERE);        
            
        end

        % Compute Rotor Force
        [F_rotor , T_rotor, T_shaft] = total_rotor_forces(F_blade, T_blade);

        rotorIsOpen = true;

    end    

end    


% Compute Gravity Force
F_gravity = gravitic_force(vehicle_position, VEHICLE, EARTH);

% Compute cilinder drag force

if VEHICLE.dragMode == true
    F_drag_cilinder =  cilinder_drag_force(vehicle_velocity, ATMOSPHERE);
else
    F_drag_cilinder = [0;0;0];
end

% ficticious force to test
F_f = [0;0;0];

% Compute total force
F_total = F_gravity + F_drag_cilinder + F_rotor + F_f;

stall_percentage = stall_percentage(1) * 100;

% T_shaft = 0;

end
