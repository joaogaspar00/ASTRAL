clc
clear
close all


%% AERODAS INIT
SIM.cdm_general_debbug = true
AERODAS_DATA.cmd_debug_AERODAS = true
BLADE.tc = 0.12
BLADE.AR = inf
ROTOR.AR = inf
init_AERODAS

%%

tic

no_re = length(size(raw_data.Re));

alpha = -180:2:180;

no_alpha = length(alpha);


%%

% Cria pastas para salvar as imagens, se não existirem
cl_folder = './studies/AERODAS_VS_XFLR5_NeuralFoil/CL_Folder';
cd_folder = './studies/AERODAS_VS_XFLR5_NeuralFoil/CD_Folder';

if ~exist(cl_folder, 'dir')
    mkdir(cl_folder);
end

if ~exist(cd_folder, 'dir')
    mkdir(cd_folder);
end

% Loop para cada número de Reynolds
for i = 1:no_re
    % Inicializa os coeficientes para este Reynolds
    CL_AERODAS = zeros(1, no_alpha);
    CL_NeuralFoil = zeros(1, no_alpha);
    CD_AERODAS = zeros(1, no_alpha);
    CD_NeuralFoil = zeros(1, no_alpha);

    % Coeficientes do XFLR5
    CL_XFLR5 = raw_data(i).CL;
    CD_XFLR5 = raw_data(i).CD;

    % Imprime o número de Reynolds atual
    fprintf("-------------------- Re %.1e --------------\n", raw_data(i).Re);

    % Loop para cada ângulo de ataque
    for j = 1:no_alpha
        fprintf("--> %.2f\n", alpha(j));
        
        % Calcula os coeficientes usando os modelos AERODAS e NeuralFoil
        [CL_AERODAS(j), CD_AERODAS(j)] = AERODAS_MODEL(alpha(j), raw_data(i).Re, AERODAS_DATA.AR_input, AERODAS_DATA.coefficients, [], false);
        [CL_NeuralFoil(j), CD_NeuralFoil(j)] = NeuralFoil("naca0012", raw_data(i).Re, 0, alpha(j));
    end

    % Gráfico de C_L
    fig_cl = figure('Visible', 'off'); % Cria figura sem abrir a janela
    hold on;
    plot(alpha, CL_AERODAS, 'k','LineWidth', 1.2, 'DisplayName', 'AERODAS');
    plot(alpha, CL_NeuralFoil, 'r','LineWidth', 1.2, 'DisplayName', 'NeuralFoil');
    plot(raw_data(i).alfa, CL_XFLR5, 'b','LineWidth', 1.2, 'DisplayName', 'XFLR5');
    title(sprintf('Lift Coefficient (C_L) - Re = %.1e', raw_data(i).Re));
    xlabel('Angle of Attack (\alpha) [deg]');
    ylabel('C_L');
    ylim([-2.5 2.5])
    legend('show');
    grid on;
    hold off;
    
    
    % Salva o gráfico de C_L
    saveas(fig_cl, fullfile(cl_folder, sprintf('%d_CL_Re_%.1e.png', i, raw_data(i).Re)));
    close(fig_cl); % Fecha a figura para liberar memória

    % Gráfico de C_D
    fig_cd = figure('Visible', 'off'); % Cria figura sem abrir a janela
    hold on;
    plot(alpha, CD_AERODAS, 'k', 'LineWidth', 1.2, 'DisplayName', 'AERODAS');
    plot(alpha, CD_NeuralFoil, 'r', 'LineWidth', 1.2,'DisplayName', 'NeuralFoil');
    plot(raw_data(i).alfa, CD_XFLR5, 'b', 'LineWidth', 1.2, 'DisplayName', 'XFLR5');
    title(sprintf('Drag Coefficient (C_D) - Re = %.1e', raw_data(i).Re));
    xlabel('Angle of Attack (\alpha) [deg]');
    ylabel('C_D');
    legend('show');
    grid on;
    hold off;
    
    % Salva o gráfico de C_D
    saveas(fig_cd, fullfile(cd_folder, sprintf('%d_CD_Re_%.1e.png', i, raw_data(i).Re)));
    close(fig_cd); % Fecha a figura para liberar memória
end


disp(toc)
