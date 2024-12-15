clc
clear
close all


% -------------------------------------------------------------------------
% Estes são os inputs que devem ser dados com entrada da função
% Servem para definir as condições da dinâmica, às quais o rotor está
% sujeito naquele instante

% Velocidade do sistema no referencia inercial
V_i = [0; 10; 10];

% Velocidade angular do rotor sobre o seu próprio referencial
RPM = 1000;
angular_velocity = [0; 0; RPM*pi/180];

v_induced = [0; 0; 0];

% Orientação do rotor relativamente ao referencial inercial
orientation = [0; 0; 0]; %  yaw | pitch | roll 

% -------------------------------------------------------------------------
% Inicialização da variáveis gerais do simulador

SIM.AerodynamicModelSelector = 1;
SIM.atmosphereModelSelector = 2;

OUTPUTS.U_T=[];
OUTPUTS.U_R=[];
OUTPUTS.U_P=[];
OUTPUTS.flowMode=[];
OUTPUTS.df_x=[];
OUTPUTS.df_y=[];
OUTPUTS.df_z=[];
OUTPUTS.alpha=[];
OUTPUTS.phi=[];
OUTPUTS.element_state=[];
OUTPUTS.Ma=[];
OUTPUTS.Re=[];
OUTPUTS.Cd=[];
OUTPUTS.Cl=[];

ROTOR.Nb = 5;
ROTOR.azimutal_points = 500;
ROTOR.azimutal_positions = azimutalDescretization(ROTOR.azimutal_points, 0);

% a matriz R_r_b é uma matriz constante ao longo do tempo
for k = 1:length(ROTOR.azimutal_positions)    
    ROTOR.R_r_b(:, :, k) = rotationMatrix_generator(ROTOR.azimutal_positions(k), 0, 0);
end

BLADE.chord = 0.1;
BLADE.Span = 1;
BLADE.No_elements = 75;
BLADE.prandtlTipLosses = false;
BLADE.dy = BLADE.Span / BLADE.No_elements;
BLADE.RootBladeDistance = 0;%.1;
BLADE.twistDistribution = 1;
BLADE.root_theta = -10;
BLADE.tip_theta = 10;
BLADE.dA = BLADE.dy * BLADE.chord;

BLADE.pos_sec = (0:BLADE.No_elements) * BLADE.dy + BLADE.RootBladeDistance;
BLADE.pos_sec = [zeros(length(BLADE.pos_sec), 1), BLADE.pos_sec', zeros(length(BLADE.pos_sec), 1)];

BLADE.theta = twist_distribution(BLADE, ROTOR);

airfoil = load('./airfoils/naca0012.mat').airfoil;

BLADE.airfoil_name = airfoil.name;
BLADE.airfoil_data = airfoil.data;

ATMOSPHERE = atmosphereModel(0, SIM);

%--------------------------------------------------------------------------
% Início da função

Force_blade = zeros(ROTOR.azimutal_points, 3);
Tb_b = zeros(ROTOR.azimutal_points, 3);


R_i_b = rotationMatrix_generator(orientation(1), orientation(2), orientation(3));
R_b_i = transpose(R_i_b);

for azimute_index = 1:length(ROTOR.azimutal_positions)

    % fprintf("> Azimute: %.2f\n", azimutal_positions(azimute_index)*180/pi)

    V_b(azimute_index, :) = ROTOR.R_r_b(:, :, azimute_index) *   R_i_b * V_i;

    % fprintf("Vb_x = %.2f | Vb_y = %.2f | Vb_z = %.2f \n", V_b(azimute_index, :));

   [OUTPUTS, ~, ~, ~, ~] = ...
        compute_blade_force_testFunc(R_b_i, V_b(azimute_index, :), v_induced, angular_velocity, SIM, OUTPUTS, ROTOR, BLADE, ATMOSPHERE);

end


%% Gráficos AZIMUTAIS

close all

polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.U_T, "Velocidade Tangencial", "m/s", "1-vel_tangencial.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.U_R, "Velocidade Radial", "m/s", "2-vel_radial.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.U_P, "Velocidade Vertical", "m/s", "3-vel_vertical.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.flowMode, "Flow Direction", "", "4-flow_direction.jpg")

polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.df_x, "Força em X", "N", "5-f_x.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.df_y, "Força em Y", "N", "6-f_y.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.df_z, "Força em z", "N", "7-f_z.jpg")

polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.alpha, "Angle Of Attack", "deg", "8-aoa.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.phi, "Incidence Angle", "deg", "9-incidence_angle.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.element_state, "Element State", "", "10-elemente_state.jpg")


polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.Re, "Re", "", "11-re.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.Ma, "Ma", "", "12-ma.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.Cl, "Cl", "", "13-cl.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.Cd, "Cd", "", "14-cd.jpg")

polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.f_prandtl, "F. Prandtl", "", "15-f_prandtl.jpg")
