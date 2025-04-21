clc
clear
close all

H = linspace(0, 100000, 250);

% Inicialização dos vetores para temperatura e outras variáveis
T_eam = zeros(1, length(H));
T_isa = zeros(1, length(H));
T_nrl = zeros(1, length(H));

a_eam = zeros(1, length(H));
a_isa = zeros(1, length(H));
a_nrl = zeros(1, length(H));

p_eam = zeros(1, length(H));
P_isa = zeros(1, length(H));
P_nrl = zeros(1, length(H));

rho_eam = zeros(1, length(H));
rho_isa = zeros(1, length(H));
rho_nrl = zeros(1, length(H));

nu_eam = zeros(1, length(H));
nu_isa = zeros(1, length(H));
nu_nrl = zeros(1, length(H));

mu_eam = zeros(1, length(H));
mu_isa = zeros(1, length(H));
mu_nrl = zeros(1, length(H));

for i = 1:length(H)

    fprintf("height = %.2f\n", H(i))

    % NASA EAM
    if H(i) <= 50*1e3
        [T_eam(i), a_eam(i), p_eam(i), rho_eam(i), nu_eam(i), mu_eam(i)] = EAM_atmospheric_model(H(i));
        limit_eam_i = i;
    end

    % ISA Model
    if H(i) <= 84852
        [T_isa(i), a_isa(i), P_isa(i), rho_isa(i), nu_isa(i), mu_isa(i)] = ISA_atmospheric_model(H(i));
        limit_isa_i = i;
    end

    
    % NRLMSISE00
    if H(i) < 1e6
        [T_nrl(i), a_nrl(i), P_nrl(i), rho_nrl(i), nu_nrl(i), mu_nrl(i)] = NRLMSISE00_atmos_model(H(i));
        limit_nrl_i = i;
    end

end

%% Gráficos para todas as variáveis com Altitude no eixo Y


