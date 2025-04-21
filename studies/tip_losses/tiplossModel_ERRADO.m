%% MODELO CORRETO

clc
close all
clear

r = 0:0.01:1;

Nb = [2 4];
phi = [0.2 0.5];

lg = [];

figure;

for i = 1:length(Nb)
    for j = 1:length(phi)
    
        str = ['Nb = ' num2str(Nb(i)) ', \phi = ' num2str(phi(j))];
        lg = [lg; str];
      
        ftip = Nb(i)/2 .* ((1-r)./(r*phi(j)));
        froot = Nb(i)/2 .* (r./((1-r)*phi(j)));


        f = ftip.*froot;

        F = 2/pi * acos(exp(-f));

        F(1) = 0;
        F(length(F)) = 0;

        plot(r, F, 'LineWidth',2)
        hold on;
    
    end
end

hold off;

xlabel('r'); xlim([0 1]);
ylabel('F'); ylim([0 1]);


title('Prandtl Tip Loss Function');
legend(lg)


% Save the figure as a PDF file
saveas(gcf, 'prandtltiplossfunction-errado.png');