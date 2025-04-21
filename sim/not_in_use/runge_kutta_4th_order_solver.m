function [OUTPUT, rotor_data] = runge_kutta_4th_order_solver (SIM, TIME, VEHICLE, ROTOR, BLADE, EARTH) 



% UP_old = 0;
% induced_velocity_converged = false;

while VEHICLE.position(3) > 0

    fprintf(">> Height: %.4f\n", VEHICLE.position(3));

    [ATMOSPHERE] = atmosphereModel_selector(TIME, SIM, VEHICLE);
  
    % 1st term ------------------------------------------------------------
    SOLVER_INPUT.vehicle_position = VEHICLE.position;
    SOLVER_INPUT.vehicle_velocity = VEHICLE.velocity;

    SOLVER_INPUT.vehicle_orientation = VEHICLE.orientation;
    SOLVER_INPUT.vehicle_ang_velocity = VEHICLE.ang_velocity;
    
    SOLVER_INPUT.rotor_velocity = ROTOR.velocity;

    [F_total, F_rotor, F_gravity, F_drag_cilinder, T_total, T_rotor, rotorIsOpen, rotor_distribution_data] ...
    = compute_forces_torques(SOLVER_INPUT, SIM, TIME, VEHICLE, ROTOR, BLADE, ATMOSPHERE, EARTH);
    
    k1 = (1/VEHICLE.mass) * F_total;
    m1 = ROTOR.II_inv * (T_total - cross(VEHICLE.ang_velocity,  ROTOR.II * VEHICLE.ang_velocity));

    p1 = T_rotor(1) / ROTOR.II(3, 3);

    % fprintf("\t- F_total = (%.2f, %.2f, %.2f) | F_rotor = (%.2f, %.2f, %.2f) | T_total = (%.2f, %.2f, %.2f) | T_rotor = (%.2f, %.2f, %.2f)\n", F_total, F_rotor, T_total, T_rotor);
    % fprintf("\t- k1 = (%.2f, %.2f, %.2f) | m1 = (%.2f, %.2f, %.2f) | p1 = %.2f\n", k1, m1, p1);

    VEHICLE.acceleration = k1;
    VEHICLE.angular_acceleration = m1;
    
    
    if rotorIsOpen     
        rotor_data_vec = [rotor_data_vec; rotor_distribution_data];
        rotor_data_time = [rotor_data_time TIME.clock];
    end


    % 2nd terms -------------------------------------------------------
    SOLVER_INPUT.vehicle_position = VEHICLE.position + 1/2 * k1 * TIME.dt;
    SOLVER_INPUT.vehicle_velocity = VEHICLE.velocity + 1/2 * k1 * TIME.dt;

    SOLVER_INPUT.vehicle_vehicle_orientation = VEHICLE.orientation + 1/2 * m1 * TIME.dt;
    SOLVER_INPUT.vehicle_ang_velocity = VEHICLE.ang_velocity + 1/2 * m1 * TIME.dt;

    SOLVER_INPUT.rotor_velocity = ROTOR.velocity + 1/2 * p1 * TIME.dt;
    
    [F_total_2, ~, ~, ~, T_total_2, T_rotor_2, ~, ~] ...
    = compute_forces_torques(SOLVER_INPUT, SIM, TIME, VEHICLE, ROTOR, BLADE, ATMOSPHERE, EARTH);
    
    k2 = (1/VEHICLE.mass) * F_total_2;
    m2 = ROTOR.II_inv * (T_total_2 - cross(VEHICLE.ang_velocity,  ROTOR.II * VEHICLE.ang_velocity));

    p2 = T_rotor_2(1) / ROTOR.II(3, 3);

    % fprintf("\t- F_total = (%.2f, %.2f, %.2f) | T_total = (%.2f, %.2f, %.2f) | T_rotor = (%.2f, %.2f, %.2f)\n", F_total_2, T_total_2, T_rotor_2)
    % fprintf("\t- k2 = (%.2f, %.2f, %.2f) | m2 = (%.2f, %.2f, %.2f) | p2 = %.2f\n", k2, m2, p2);

    % 3rd term ------------------------------------------------------------
    SOLVER_INPUT.position = VEHICLE.position + 1/2 * k2 * TIME.dt;
    SOLVER_INPUT.velocity = VEHICLE.velocity + 1/2 * k2 * TIME.dt;

    SOLVER_INPUT.orientation = VEHICLE.orientation + 1/2 * m2 * TIME.dt;
    SOLVER_INPUT.ang_velocity = VEHICLE.ang_velocity + 1/2 * m2 * TIME.dt;

    SOLVER_INPUT.rotor_velocity = ROTOR.velocity + 1/2 * p2 * TIME.dt;
        
    [F_total_3, ~, ~, ~, T_total_3, T_rotor_3, ~, ~] ...
    = compute_forces_torques(SOLVER_INPUT, SIM, TIME, VEHICLE, ROTOR, BLADE, ATMOSPHERE, EARTH);
    
    k3 = (1/VEHICLE.mass) * F_total_3;
    m3 = ROTOR.II_inv * (T_total_3 - cross(VEHICLE.ang_velocity,  ROTOR.II * VEHICLE.ang_velocity));
    p3 = T_rotor_3(1) / ROTOR.II(3, 3);

    % fprintf("\t- F_total = (%.2f, %.2f, %.2f) | T_total = (%.2f, %.2f, %.2f) | T_rotor = (%.2f, %.2f, %.2f)\n", F_total_3, T_total_3, T_rotor_3)
    % fprintf("\t- k3 = (%.2f, %.2f, %.2f) | m3 = (%.2f, %.2f, %.2f) | p3 = %.2f\n", k3, m3, p3);
    
    % 4th terms -----------------------------------------------------------
    SOLVER_INPUT.vehicle_position = VEHICLE.position + k3 * TIME.dt;
    SOLVER_INPUT.vehicle_velocity = VEHICLE.velocity + k3 * TIME.dt;

    SOLVER_INPUT.vehicle_orientation = VEHICLE.orientation + m3 * TIME.dt;
    SOLVER_INPUT.vehicle_ang_velocity = VEHICLE.ang_velocity + m3 * TIME.dt; 

    SOLVER_INPUT.rotor_velocity = ROTOR.velocity + 1/2 * p3 * TIME.dt;
    
    [F_total_4, ~, ~, ~, T_total_4, T_rotor_4, ~, ~] ...
    = compute_forces_torques(SOLVER_INPUT, SIM, TIME, VEHICLE, ROTOR, BLADE, ATMOSPHERE, EARTH);

    k4 = (1/VEHICLE.mass) * F_total_4;
    m4 = ROTOR.II_inv * (T_total_4 - cross(VEHICLE.ang_velocity,  ROTOR.II * VEHICLE.ang_velocity));
    p4 = T_rotor_4(1) / ROTOR.II(3, 3);

    % fprintf("\t- F_total = (%.2f, %.2f, %.2f) | T_total = (%.2f, %.2f, %.2f) | T_rotor = (%.2f, %.2f, %.2f)\n", F_total_4, T_total_4, T_rotor_4)
    % fprintf("\t- k4 = (%.2f, %.2f, %.2f) | m4 = (%.2f, %.2f, %.2f) | p4 = %.2f\n\n", k4, m4, p4);

    % VEHICLE LINEAR POSITION -----------------------------------------------------
    l1 = VEHICLE.velocity;
    l2 = VEHICLE.velocity + 1/2 * k1;
    l3 = VEHICLE.velocity + 1/2 * k2;
    l4 = VEHICLE.velocity + k3;

    % ANGULLAR POSITION -----------------------------------------------------

    phi = VEHICLE.orientation(1);
    theta = VEHICLE.orientation(2);

    RR = [1   tand(theta)*sind(phi)   tand(theta)*cosd(phi);
          0   cosd(phi)               -sind(phi);
          0   sind(phi)/cosd(theta)   cosd(phi)/cosd(theta)];
    
    n1 = RR * VEHICLE.ang_velocity;
    n2 = RR * VEHICLE.ang_velocity + 1/2 * m1;
    n3 = RR * VEHICLE.ang_velocity + 1/2 * m2;
    n4 = RR * VEHICLE.ang_velocity + m3;
      
    %  VEHICLE DYNAMICS ---------------------------------------------------
    
    VEHICLE.velocity = VEHICLE.velocity + (1/6) * (k1 + 2 * k2 + 2 * k3 + k4) * TIME.dt; 
    VEHICLE.position = VEHICLE.position + (1/6) * (l1 + 2 * l2 + 2 * l3 + l4) * TIME.dt;    
    
    VEHICLE.ang_velocity = VEHICLE.ang_velocity + (1/6) * (m1 + 2 * m2 + 2 * m3 + m4) * TIME.dt;
    VEHICLE.orientation = VEHICLE.orientation + (1/6) * (n1 + 2 * n2 + 2 * n3 + n4) * TIME.dt;
    
    % ROTOR DYNAMICS
    ROTOR.velocity = ROTOR.velocity + (1/6) * (p1 + 2 * p2 + 2 * p3 + p4) * TIME.dt;
  
    % UPDATE TIME
    TIME.clock = TIME.clock + TIME.dt;

    % UPDATE PROGRESS BAR
    update_progressBar(VEHICLE, ROTOR, rotorIsOpen)

    OUTPUT = saveAsOUTPUT(OUTPUT, TIME, VEHICLE, ROTOR, ATMOSPHERE, ...
        F_total, F_rotor, F_gravity, F_drag_cilinder, T_total, T_rotor);
    
end

rotor_data.data =  rotor_data_vec;
rotor_data.time = rotor_data_time;


end


% while ~induced_velocity_converged 
% if TIME.clock >= TIME.t_deploy_rotor
%     [ROTOR.induced_velocity, induced_velocity_converged, UP_old, error_induced_velocity] = compute_induced_velocity(UP_old, VEHICLE, ATMOSPHERE);
% else
%     ROTOR.induced_velocity = [0;0;0];
%     induced_velocity_converged = true;
%     error_induced_velocity = -1;
% end
% end
% fprintf("converged - %.4f\n", error_induced_velocity);


