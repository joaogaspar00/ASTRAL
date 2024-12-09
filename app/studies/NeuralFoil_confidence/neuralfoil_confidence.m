clc
clear
close all

% Definir os ângulos de ataque e os números de Reynolds
alpha = [-10 0 10 15 25 30];
Re = logspace(3, 9, 10); % Intervalo do logspace para valores razoáveis

% Inicializar matriz para armazenar os resultados
conf_NeuralFoil = zeros(length(alpha), length(Re)); % Prealocar para melhorar o desempenho

% Loop para calcular os valores
for i = 1:length(alpha)
    for j = 1:length(Re)
        % Chamada da função NeuralFoil
        [~, ~, conf_NeuralFoil(i, j)] = NeuralFoil("naca0012", Re(j), 0, alpha(i));
    end
end

% Criar o gráfico
figure()
hold on
for i = 1:length(alpha)
    plot(Re, conf_NeuralFoil(i, :), '-o', 'DisplayName', sprintf('\\alpha = %d°', alpha(i)), 'LineWidth', 1.2)
end
hold off

% Forçar a escala logarítmica no eixo x
set(gca, 'XScale', 'log')

% Ajustar aparência do gráfico
grid on
xlabel('Número de Reynolds (Re)')
ylabel('Conf (Saída do NeuralFoil)')
title('Conf para diferentes Ângulos de Ataque')
legend('Location', 'best') % Colocar a legenda no melhor local
