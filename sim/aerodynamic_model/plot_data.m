clc
clear
close all

Re = logspace(3, 8, 100)
alpha = -90:1:90;

load("naca0012.mat")

data_folder = "./";
output_folder = fullfile(data_folder, "img");
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

for i = 1:length(Re)
    % Inicializar vetores CL e CD
    CL = zeros(size(alpha));
    CD = zeros(size(alpha));
    
    for j = 1:length(alpha)
        [CL(j), CD(j), index] = AerodynamicModel(alpha(j), Re(i), DATA, true);
        [CL_NEURALFOIL(j), CD_NEURALFOIL(j), CF_NEURALFOIL] = NeuralFoil("naca0012", Re(i), 0, alpha(j));
    end

    % Criar figura invisível para evitar pop-ups
    fig = figure('Visible', 'off');
    fig.Position = [100, 100, 1200, 700]; % [x, y, largura, altura]
    % Subplot para Coeficiente de Sustentação (CL) vs Ângulo de Ataque
    subplot(1, 2, 1);
    plot(alpha, CL, 'LineWidth', 1.2, 'DisplayName', 'Model');
    grid on;
    hold on;
    plot(alpha, CL_NEURALFOIL, 'LineWidth', 1.2, 'DisplayName', 'NeuralFoil')
    plot(alpha, CF_NEURALFOIL, 'LineWidth', 1.2, 'DisplayName', 'Coeffidence')
    xline(DATA(index).alpha(DATA(index).stall_index), '--b', 'LineWidth', 1.2);
    xline(-DATA(index).alpha(DATA(index).stall_index), '--b', 'LineWidth', 1.2);
    xlabel('Angle of Attack (°)', 'FontSize', 12);
    ylabel('Lift Coefficient (C_L)', 'FontSize', 12);

    % Legenda global
    legend({'Model', 'NeuralFoil', 'Confidence'}, 'Position', [0.4, 0, 0.2, 0.05], 'Orientation', 'horizontal');

    

    % Subplot para Coeficiente de Arrasto (CD) vs Ângulo de Ataque
    subplot(1, 2, 2);
    plot(alpha, CD, 'LineWidth', 1.2, 'DisplayName', 'Model');
    grid on;
    hold on;
    plot(alpha, CD_NEURALFOIL, 'LineWidth', 1.2, 'DisplayName', 'NeuralFoil')
    
    xlabel('Angle of Attack (°)', 'FontSize', 12);
    ylabel('Drag Coefficient (C_D)', 'FontSize', 12);  
    
    % Título geral para a figura
    sgtitle(['Re = ', num2str(Re(i))], 'FontSize', 16);

    

    % Salvar a figura como PNG
    output_file = fullfile(output_folder, ['Re_', num2str(Re(i)), '.png']);
    saveas(fig, output_file);
    % close(fig); % Fecha a figura após salvar

end
