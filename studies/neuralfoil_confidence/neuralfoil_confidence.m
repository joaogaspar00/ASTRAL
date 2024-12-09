clc
clear
close all

tic

% Definir os ângulos de ataque e os números de Reynolds
alpha = -180:0.5:180; % Intervalo de ângulos de ataque
Re = logspace(3, 9, 500); % Intervalo de Reynolds (escala logarítmica)

% Inicializar matriz para armazenar os resultados
conf_NeuralFoil = zeros(length(alpha), length(Re)); % Prealocar para melhorar o desempenho

% Loop para calcular os valores
for i = 1:length(alpha)
    for j = 1:length(Re)
        fprintf("-> Re = %.2e | AoA = %.2f\n", Re(j), alpha(i))
        % Chamada da função NeuralFoil
        [~, ~, conf_NeuralFoil(i, j)] = NeuralFoil("naca0012", Re(j), 0, alpha(i));
    end
end

%% Gráficos 3D e 2D
close all

% Criar o gráfico 3D
figure()
[X, Y] = meshgrid(Re, alpha); % Criar malha para o gráfico
surf(X, Y, conf_NeuralFoil, 'EdgeColor', 'none') % Gráfico de superfície
c = colorbar; % Barra de cores
shading interp % Suavizar os contornos
colormap jet; % Escolher esquema de cores
ylabel(c, "Confidence Level") % Adicionar legenda

% Adicionar plano em z = 0.9
hold on
Z_plane = 0.9 * ones(size(X)); % Matriz para o plano em z = 0.9
surf(X, Y, Z_plane, 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'FaceColor', 'black') % Plano transparente
hold off

% Ajustar aparência do gráfico
set(gca, 'XScale', 'log') % Escala logarítmica no eixo X
xlabel('Re')
ylabel('\alpha (degrees)')
zlabel('H')
title('Neural Foil Confidence')
grid on

saveas(gcf, './studies/neuralfoil_confidence/NeuralFoil_Confidence_Plot_3D.png') % Salvar como arquivo PNG

% Criar o gráfico 2D
figure()
[X, Y] = meshgrid(alpha, Re); % Criar malha para o gráfico (alpha no X, Re no Y)
pcolor(X', Y', conf_NeuralFoil) % Gráfico colorido 2D (transpor para alinhar corretamente)
shading interp % Suavizar os contornos
c = colorbar; % Barra de cores
colormap jet; % Escolher esquema de cores
ylabel(c, "Confidence Level") % Adicionar legenda

% Ajustar aparência do gráfico
set(gca, 'YScale', 'log') % Escala logarítmica no eixo Y
xlabel('\alpha (degrees)')
ylabel('Re')
title('Neural Foil Confidence')
grid on

% Salvar como arquivo PNG
saveas(gcf, './studies/neuralfoil_confidence/NeuralFoil_Confidence_2D.png')

% GRÁFICOS A PRETO E BRANCO

% Criar o gráfico 3D
figure()
[X, Y] = meshgrid(Re, alpha); % Criar malha para o gráfico
surf(X, Y, conf_NeuralFoil, 'EdgeColor', 'none') % Gráfico de superfície
c = colorbar; % Barra de cores
shading interp % Suavizar os contornos
colormap(flipud(gray)); % Escolher esquema de cores em preto e branco
ylabel(c, "Confidence Level") % Adicionar legenda

% Adicionar plano em z = 0.9
hold on
Z_plane = 0.9 * ones(size(X)); % Matriz para o plano em z = 0.9
surf(X, Y, Z_plane, 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'FaceColor', 'red') % Plano transparente
hold off

% Ajustar aparência do gráfico
set(gca, 'XScale', 'log') % Escala logarítmica no eixo X
xlabel('Re')
ylabel('\alpha (degrees)')
zlabel('H')
title('Neural Foil Confidence')
grid on

saveas(gcf, './studies/neuralfoil_confidence/NeuralFoil_Confidence_Plot_3D_black.png') % Salvar como arquivo PNG

% Criar o gráfico 2D
figure()
[X, Y] = meshgrid(alpha, Re); % Criar malha para o gráfico (alpha no X, Re no Y)
pcolor(X', Y', conf_NeuralFoil) % Gráfico colorido 2D (transpor para alinhar corretamente)
shading interp % Suavizar os contornos
c = colorbar; % Barra de cores
colormap(flipud(gray)); % Escolher esquema de cores em preto e branco
ylabel(c, "Confidence Level") % Adicionar legenda

% Ajustar aparência do gráfico
set(gca, 'YScale', 'log') % Escala logarítmica no eixo Y
xlabel('\alpha (degrees)')
ylabel('Re')
title('Neural Foil Confidence')
grid on

% Salvar como arquivo PNG
saveas(gcf, './studies/neuralfoil_confidence/NeuralFoil_Confidence_2D_black.png')


%%
elapsedTime = toc; % Tempo decorrido em segundos

% Converter para horas, minutos e segundos
hours = floor(elapsedTime / 3600);
minutes = floor(mod(elapsedTime, 3600) / 60);
seconds = mod(elapsedTime, 60);

% Exibir no formato HH:MM:SS, arredondando os segundos
fprintf("\n\n-> Time elapsed = %02d:%02d:%02d\n", hours, minutes, round(seconds));