% Temperature Plot
figure()
plot(T_eam(1:limit_eam_i), H(1:limit_eam_i), 'r', 'LineWidth', 1.5)
hold on
plot(T_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
plot(T_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
hold off
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('Temperature (K)', 'FontSize', 10)
title('Temperature', 'FontSize', 10)
legend({'EAM - NASA', 'ISA', 'NRLMSISE-00'}, 'Location', 'best', 'FontSize', 10)
saveas(gcf, './studies/atmos_model_comp/img/temperature_plot.png')

% Density Plot
figure()
semilogx(rho_eam(1:limit_eam_i), H(1:limit_eam_i), 'r', 'LineWidth', 1.5)
hold on
semilogx(rho_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
semilogx(rho_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
hold off
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('Density (kg/m³)', 'FontSize', 10)
title('Density', 'FontSize', 10)
legend({'EAM - NASA', 'ISA', 'NRLMSISE-00'}, 'Location', 'best', 'FontSize', 10)
saveas(gcf, './studies/atmos_model_comp/img/density_plot.png')

% Sound Speed Plot
figure()
plot(a_eam(1:limit_eam_i), H(1:limit_eam_i), 'r', 'LineWidth', 1.5)
hold on
plot(a_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
plot(a_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
hold off
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('Speed of Sound (m/s)', 'FontSize', 10)
title('Speed of Sound', 'FontSize', 10)
legend({'EAM - NASA', 'ISA', 'NRLMSISE-00'}, 'Location', 'best', 'FontSize', 10)
saveas(gcf, './studies/atmos_model_comp/img/sound_speed_plot.png')

% Pressure Plot
figure()
plot(p_eam(1:limit_eam_i), H(1:limit_eam_i), 'r', 'LineWidth', 1.5)
hold on
plot(P_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
plot(P_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
hold off
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('Pressure (Pa)', 'FontSize', 10)
title('Pressure', 'FontSize', 10)
legend({'EAM - NASA', 'ISA', 'NRLMSISE-00'}, 'Location', 'best', 'FontSize', 10)
saveas(gcf, './studies/atmos_model_comp/img/pressure_plot.png')


% Kinematic Viscosity Plot
figure()
plot(nu_eam(1:limit_eam_i), H(1:limit_eam_i), 'r', 'LineWidth', 1.5)
hold on
plot(nu_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
plot(nu_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
hold off
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('Kinematic Viscosity (m²/s)', 'FontSize', 10)
title('Kinematic Viscosity', 'FontSize', 10)
legend({'EAM - NASA', 'ISA', 'NRLMSISE-00'}, 'Location', 'best', 'FontSize', 10)
saveas(gcf, './studies/atmos_model_comp/img/kinematic_viscosity_plot.png')

% Dynamic Viscosity Plot
figure()
plot(mu_eam(1:limit_eam_i), H(1:limit_eam_i), 'r', 'LineWidth', 1.5)
hold on
plot(mu_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
plot(mu_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
hold off
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('Dynamic Viscosity (Pa·s)', 'FontSize', 10)
title('Dynamic Viscosity', 'FontSize', 10)
legend({'EAM - NASA', 'ISA', 'NRLMSISE-00'}, 'Location', 'best', 'FontSize', 10)
saveas(gcf, './studies/atmos_model_comp/img/dynamic_viscosity_plot.png')

%% Plots individuais para cada modelo
% NASA EAM
figure()
sgtitle('NASA EAM', 'FontSize', 16) % Título geral para o modelo

subplot(2, 3, 1)
plot(T_eam(1:limit_eam_i), H(1:limit_eam_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(K)', 'FontSize', 10)
title('Temperature', 'FontSize', 10)

subplot(2, 3, 2)
plot(rho_eam(1:limit_eam_i), H(1:limit_eam_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(kg/m³)', 'FontSize', 10)
title('Density', 'FontSize', 10)

subplot(2, 3, 3)
plot(a_eam(1:limit_eam_i), H(1:limit_eam_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(m/s)', 'FontSize', 10)
title('Speed of Sound', 'FontSize', 10)

subplot(2, 3, 4)
plot(p_eam(1:limit_eam_i), H(1:limit_eam_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(Pa)', 'FontSize', 10)
title('Pressure', 'FontSize', 10)

subplot(2, 3, 5)
plot(nu_eam(1:limit_eam_i), H(1:limit_eam_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(m²/s)', 'FontSize', 10)
title('Kinematic Viscosity', 'FontSize', 10)

subplot(2, 3, 6)
plot(mu_eam(1:limit_eam_i), H(1:limit_eam_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(Pa·s)', 'FontSize', 10)
title('Dynamic Viscosity', 'FontSize', 10)

saveas(gcf, './studies/atmos_model_comp/img/eam_individual_plot.png')

% ISA
figure()
sgtitle('ISA', 'FontSize', 16) % Título geral para o modelo

subplot(2, 3, 1)
plot(T_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(K)', 'FontSize', 10)
title('Temperature', 'FontSize', 10)

subplot(2, 3, 2)
plot(rho_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(kg/m³)', 'FontSize', 10)
title('Density', 'FontSize', 10)

subplot(2, 3, 3)
plot(a_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(m/s)', 'FontSize', 10)
title('Speed of Sound', 'FontSize', 10)

subplot(2, 3, 4)
plot(P_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(Pa)', 'FontSize', 10)
title('Pressure', 'FontSize', 10)

subplot(2, 3, 5)
plot(nu_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(m²/s)', 'FontSize', 10)
title('Kinematic Viscosity', 'FontSize', 10)

subplot(2, 3, 6)
plot(mu_isa(1:limit_isa_i), H(1:limit_isa_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(Pa·s)', 'FontSize', 10)
title('Dynamic Viscosity', 'FontSize', 10)

saveas(gcf, './studies/atmos_model_comp/img/isa_individual_plot.png')

% NRLMSISE-00
figure()
sgtitle('NRLMSISE-00', 'FontSize', 16) % Título geral para o modelo

subplot(2, 3, 1)
plot(T_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(K)', 'FontSize', 10)
title('Temperature', 'FontSize', 10)

subplot(2, 3, 2)
plot(rho_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(kg/m³)', 'FontSize', 10)
title('Density', 'FontSize', 10)

subplot(2, 3, 3)
plot(a_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(m/s)', 'FontSize', 10)
title('Speed of Sound', 'FontSize', 10)

subplot(2, 3, 4)
plot(P_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(Pa)', 'FontSize', 10)
title('Pressure', 'FontSize', 10)

subplot(2, 3, 5)
plot(nu_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(m²/s)', 'FontSize', 10)
title('Kinematic Viscosity', 'FontSize', 10)

subplot(2, 3, 6)
plot(mu_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'k', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 10)
xlabel('(Pa·s)', 'FontSize', 10)
title('Dynamic Viscosity', 'FontSize', 10)

saveas(gcf, './studies/atmos_model_comp/img/nrlmsise_individual_plot.png')

%% Gráficos individuais para o modelo NRLMSISE-00

% Temperature
figure()
plot(T_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 12)
xlabel('(K)', 'FontSize', 12)
title('NRLMSISE-00: Temperature', 'FontSize', 14)
saveas(gcf, './studies/atmos_model_comp/img/nrl_temperature.png')

% Density
figure()
plot(rho_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 12)
xlabel('(kg/m³)', 'FontSize', 12)
title('NRLMSISE-00: Density', 'FontSize', 14)
saveas(gcf, './studies/atmos_model_comp/img/nrl_density.png')

% Speed of Sound
figure()
plot(a_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 12)
xlabel('(m/s)', 'FontSize', 12)
title('NRLMSISE-00: Speed of Sound', 'FontSize', 14)
saveas(gcf, './studies/atmos_model_comp/img/nrl_speed_of_sound.png')

% Pressure
figure()
plot(P_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 12)
xlabel('(Pa)', 'FontSize', 12)
title('NRLMSISE-00: Pressure', 'FontSize', 14)
saveas(gcf, './studies/atmos_model_comp/img/nrl_pressure.png')

% Kinematic Viscosity
figure()
plot(nu_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 12)
xlabel('(m²/s)', 'FontSize', 12)
title('NRLMSISE-00: Kinematic Viscosity', 'FontSize', 14)
saveas(gcf, './studies/atmos_model_comp/img/nrl_kinematic_viscosity.png')

% Dynamic Viscosity
figure()
plot(mu_nrl(1:limit_nrl_i), H(1:limit_nrl_i), 'b', 'LineWidth', 1.5)
grid on
ylabel('Altitude (m)', 'FontSize', 12)
xlabel('(Pa·s)', 'FontSize', 12)
title('NRLMSISE-00: Dynamic Viscosity', 'FontSize', 14)
saveas(gcf, './studies/atmos_model_comp/img/nrl_dynamic_viscosity.png')

