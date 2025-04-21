airfoil = load('./airfoils/data/n0012.mat').airfoil;
data = airfoil.data;

alpha = -180:2:180;
Re_values = logspace(4, 7, 6);

cl_matrix = zeros(length(alpha), length(Re_values));
cd_matrix = zeros(length(alpha), length(Re_values));

for i = 1:length(Re_values)
    for j = 1:length(alpha)
        [cl_matrix(j, i), cd_matrix(j, i), ~] = NeuralFoil('NACA0012', Re_values(i), 0, alpha(j));
    end
end

figure;
hold on;
for i = 1:length(Re_values)
    plot(alpha, cl_matrix(:, i), 'LineWidth', 1.5, 'DisplayName', ['Re = ', num2str(Re_values(i), '%.2e')]);
end
hold off;
title('Lift Coefficient (C_L) vs Angle of Attack');
xlabel('Angle of Attack (°)');
ylabel('C_L');
legend('show', 'Location', 'northeastoutside');
grid on;
set(gca, 'FontSize', 12);
saveas(gcf, 'cl_vs_alpha.png');

figure;
hold on;
for i = 1:length(Re_values)
    plot(alpha, cd_matrix(:, i), 'LineWidth', 1.5, 'DisplayName', ['Re = ', num2str(Re_values(i), '%.2e')]);
end
hold off;
title('Drag Coefficient (C_D) vs Angle of Attack');
xlabel('Angle of Attack (°)');
ylabel('C_D');
legend('show', 'Location', 'northeastoutside');
grid on;
set(gca, 'FontSize', 12);
saveas(gcf, 'cd_vs_alpha.png');
