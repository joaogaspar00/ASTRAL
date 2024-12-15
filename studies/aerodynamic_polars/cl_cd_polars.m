airfoil = load('./airfoils/naca0012.mat').airfoil;
data = airfoil.data;
AerodynamicModel(-16, 2.81e5, airfoil.data, true);

alpha = -180:1:180;
Re = logspace(3, 8, 25);

for i = 1:length(Re)
    cl = zeros(length(alpha), 1);
    cd = zeros(length(alpha), 1);
    for j = 1:length(alpha)
        [cl(j), cd(j), ~] = AerodynamicModel(alpha(j), Re(i), airfoil.data, true);
    end

    figure("Visible", "off")
    plot(alpha, cl, 'b-', 'LineWidth', 1.5);
    hold on
    plot(alpha, cd, 'r-', 'LineWidth', 1.5);

    title(['Lift and Drag Curves (Re = ', num2str(Re(i), '%.2e'), ')'], 'FontSize', 14);
    
    xlabel('Angle of Attack (°)', 'FontSize', 12);
    ylabel('Coefficient', 'FontSize', 12);
    legend('C_L (Lift)', 'C_D (Drag)', 'Location', 'best');
    grid on;
    set(gca, 'FontSize', 12);

    outputFileName = [num2str(i, '%d'), ' - lift_drag_curves_Re_', num2str(Re(i), '%.2e'), '.png'];
    print(outputFileName, '-dpng', '-r300');
    close;
end
