function [s_t, s_y] = runge_kutta_4th_order_solver (SIM, TIME, VEHICLE, EARTH, BLADE, ROTOR, AERODAS)  

global sim_data

sim_data.iterationCounter = 1;

vehicle_velocity = [0;0;0];
vehicle_position = [0;0;VEHICLE.init_height];


rotor_velocity = 0;
rotor_position = 0;

t = 0;
s_t = [];
s_y = [];



while vehicle_position(3) > 0

    ATMOSPHERE = atmosphereModel(vehicle_position(3), SIM);


    p_in = vehicle_position;
    v_in = vehicle_velocity;
    r_vel_in = rotor_velocity;

    [F_total, F_rotor, F_gravity, F_drag_cilinder, ~, T_rotor, ~, T_shaft, rotorIsOpen, stall_percentage] ...
    = compute_forces_torques(t, p_in, v_in, r_vel_in, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS, ATMOSPHERE);
        
    k1 = (1/VEHICLE.M) * F_total;
    m1 = T_shaft/ROTOR.I_rotor;
    
    % 2nd terms
    p_in = vehicle_position + 1/2 * k1 * TIME.dt;
    v_in = vehicle_velocity + 1/2 * k1 * TIME.dt;
    r_vel_in = rotor_velocity + 1/2 * m1 * TIME.dt;
    
    [F_total_2, ~, ~, ~, ~, ~, ~, T_shaft_2, ~] ...
    = compute_forces_torques(t, p_in, v_in, r_vel_in, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS, ATMOSPHERE);
    
    k2 = (1/VEHICLE.M) * F_total_2;
    m2 = T_shaft_2/ROTOR.I_rotor;
    
    % 3rd term
    p_in = vehicle_position + 1/2 * k2 * TIME.dt;
    v_in = vehicle_velocity + 1/2 * k2 * TIME.dt;
    r_vel_in = rotor_velocity + 1/2 * m2 * TIME.dt;
    
    [F_total_3, ~, ~, ~, ~, ~, ~, T_shaft_3, ~] ...
    = compute_forces_torques(t, p_in, v_in, r_vel_in, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS, ATMOSPHERE);
    
    k3 = (1/VEHICLE.M) * F_total_3;
    m3 = T_shaft_3/ROTOR.I_rotor;
    
    % 4th terms
    p_in = vehicle_position + k3 * TIME.dt;
    v_in = vehicle_velocity + k3 * TIME.dt;
    r_vel_in = rotor_velocity + m3 * TIME.dt;
    
    [F_total_4, ~, ~, ~, ~, ~, ~, T_shaft_4, ~] ...
    = compute_forces_torques(t, p_in, v_in, r_vel_in, SIM, VEHICLE, EARTH, BLADE, ROTOR, AERODAS, ATMOSPHERE);
    
    k4 = (1/VEHICLE.M) * F_total_4;
    m4 = T_shaft_4/ROTOR.I_rotor;

    % LINEAR POSITION
    l1 = vehicle_velocity;
    l2 = vehicle_velocity + 1/2 * k1;
    l3 = vehicle_velocity + 1/2 * k2;
    l4 = vehicle_velocity + k3;
    
    
    % ANGULAR POSITION
    n1 = rotor_velocity;
    n2 = rotor_velocity + 1/2 * n1;
    n3 = rotor_velocity + 1/2 * n2;
    n4 = rotor_velocity + n3;


    % EQUATIONS

    % LINEAR ACCELERATION
    vehicle_acceleration = k1;
    
    %  VEHICLE DYNAMICS 
    vehicle_velocity = vehicle_velocity + (1/6) * (k1 + 2 * k2 + 2 * k3 + k4) * TIME.dt;
    vehicle_position = vehicle_position + (1/6) * (l1 + 2 * l2 + 2 * l3 + l4) * TIME.dt;

    % ROTOR ANGULAR ACCELERATION
    rotor_acceleration = m1;

    % ROTOR DYNAMICS
    
    rotor_velocity = rotor_velocity + (1/6) * (m1 + 2 * m2 + 2 * m3 + m4) * TIME.dt;
    rotor_position = rotor_position + (1/6) * (n1 + 2 * n2 + 2 * n3 + n4) * TIME.dt;
    
    rotor_position = mod(rotor_position, 2*pi);


    I_cilindro = (1/2) * VEHICLE.M * 1^2; % Momento de inércia do cilindro
    dw = T_rotor / (ROTOR.I_rotor + I_cilindro); % Aceleração angular total

    % SAVE VECTORES

    s_t(sim_data.iterationCounter) = t;

    s_y(sim_data.iterationCounter, 1:3) = vehicle_position;
    s_y(sim_data.iterationCounter, 4:6) = vehicle_velocity;
   
    s_y(sim_data.iterationCounter, 7:9) = [0;0;0];
    s_y(sim_data.iterationCounter, 10:12) = [0;0;0];

    s_y(sim_data.iterationCounter, 13) = rotor_position;
    s_y(sim_data.iterationCounter, 14) = rotor_velocity; 



    sim_data.height = [sim_data.height; vehicle_position(3)];
    sim_data.t = [sim_data.t; t];    
    sim_data.a = [sim_data.a; vehicle_acceleration'];
    sim_data.dw = [sim_data.dw; dw'];
    
    sim_data.rotor_acceleration = [sim_data.rotor_acceleration; rotor_acceleration'];
    
    sim_data.rotor_torque = [sim_data.rotor_torque;T_rotor'];
    
    sim_data.t_shaft = [sim_data.t_shaft; T_shaft];

    sim_data.stall_percentage = [sim_data.stall_percentage ; stall_percentage];
    
    sim_data.F_rotor = [sim_data.F_rotor; F_rotor'];
    sim_data.F_g = [sim_data.F_g; F_gravity'];
    sim_data.F_drag_cilinder = [sim_data.F_drag_cilinder; F_drag_cilinder'];
    sim_data.F_total = [sim_data.F_total; F_total'];


    % UPDATE TIME
    t = t + TIME.dt;

    % UPDATE PROGRESS BAR
    update_progressBar(vehicle_position(3), F_rotor(3), rotor_velocity, VEHICLE, rotorIsOpen)
    sim_data.iterationCounter = sim_data.iterationCounter + 1;



end