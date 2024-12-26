clc
clear
close all

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

% -------------------------------------------------------------------------
% Estes são os inputs que devem ser dados com entrada da função
% Servem para definir as condições da dinâmica, às quais o rotor está
% sujeito naquele instante

% Velocidade do sistema no referencia inercial
VEHICLE.velocity_i = [0; 10; 0];

% Velocidade angular do rotor sobre o seu próprio referencial
VEHICLE.RPM = 1000;
VEHICLE.angular_velocity = [0; 0; VEHICLE.RPM*pi/180];

% Orientação do rotor relativamente ao referencial inercial
VEHICLE.orientation = [0; 0; 0]; %  yaw | pitch | roll 


% -------------------------------------------------------------------------
ROTOR.v_induced = [0; 0; 0];

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
BLADE.RootBladeDistance = 0.25;
BLADE.twistDistribution = 1;
BLADE.root_theta = 5;
BLADE.tip_theta = 10;
BLADE.dA = BLADE.dy * BLADE.chord;

BLADE.pos_sec = (0:BLADE.No_elements) * BLADE.dy + BLADE.RootBladeDistance;
BLADE.pos_sec = [zeros(length(BLADE.pos_sec), 1), BLADE.pos_sec', zeros(length(BLADE.pos_sec), 1)];

BLADE.theta = twist_distribution(BLADE, ROTOR);

airfoil = load('./airfoils/naca0012.mat').airfoil;

BLADE.airfoil_name = airfoil.name;
BLADE.airfoil_data = airfoil.data;


%--------------------------------------------------------------------------
TIME.t = 0;

% -------------------------------------------------------------------------
% Inicialização da variáveis gerais do simulador

SIM.AerodynamicModelSelector = 1;
SIM.atmosphereModelSelector = 2;

% ATMOSPHERE MODEL
ATMOSPHERE = atmosphereModel(0, SIM);

%--------------------------------------------------------------------------
% Início da função

BLADE.R_i_b = rotationMatrix_generator(VEHICLE.orientation(1), VEHICLE.orientation(2), VEHICLE.orientation(3));
BLADE.R_b_i = transpose(BLADE.R_i_b);

for azimute_index = 1:length(ROTOR.azimutal_positions)

    fprintf("> Azimute: %.2f\n", ROTOR.azimutal_positions(azimute_index)*180/pi)

    VEHICLE.velocity_b = ROTOR.R_r_b(:, :, azimute_index) *   BLADE.R_i_b * VEHICLE.velocity_i;

    % fprintf("Vb_x = %.2f | Vb_y = %.2f | Vb_z = %.2f \n", V_b(azimute_index, :));

   [OUTPUTS, ~, ~] = compute_blade_force_testFunc(OUTPUTS, SIM, TIME, VEHICLE, ROTOR, BLADE, ATMOSPHERE);

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

polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.element_state, "Element State", "", "10-elemente_state.jpg")


polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.Re, "Re", "", "11-re.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.Ma, "Ma", "", "12-ma.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.Cl, "Cl", "", "13-cl.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.Cd, "Cd", "", "14-cd.jpg")

polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.f_prandtl, "F. Prandtl", "", "15-f_prandtl.jpg")


close all

polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.alpha, "Angle Of Attack", "deg", "8-aoa.jpg")
polarPlot(ROTOR.azimutal_positions, BLADE.pos_sec(:, 2), OUTPUTS.phi, "Incidence Angle", "deg", "9-incidence_angle.jpg")

