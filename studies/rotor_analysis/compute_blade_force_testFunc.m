function [OUTPUTS, Force_blade, Torque_blade] = compute_blade_force_testFunc(OUTPUTS, VEHICLE, ROTOR, BLADE, SIM, ATMOSPHERE)

% forces and moments vectores
df_x = zeros(1, BLADE.No_elements+1);
df_y = zeros(1, BLADE.No_elements+1);
df_z = zeros(1, BLADE.No_elements+1);

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

    VT_e = VEHICLE.velocity_b';

    VR_e = cross(BLADE.pos_sec(i+1, :), VEHICLE.angular_velocity)';

    V_e = VT_e + VR_e + ROTOR.v_induced;

    if i+1 == BLADE.No_elements
        V_tip = V_e;
    end

    % blade velocity elements
    U_T(i+1) = V_e(1);
    U_R(i+1) = V_e(2);
    U_P(i+1) = V_e(3);


    if U_T(i+1) < 0
        flowMode(i+1) = 1;
    else
        flowMode(i+1) = 0;
    end

     % incident velocity
    total_v(i+1) = sqrt(U_T(i+1)^2 + U_P(i+1)^2);
    
    % get AOA and inflow angle
    [alpha(i+1), phi(i+1), element_state(i+1)] = getFlowAngles(U_T(i+1), U_P(i+1), BLADE.theta(i+1));

     % mach number
    Ma(i+1) = total_v(i+1)/(sqrt(1.4*287.053*ATMOSPHERE.temperature));
    
    % reynolds number
    Re(i+1) = ReynoldsNumber_func(ATMOSPHERE.density, total_v(i+1), BLADE.chord, ATMOSPHERE.kinematicViscosity);
    
    % if i == BLADE.No_elements
    %     fprintf("tip re = %.2E | rho = %.2E | V = %.3f | c = %.3f | mu = %.2E \n", Re(i+1), ATMOSPHERE.density, total_v(i+1), BLADE.chord, ATMOSPHERE.kinematicViscosity);
    % end

    % aeroBLADE.dynamic coefficients
    if total_v(i+1) == 0  || isnan(total_v(i+1))
        Cl(i+1) = 0;
        Cd(i+1) = 0;
    else

        [Cl(i+1), Cd(i+1), ~] = AerodynamicModel(alpha(i+1), Re(i+1), BLADE.airfoil_data, false);
           
        stallAngle(i+1) = 0;      
           
    end    
    
    % element aeroBLADE.dynamic forces
    dL(i+1) = 1/2 * ATMOSPHERE.density * (total_v(i+1)^2) * Cl(i+1) * BLADE.dA;
    dD(i+1) = 1/2 * ATMOSPHERE.density * (total_v(i+1)^2) * Cd(i+1) * BLADE.dA;

    % element force in aerodynamic reference frame
    dF_a(:, i+1) = [dD(i+1); 0; dL(i+1)];
    

    % from aerodynamic reference frame to element reference frame
    Rt_e_a =  rotationMatrix_generator(0, phi(i+1), 0);
    Rt_e_a = [-1 0 0; 0 1 0; 0 0 1] * Rt_e_a;
    Rt_a_e = transpose(Rt_e_a);
    
    % element force in element reference frame
    dF_e(:, i+1) =  Rt_a_e * dF_a(:, i+1);

end



if BLADE.prandtlTipLosses == true
    f_prandtl = prandtl_function(phi(1), phi(end), ROTOR, BLADE);   
else
    f_prandtl = ones(1, length(df_z));
end

% df_z_prandtl = df_z .* f_prandtl;

dF_b = dF_e;

% converter as forças elementares para o referencial do rotor
dF = transpose(BLADE.R_b_i * dF_b);
    
f_x = sum(dF(:, 1));
f_y = sum(dF(:, 2));
f_z = sum(dF(:, 3));


dtau_x =  dF(:, 1) .* BLADE.pos_sec(i+1, 1);
dtau_y =  dF(:, 2) .* BLADE.pos_sec(i+1, 2);
dtau_z =  dF(:, 3) .* BLADE.pos_sec(i+1, 3);

tau_x = sum(dtau_x);
tau_y = sum(dtau_y);
tau_z = sum(dtau_z);

Force_blade = [f_x; f_y; f_z];
Torque_blade = [tau_x; tau_y; tau_z];

stall_percentage = sum(stallMode)/(BLADE.No_elements + 1);


if isempty(OUTPUTS.U_T)
    save_index = 1;
else
    save_index = length(OUTPUTS.U_T(:,1)) + 1;
end

OUTPUTS.U_T(save_index, :) = U_T;
OUTPUTS.U_R(save_index, :) = U_R;
OUTPUTS.U_P(save_index, :) = U_P;
OUTPUTS.flowMode(save_index, :) = flowMode;

OUTPUTS.df_x(save_index, :) = dF(:, 1);
OUTPUTS.df_y(save_index, :) = dF(:, 2);
OUTPUTS.df_z(save_index, :) = dF(:, 3);

OUTPUTS.alpha(save_index, :) = alpha;
OUTPUTS.phi(save_index, :) = phi;

OUTPUTS.element_state(save_index, :) = element_state;

OUTPUTS.Cl(save_index, :) = Cl;
OUTPUTS.Cd(save_index, :) = Cd;


OUTPUTS.Ma(save_index, :) = Ma;
OUTPUTS.Re(save_index, :) = Re;

OUTPUTS.f_prandtl(save_index, :) = f_prandtl;



end


