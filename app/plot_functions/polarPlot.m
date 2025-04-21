function polarPlot(azimutes, rho, values, stitle, slabel, img_name)

% Converter ângulos para radianos se necessário
if max(azimutes) > 2*pi
    azimutes = deg2rad(azimutes);
end

% Número de azimutes
num_azimutes = length(azimutes);
num_rho = length(rho);

% Criar matrizes para coordenadas polares
[Theta, R] = meshgrid(azimutes, rho);

% Garantir que os valores estejam na ordem correta
U_matrix = values'; % Transpor para alinhar com [rho, azimutes]

% Converter coordenadas polares para cartesianas para scatter3
X = R .* cos(Theta);
Y = R .* sin(Theta);

% Criar figura
figure;
scatter3(X(:), Y(:), U_matrix(:), 8, U_matrix(:), 'filled'); 
colorbar;
colormap("turbo");
ylabel(colorbar, slabel, 'FontSize', 16);

% Ajustar o gráfico para um visualização polar 2D
view(2);
axis equal;

% Ajustar os limites para maximizar o zoom mantendo todos os dados visíveis
xlim([min(X(:)), max(X(:))]);
ylim([min(Y(:)), max(Y(:))]);

% Título
title(stitle);

% Remover labels de eixos para manter estilo polar
set(gca, 'XTick', [], 'YTick', [], 'XColor', 'none', 'YColor', 'none');

% Salvar a imagem, se necessário
% if ~isempty(img_name)
%     saveas(gcf, img_name, 'epsc'); % Salva como .eps em cores
% end

end
