clc
clear
close all

%% AERODAS INIT
% SIM.cdm_general_debbug = false;
% AERODAS_DATA.cmd_debug_AERODAS = false;
% BLADE.tc = 0.12;
% BLADE.AR = inf;
% ROTOR.AR = inf;
% init_AERODAS

%% 10^3 Reynolds Numbers

data_KHALID = readmatrix("naca0012_khalid.csv");
data_KURTULUS = readmatrix("naca0012_kurtulus.csv");

alpha = 0:1:30;

for i=1:length(alpha)
    [CL_NeuralFoil(i), CD_NeuralFoil(i), conf_NeuralFoil(i)] = NeuralFoil("naca0012", 1e3, 0, alpha(i));
end    

aa  = 5;

% Melhorar o gráfico
figure(); % Dimensão da figura
hold on;

% Plotar dados experimentais de Khalid e Kurtulus
plot(data_KHALID(:, 1), data_KHALID(:, 2), 'o-', 'MarkerSize', aa, 'LineWidth', 1.2, 'Color', 'r', 'DisplayName', 'Khalid et al.');
plot(data_KURTULUS(:, 1), data_KURTULUS(:, 2), 'x-', 'MarkerSize', aa, 'LineWidth', 1.2, 'Color', 'k', 'DisplayName', 'Kurtulus');

% Adicionar curva para NeuralFoil
plot(alpha, CL_NeuralFoil, 's-', 'MarkerSize', aa, 'LineWidth', 1.2, 'Color', 'b', 'DisplayName', 'NeuralFoil');
plot(alpha, conf_NeuralFoil, '--', 'Color', 'magenta', 'DisplayName', 'NeuralFoil Confidence', 'LineWidth', 1.2); % Verde


% Ajustar os eixos
xlim([min(alpha), max(alpha)]); % Limites do eixo x
ylim([min([CL_NeuralFoil, data_KHALID(:, 2)', data_KURTULUS(:, 2)'])-0.1, ...
      max([CL_NeuralFoil, data_KHALID(:, 2)', data_KURTULUS(:, 2)'])+0.1]); % Limites do eixo y

% Adicionar grade
grid on;

% Melhorar legendas e rótulos
legend('Location', 'best');
xlabel('\alpha (degrees)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('C_L', 'FontSize', 12, 'FontWeight', 'bold');
title('NACA0012 at Re = 1x10^3 - CL', 'FontSize', 14, 'FontWeight', 'bold');

% Ajustar aparência
set(gca, 'FontSize', 11, 'LineWidth', 1.2); % Configurar fonte e espessura do eixo
hold off;

%% 10^4 Reynolds Numbers
clear

data_MOLAA_2e5= readmatrix("Molaa_DATA_8e4.xlsx");

alpha = data_MOLAA_2e5(2:end, 1);
MOOLA_CD_exp = data_MOLAA_2e5(2:end, 2);
MOOLA_CL_exp = data_MOLAA_2e5(2:end, 3);
MOOLA_CD_cfd = data_MOLAA_2e5(2:end, 4);
MOOLA_CL_cfd = data_MOLAA_2e5(2:end, 5);

for i=1:length(alpha)
    [CL_NeuralFoil(i), CD_NeuralFoil(i), conf_NeuralFoil(i)] = NeuralFoil("naca0012", 8e4, 0, alpha(i));   
end    

% Gráfico para C_L
figure()
plot(alpha, MOOLA_CL_exp, 'o-', 'Color', 'r', 'DisplayName', 'Moola Experimental', 'LineWidth', 1.2); % Vermelho
hold on;
plot(alpha, MOOLA_CL_cfd, 'x-', 'Color', 'k', 'DisplayName', 'Moola CFD', 'LineWidth', 1.2); % Preto
plot(alpha, CL_NeuralFoil, 's-', 'Color', 'b', 'DisplayName', 'NeuralFoil', 'LineWidth', 1.2); % Azul
plot(alpha, conf_NeuralFoil, '--', 'Color', 'magenta', 'DisplayName', 'NeuralFoil Confidence', 'LineWidth', 1.2); % Verde
hold off;
xlabel('\alpha (deg)', 'FontSize', 12);
ylabel('C_L', 'FontSize', 12);
title('NACA0012 at Re = 8x10^4 - Cl', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

% Gráfico para C_D
figure()
plot(alpha, MOOLA_CD_exp, 'o-', 'Color', 'r', 'DisplayName', 'Moola Experimental', 'LineWidth', 1.2); % Vermelho
hold on;
plot(alpha, MOOLA_CD_cfd, 'x-', 'Color', 'k', 'DisplayName', 'Moola CFD', 'LineWidth', 1.2); % Preto
plot(alpha, CD_NeuralFoil, 's-', 'Color', 'b', 'DisplayName', 'NeuralFoil', 'LineWidth', 1.5); % Azul
hold off;
xlabel('\alpha (deg)', 'FontSize', 12);
ylabel('C_D', 'FontSize', 12);
title('NACA0012 at Re = 8x10^4 - CD', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northwest');
grid on;

%% 10^4 Reynolds Numbers
clear

data_MOLAA_2e5= readmatrix("Molaa_DATA_2e5.xlsx");

alpha = data_MOLAA_2e5(2:end, 1);
MOOLA_CD_exp = data_MOLAA_2e5(2:end, 2);
MOOLA_CL_exp = data_MOLAA_2e5(2:end, 3);
MOOLA_CD_cfd = data_MOLAA_2e5(2:end, 4);
MOOLA_CL_cfd = data_MOLAA_2e5(2:end, 5);

for i=1:length(alpha)
    [CL_NeuralFoil(i), CD_NeuralFoil(i), conf_NeuralFoil(i)] = NeuralFoil("naca0012", 2e5, 0, alpha(i));   
end    

% Gráfico para C_L
figure()
plot(alpha, MOOLA_CL_exp, 'o-', 'Color', 'r', 'DisplayName', 'Moola Experimental', 'LineWidth', 1.2); % Vermelho
hold on;
plot(alpha, MOOLA_CL_cfd, 'x-', 'Color', 'k', 'DisplayName', 'Moola CFD', 'LineWidth', 1.2); % Preto
plot(alpha, CL_NeuralFoil, 's-', 'Color', 'b', 'DisplayName', 'NeuralFoil', 'LineWidth', 1.2); % Azul
% Adiciona confiança como linha
plot(alpha, conf_NeuralFoil, '--', 'Color', 'magenta', 'DisplayName', 'NeuralFoil Confidence', 'LineWidth', 1.2); % Verde
hold off;
xlabel('\alpha (deg)', 'FontSize', 12);
ylabel('C_L', 'FontSize', 12);
title('NACA0012 at Re = 8x10^4 - Cl', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

% Gráfico para C_D
figure()
plot(alpha, MOOLA_CD_exp, 'o-', 'Color', 'r', 'DisplayName', 'Moola Experimental', 'LineWidth', 1.2); % Vermelho
hold on;
plot(alpha, MOOLA_CD_cfd, 'x-', 'Color', 'k', 'DisplayName', 'Moola CFD', 'LineWidth', 1.2); % Preto
plot(alpha, CD_NeuralFoil, 's-', 'Color', 'b', 'DisplayName', 'NeuralFoil', 'LineWidth', 1.5); % Azul
% Adiciona confiança como linha
hold off;
xlabel('\alpha (deg)', 'FontSize', 12);
ylabel('C_D', 'FontSize', 12);
title('NACA0012 at Re = 8x10^4 - CD', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northwest');
grid on;

