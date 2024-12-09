function plot_blade_3D(airfoil, Ne, R, e, c, twistMode, root_theta, tip_theta)
    % Função para plotar perfis ao longo de uma pá de rotor em 3D
    % Parâmetros:
    % airfoil - Identificação do perfil aerodinâmico (não usado no código atual)
    % Ne - Número de elementos discretos na pá
    % R - Raio da pá
    % e - Posição da raiz da pá
    % c - Comprimento da corda (escala)

    close all;

    % Verifica se o arquivo de coordenadas existe
    coord_file = "airfoil_data\naca0012\files\coordinates.csv";
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

    % Calcula os angulos theta
    slope = (tip_theta - root_theta) / R;

    theta = ones(1, Ne);
    
    if twistMode == 1
    
        theta = theta * root_theta;
    
    elseif twistMode == 2
    
        for i=1:length(pos_el)
            theta(i) = slope * (pos_el(i)-e) + root_theta;      
        end
    end

    % Inicializa a figura
    figure;
    hold on;
    for i = 1:length(pos_el)
        % Calcula a matriz de rotação para o ângulo theta(i)
        Rot = [cosd(theta(i)) -sind(theta(i)); sind(theta(i)) cosd(theta(i))];
    
        % Ajusta as coordenadas para a posição ao longo do raio
        x = coord(:, 1);  % Mantém o perfil em x
        y = coord(:, 2);  % Mantém o perfil em y
        z = pos_el(i) * ones(size(x));  % Define a posição no eixo z
    
        % Aplica a rotação em cada par de pontos (x, y)
        rotated_coords = Rot * [x'; y'];  % Multiplica a matriz de rotação pelos pontos
    
        % Desempacota as coordenadas rotacionadas
        x_rot = rotated_coords(1, :);  % Novas coordenadas x
        y_rot = rotated_coords(2, :);  % Novas coordenadas y
    
        % Plota o perfil deslocado no espaço 3D com as novas coordenadas
        plot3(x_rot, z, y_rot, 'b', 'LineWidth', 1.2); % Usa 'b' para linhas azuis
    end

    % Configuração do gráfico
    axis equal;
    grid on;
    % xlim([0 c])
    % ylim([0 R+e])
    
    title('Blade');
    view(3); % Garante a visualização em 3D
    hold off;
end
