function [Force_blade, Torque_blade, stall_percentage] = ...
    compute_blade_force(t, velocity, rotor_angular_velocity, current_blade, SIM, ROTOR, BLADE, AERODAS, ATMOSPHERE)


global sim_data

% forces and moments vectores
df_x = zeros(1, BLADE.No_elements+1);
df_y = zeros(1, BLADE.No_elements+1);
df_z = zeros(1, BLADE.No_elements+1);

v_x = velocity(1)*ones(1, BLADE.No_elements+1);
v_y = velocity(2)*ones(1, BLADE.No_elements+1);
v_z = velocity(3)*ones(1, BLADE.No_elements+1);

ang_v = zeros(1, BLADE.No_elements+1);
total_v = zeros(1, BLADE.No_elements+1);

dL = zeros(1, BLADE.No_elements+1);
dD = zeros(1, BLADE.No_elements+1);

phi = zeros(1, BLADE.No_elements+1);
alpha = zeros(1, BLADE.No_elements+1);

element_state = zeros(1, BLADE.No_elements+1);

Ma = zeros(1, BLADE.No_elements+1);  
Re = zeros(1, BLADE.No_elements+1);

Cl = zeros(1, BLADE.No_elements+1);
Cd = zeros(1, BLADE.No_elements+1);

U_T = zeros(1, BLADE.No_elements+1);
U_R = zeros(1, BLADE.No_elements+1);
U_P = zeros(1, BLADE.No_elements+1);

stallAngle = zeros(1, BLADE.No_elements+1);
stallMode = zeros(1, BLADE.No_elements+1);
     
for i = 0:1:BLADE.No_elements
    
    % element angular velocity
    ang_v(i+1) = rotor_angular_velocity * BLADE.pos_sec(i+1);

    % blade velocity value
    vel_element = velocity + [ang_v(i+1);0;0];
   
    % blade velocity elements
    U_T(i+1) = vel_element(1);
    U_R(i+1) = vel_element(2);
    U_P(i+1) = vel_element(3);

     % incident velocity
    total_v(i+1) = sqrt(U_T(i+1)^2 + U_P(i+1)^2);
    
    % get AOA and inflow angle
    [alpha(i+1), phi(i+1), element_state(i+1)] = getFlowAngles(U_T(i+1), U_P(i+1), BLADE.theta(i+1));

     % mach number
    Ma(i+1) = total_v(i+1)/(sqrt(1.4*287.053*ATMOSPHERE.temperature));
    
    % reynolds number
    Re(i+1) = ReynoldsNumber_func(ATMOSPHERE.density, total_v(i+1), ROTOR.chord, ATMOSPHERE.kinematicViscosity);
    % 
    % if i == BLADE.No_elements
    %     fprintf("tip re = %.2E | rho = %.2E | V = %.3f | c = = %.3f | mu = %.2E \n", Re(i+1), ATMOSPHERE.density, total_v(i+1), ROTOR.chord, ATMOSPHERE.kinematicViscosity);
    % end

    % aeroBLADE.dynamic coefficients
    if total_v(i+1) == 0  || isnan(total_v(i+1))
        Cl(i+1) = 0;
        Cd(i+1) = 0;
    else

        if SIM.AerodynamicModelSelector == 1

           [Cl(i+1), Cd(i+1), stallAngle(i+1)] = AERODAS_model(alpha(i+1), Re(i+1), AERODAS.data, false);        

           
            % if Cl(i+1) > 3
            %     fprintf(".. Requesting Neural foil: Re = %.2E | Alpha = %.4f\n", Re(i+1), alpha(i+1))
            %     [Cl(i+1), Cd(i+1)] = NeuralFoil("naca0012", Re(i+1), 0, alpha(i+1));
            % end

           

        else

            [Cl(i+1), Cd(i+1)] = NeuralFoil("naca0012", Re(i+1), 0, alpha(i+1));

            stallAngle(i+1) = 0;
       
        end       
           
    end

    
    
    
   
    

    % element aeroBLADE.dynamic forces
    dL(i+1) = 1/2 * ATMOSPHERE.density * (total_v(i+1)^2) * Cl(i+1) * BLADE.dA;
    dD(i+1) = 1/2 * ATMOSPHERE.density * (total_v(i+1)^2) * Cd(i+1) * BLADE.dA;

    % axis forces
    if element_state(i+1) == 1 || element_state(i+1) == 5

        df_x(i+1) = dL(i+1);
        df_y(i+1) = 0;
        df_z(i+1) = dD(i+1);

    elseif element_state(i+1) == 2 || element_state(i+1) == 6

        df_x(i+1) = - sind(phi(i+1)) * dL(i+1) - cosd(phi(i+1)) * dD(i+1) ;
        df_y(i+1) = 0;
        df_z(i+1) = cosd(phi(i+1)) * dL(i+1) - sind(phi(i+1)) * dD(i+1);

    elseif element_state(i+1) == 3

        df_x(i+1) = - cosd(phi(i+1)) * dD(i+1) ;
        df_y(i+1) = 0;
        df_z(i+1) = - sind(phi(i+1)) * dD(i+1);

    elseif element_state(i+1) == 4

        df_x(i+1) = - sind(phi(i+1)) * dL(i+1) + cosd(phi(i+1)) * dD(i+1) ;
        df_y(i+1) = 0;
        df_z(i+1) = cosd(phi(i+1)) * dL(i+1) - sind(phi(i+1)) * dD(i+1);

    else

        error("Check Forces")
        
    end

    if abs(alpha(i+1)) >= stallAngle(i+1)
        stallMode(i+1) = 1;
    else
        stallMode(i+1) = 0;
    end

