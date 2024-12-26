clc
clear
close all

data = XFLR5_load_data("", "", true);

num_alfa = 50;

for i = 1:length(data)

    alfa = linspace(-5, 30, num_alfa);

    cl_neural = zeros(num_alfa, 1);
    cd_neural = zeros(num_alfa, 1);

    for j = 1:num_alfa
        [cl_neural(j), cd_neural(j)] = NeuralFoil("naca0012", data(i).Re, 0, alfa(j));
    end

    figure()
    sgtitle(sprintf('Re = %d', data(i).Re)) % Título único indicando o Re

    % Subplot para CL
    subplot(1, 2, 1)
    plot(alfa, cl_neural, 'b', 'LineWidth', 1.5) % NeuralFoil
    hold on
    plot(data(i).alfa, data(i).CL, 'r', 'LineWidth', 1.5) % XFLR
    xlabel('\alpha (graus)')
    ylabel('CL')
    legend('NeuralFoil', 'XFLR', 'Location', 'best')
    grid on

    % Subplot para CD
    subplot(1, 2, 2)
    plot(alfa, cd_neural, 'b', 'LineWidth', 1.5) % NeuralFoil
    hold on
    plot(data(i).alfa, data(i).CD, 'r', 'LineWidth', 1.5) % XFLR
    xlabel('\alpha (graus)')
    ylabel('CD')
    legend('NeuralFoil', 'XFLR', 'Location', 'best')
    grid on

    % Salvar figura
    saveas(gcf, sprintf('Re_%d.png', data(i).Re))

end






