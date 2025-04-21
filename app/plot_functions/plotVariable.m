function plotVariable(x, y, xlabel_text, ylabel_text, title_text)
    % PLOTVARIABLE Plota os dados fornecidos e ajusta os rótulos
    % x: vetor de dados do eixo x
    % y: vetor ou matriz de dados do eixo y (cada coluna é um conjunto de dados)
    % xlabel_text: rótulo do eixo X
    % ylabel_text: rótulo do eixo Y
    % title_text: título do gráfico

    figure; % Cria uma nova figura
    hold on; % Mantém a figura ativa para múltiplos plots
    
    % Verifica se y tem três colunas e plota cada uma separadamente
    if size(y, 2) == 3
        plot(x, y(:,1), 'k', 'LineWidth', 1.5, 'DisplayName', 'X');
        plot(x, y(:,2), 'r', 'LineWidth', 1.5, 'DisplayName', 'Y');
        plot(x, y(:,3), 'b', 'LineWidth', 1.5, 'DisplayName', 'Z');
        legend("Location", "best"); % Adiciona a legenda
    else
        plot(x, y, 'k', 'LineWidth', 1.5);
    end
    
    xlabel(xlabel_text);
    ylabel(ylabel_text);
    title(title_text);
    grid on;
end
