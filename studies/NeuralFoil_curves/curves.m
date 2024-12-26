clc
clear
close all

num_alfa = 50;
alfa = linspace(-5, 30, num_alfa);

Re = logspace(3, 8, 30);

for i = 1:length(Re)


    cl_neural = zeros(num_alfa, 1);
    cd_neural = zeros(num_alfa, 1);
    conf = zeros(num_alfa, 1);

    for j = 1:num_alfa
        [cl_neural(j), cd_neural(j), conf(j)] = NeuralFoil("naca0012", Re(i), 0, alfa(j));
    end

    figure()
    sgtitle(sprintf('Re = %d', Re(i))) % Título único indicando o Re

    % Subplot para CL
    subplot(1, 2, 1)
    plot(alfa, cl_neural, 'b', 'LineWidth', 1.5)
    hold on
    plot(alfa, conf, 'r--', 'LineWidth', 1.5) 
    xlabel('\alpha (graus)')
    ylabel('CL')
    grid on

    % Subplot para CD
    subplot(1, 2, 2)
    plot(alfa, cd_neural, 'b', 'LineWidth', 1.5)
    xlabel('\alpha (graus)')
    ylabel('CD')
    grid on

    % Salvar figura
    saveas(gcf, sprintf('%d - Neural_Foil_Re_%d.png', i, Re(i)))

end