end



if BLADE.prandtlTipLosses == true
    f_prandtl = prandtl_function(phi(1), phi(end), ROTOR, BLADE);   
else
    f_prandtl = ones(1, length(df_z));
end
 
df_z_prandtl = df_z .* f_prandtl;
    
f_x = sum(df_x);
f_y = sum(df_y);
f_z = sum(df_z_prandtl);


dtau_x =  df_x .* BLADE.pos_sec;
dtau_y =  df_y .* BLADE.pos_sec;
dtau_z =  df_z_prandtl .* BLADE.pos_sec;

tau_x = sum(dtau_x);
tau_y = sum(dtau_y);
tau_z = sum(dtau_z);

Force_blade = [f_x; f_y; f_z];
Torque_blade = [tau_x; tau_y; tau_z];

stall_percentage = sum(stallMode)/(BLADE.No_elements + 1);

%--------------------------------------------------------------------------

if current_blade == 1
    lastElement_toSave = length(sim_data.b_df_x(1,1,:))+1;

    sim_data.b_time = [sim_data.b_time, t];
else
    lastElement_toSave = length(sim_data.b_df_x(1,1,:));
end

sim_data.b_df_x(current_blade, :, lastElement_toSave) = df_x;
sim_data.b_df_y(current_blade, :, lastElement_toSave) = df_y;
sim_data.b_df_z(current_blade, :, lastElement_toSave) = df_z;

sim_data.b_dtau_x(current_blade, :, lastElement_toSave) = dtau_x;
sim_data.b_dtau_y(current_blade, :, lastElement_toSave) = dtau_y;
sim_data.b_dtau_z(current_blade, :, lastElement_toSave) = dtau_z;

sim_data.b_v_x(current_blade, :, lastElement_toSave) = v_x;
sim_data.b_v_y(current_blade, :, lastElement_toSave) = v_y;
sim_data.b_v_z(current_blade, :, lastElement_toSave) = v_z;

sim_data.b_ang_v(current_blade, :, lastElement_toSave) = ang_v;
sim_data.b_total_v(current_blade, :, lastElement_toSave) = total_v;

sim_data.b_dL(current_blade, :, lastElement_toSave) = dL;
sim_data.b_dD(current_blade, :, lastElement_toSave) = dD;

sim_data.b_alpha(current_blade, :, lastElement_toSave) = alpha;
sim_data.b_theta(current_blade, :, lastElement_toSave) = BLADE.theta;
sim_data.b_phi(current_blade, :, lastElement_toSave) = phi;  % missing `phi` assignment, assuming it exists
sim_data.b_element_state(current_blade, :, lastElement_toSave) = element_state;

sim_data.b_Ma(current_blade, :, lastElement_toSave) = Ma;
sim_data.b_Re(current_blade, :, lastElement_toSave) = Re;

sim_data.b_Cl(current_blade, :, lastElement_toSave) = Cl;
sim_data.b_Cd(current_blade, :, lastElement_toSave) = Cd;

sim_data.b_U_T(current_blade, :, lastElement_toSave) = U_T;
sim_data.b_U_R(current_blade, :, lastElement_toSave) = U_R;
sim_data.b_U_P(current_blade, :, lastElement_toSave) = U_P;

sim_data.b_f_prandtl(current_blade, :, lastElement_toSave) = f_prandtl;

sim_data.b_df_z_prandtl(current_blade, :, lastElement_toSave) = df_z_prandtl;

sim_data.b_stallAngle(current_blade, :, lastElement_toSave) = stallAngle;
sim_data.b_stallMode(current_blade, :, lastElement_toSave) = stallMode;

end


