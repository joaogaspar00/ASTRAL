function plot_blade_3D(airfoil, Ne, R, e, c, twist_rate, root_theta)
    % Função para plotar perfis ao longo de uma pá de rotor em 3D com gradiente apenas em tons de azul
    % Parâmetros:
    % airfoil - Identificação do perfil aerodinâmico (não usado no código atual)
    % Ne - Número de elementos discretos na pá
    % R - Raio da pá
    % e - Posição da raiz da pá
    % c - Comprimento da corda (escala)

    close all;

    % Verifica se o arquivo de coordenadas existe
    coord_file = "airfoils\coord\" + airfoil + ".dat";
    if ~isfile(coord_file)
        error("Arquivo de coordenadas não encontrado: %s", coord_file);
    end

    % Lê as coordenadas do arquivo
    coord = readmatrix(coord_file);

    % Verifica se o arquivo está no formato esperado
    if size(coord, 2) ~= 2
        error("O arquivo de coordenadas deve ter duas colunas (x e y).");
    end

    % Escala as coordenadas pela corda
    coord = c * coord(2:end, :);

    % Gera as posições dos elementos ao longo do raio
    pos_el = linspace(e, e + R, Ne);

    theta = zeros(1, length(pos_el));

    % Calcula os ângulos theta
    for i = 1:length(pos_el)
        theta(i) = twist_rate * (pos_el(i) - e) + root_theta;
    end

    % Inicializa a figura
    figure;
    hold on;

    % Cria o gradiente em azul manualmente (do azul escuro ao claro)
    cmap = [linspace(0.2, 1, Ne)', zeros(Ne, 1), zeros(Ne, 1)]; % Apenas tons de azul

    for i = 1:length(pos_el)
        % Calcula a matriz de rotação para o ângulo theta(i)
        Rot = rotationMatrix_generator(-theta(i), 0, 0, "DEG");

        % Ajusta as coordenadas para a posição ao longo do raio
        x = coord(:, 1); % Mantém o perfil em x
        y = coord(:, 2); % Mantém o perfil em y
        z = pos_el(i) * ones(size(x)); % Define a posição no eixo z

        % Aplica a rotação em cada par de pontos (x, y)
        rotated_coords = Rot(1:2, 1:2) * [x'; y']; % Multiplica a matriz de rotação pelos pontos

        % Desempacota as coordenadas rotacionadas
        x_rot = rotated_coords(1, :); % Novas coordenadas x
        y_rot = rotated_coords(2, :); % Novas coordenadas y

        % Plota o perfil deslocado no espaço 3D com uma cor específica
        plot3(x_rot, z, y_rot, 'Color', cmap(i, :), 'LineWidth', 1.2); % Atribui cor do gradiente
    end

    % Configuração do gráfico
    axis equal;
    grid on;
    view(3); % Garante a visualização em 3D
    hold off;
end
