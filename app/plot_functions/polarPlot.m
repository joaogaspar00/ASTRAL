function polarPlot(azimutes, rho, values, stitle, slabel, img_name)

% Supondo que azimutes, rho, OUTPUT.U_T já estão definidos.

% Número de azimutes (exemplo: 36 posições em um círculo)
num_azimutes = length(azimutes);

% Replicar a mesma distribuição radial para cada azimute
r_matrix = repmat(rho, 1, num_azimutes);

% Criar a matriz de ângulos para o polarscatter
theta_matrix = repmat(azimutes', length(rho), 1);

% Converter as matrizes para vetores para usar no scatter3
r_vector = r_matrix(:);
theta_vector = theta_matrix(:);

% Velocidade associada às coordenadas polares
U_matrix = values'; % Supondo que OUTPUT.U_T tenha valores de velocidade.

% Plotar o gráfico de dispersão polar com a terceira dimensão representando a velocidade
figure;

% Adicionar pontos 2D no gráfico polar para visualização inicial
polarplot(theta_vector, r_vector, 'o', 'MarkerEdgeColor','none'); 
hold on;

% Plotar em 3D: adicionando a velocidade como terceiro eixo (coluna)
scatter3(theta_vector, r_vector, U_matrix(:), 50, U_matrix(:), 'filled'); 
% Add a colorbar with the 'viridis' colormap
colorbar;
colormap("turbo");
colorbar_handle = colorbar;

% Legenda da barra de cor
ylabel(colorbar_handle, slabel, 'FontSize', 12);

% Ajustar orientação: definir 0 graus para o norte
set(gca, 'ThetaZeroLocation', 'top'); 

% Definir os rótulos para eixos polares
rticks([]);  % Remove os rótulos das coordenadas radiais
rticklabels({}); % Remover rótulos dos valores radiais

thetaticks(0:90:360); % Definir os rótulos para os ângulos azimutais

% Visão 2D polar
view(2); 

title(stitle);

% Salvar a figura no formato especificado
saveas(gcf, img_name);

end


