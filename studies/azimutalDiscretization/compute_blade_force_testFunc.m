function [OUTPUTS, Force_blade, Torque_blade, stall_percentage, V_tip] = ...
    compute_blade_force_testFunc(R_b_i, V_b, angular_velocity, SIM, OUTPUTS, ROTOR, BLADE, ATMOSPHERE);




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

    VT_e = V_b';

    VR_e = cross(BLADE.pos_sec(i+1, :), angular_velocity)';

    V_e = VT_e + VR_e; % + vi -> IMPLEMENTAR

    % fprintf("\t VTe_x = %.2f | VTe_y = %.2f | VTe_z = %.2f | " + ...
    %     "VRe_x = %.2f | VRe_y = %.2f | VRe_y = %.2f | " + ...
    %     "Ve_x = %.2f | Ve_y = %.2f | Ve_z = %.2f \n", ...
    %     VT_e(1), VT_e(2), VT_e(3), ...
    %     VR_e(1), VR_e(2), VR_e(3),...
    %     V_e(1), V_e(2), V_e(3));
       
    if i+1 == BLADE.No_elements
        V_tip = V_e;
    end

    % blade velocity elements
    U_T(i+1) = V_e(1);
    U_R(i+1) = V_e(2);
    U_P(i+1) = V_e(3);

    if U_T(i+1) < 0
        %escomaento invertido
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

        if SIM.AerodynamicModelSelector == 1

           [Cl(i+1), Cd(i+1), ~] = AerodynamicModel(alpha(i+1), Re(i+1), BLADE.airfoil_data, false);
           
            stallAngle(i+1) = 0;

            % fprintf("Re = %.2e | alpha = %.2f | Cl = %.3f | Cd = %.3f\n", Re(i+1), alpha(i+1), Cl(i+1), Cd(i+1))

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

    elseif element_state(i+1) == 4 || element_state(i+1) == 7

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

% converter as forças elementares para o referencial do rotor

dF = [df_x; df_y; df_z_prandtl];

dF = transpose(R_b_i * dF);


    
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

OUTPUTS.df_x(save_index, :) = df_x;
OUTPUTS.df_y(save_index, :) = df_y;
OUTPUTS.df_z(save_index, :) = df_z;

OUTPUTS.alpha(save_index, :) = alpha;
OUTPUTS.phi(save_index, :) = phi;

OUTPUTS.Cl(save_index, :) = Cl;
OUTPUTS.Cd(save_index, :) = Cd;


OUTPUTS.Ma(save_index, :) = Ma;
OUTPUTS.Re(save_index, :) = Re;



end


