function plotTrajectory3D(position)
    % Verifica se a entrada é uma matriz de três colunas
    if size(position, 2) ~= 3
        error('A matriz de entrada deve ter três colunas representando as posições (x, y, z).');
    end

    % Extrai as coordenadas x, y e z
    x = position(:, 1);
    y = position(:, 2);
    z = position(:, 3);

    % Cria o gráfico 3D
    figure;
    plot3(x, y, z, 'Color', 'k', 'LineWidth', 1.2);  % Linha preta com largura de 1.2
    title('Gráfico de Trajetória 3D - Queda Vertical');
    xlabel('Posição X');
    ylabel('Posição Y');
    zlabel('Posição Z');
    grid on;
    axis equal;

    % Ajuste os limites dos eixos
    % Como X e Y são essencialmente zero (queda vertical), damos um pequeno intervalo
    xlim([-100 100]);  % Definimos X de -1 a 1 para que o gráfico seja visível
    ylim([-100 100]);  % Definimos Y de -1 a 1 também
    zlim([min(z), max(z)]);  % O eixo Z varia conforme os dados de posição vertical
    
    view(3);  % Ajusta a visualização para uma perspectiva 3D padrão
end
