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
no_re = length(size(raw_data.Re));

% Cria pastas para salvar as imagens, se não existirem
cl_folder = './CL_Folder';
cd_folder = './CD_Folder';

if ~exist(cl_folder, 'dir')
    mkdir(cl_folder);
end

if ~exist(cd_folder, 'dir')
    mkdir(cd_folder);
end

% Loop para cada número de Reynolds
for i = 1:no_re
    CL_XFLR5 = raw_data(i).CL;
    CD_XFLR5 = raw_data(i).CD;

    % Gráfico de C_L
    fig_cl = figure('Visible', 'off'); % Cria figura sem abrir a janela
    plot(raw_data(i).alfa, CL_XFLR5, 'b','LineWidth', 1.2, 'DisplayName', 'XFLR5');
    title(sprintf('Lift Coefficient (C_L) - Re = %.1e', raw_data(i).Re));
    xlabel('Angle of Attack (\alpha) [deg]');
    ylabel('C_L');
    legend('show');
    grid on;
    
    % Salva o gráfico de C_L
    saveas(fig_cl, fullfile(cl_folder, sprintf('%d_CL_Re_%.1e.png', i, raw_data(i).Re)));
    close(fig_cl); % Fecha a figura para liberar memória

    % Gráfico de C_D
    fig_cd = figure('Visible', 'off'); % Cria figura sem abrir a janela
    plot(raw_data(i).alfa, CD_XFLR5, 'b', 'LineWidth', 1.2, 'DisplayName', 'XFLR5');
    title(sprintf('Drag Coefficient (C_D) - Re = %.1e', raw_data(i).Re));
    xlabel('Angle of Attack (\alpha) [deg]');
    ylabel('C_D');
    legend('show');
    grid on;
    
    % Salva o gráfico de C_D
    saveas(fig_cd, fullfile(cd_folder, sprintf('%d_CD_Re_%.1e.png', i, raw_data(i).Re)));
    close(fig_cd); % Fecha a figura para liberar memória
end


disp(toc)
