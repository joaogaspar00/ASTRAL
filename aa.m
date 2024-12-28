clc
clear

load("airfoils\naca0012.mat")

airfoil_data = airfoil.data;

rho = 1.225;
c=1;
mu = 3.178e-5;

U_e = [10; 0; -5];
theta = -5;

nU = norm(U_e);

Re = rho * c * nU / mu;


ex_e = [1; 0; 0];

if U_e(3)>=0
    phi = acosd(dot(ex_e, U_e )/(norm(U_e)*norm(ex_e)));
else
    phi = -acosd(dot(ex_e, U_e )/(norm(U_e)*norm(ex_e)));
end

alpha = theta - phi


[Cl, Cd, ~] = AerodynamicModel(alpha, Re, airfoil_data, false);


dL = 1/2 * rho * nU^2 * Cl * c
dD = 1/2 * rho * nU^2 * Cd * c


fa = [dD; 0; dL]


Rt_e_a = [-1 0 0; 0 1 0; 0 0 1] * rotationMatrix_generator(0, phi, 0)


Rt_a_e = Rt_e_a'


f_e =  Rt_a_e * fa
 

%%
clc
clear
close all

[polar, foil] = xfoil('NACA0012', 25, 1e6, 0,'oper iter 250 vpar n 12');

CL = polar.CL
CD = polar.CD


figure()
plot(foil.x, foil.y)
axis equal
grid
xlim([0 1])

%%
clc
clear
close all

% MATLAB Script to Generate Airfoil Coordinates Using XFOIL

% User-defined parameters
airfoil_name = 'NACA22112'; % Airfoil type (e.g., 'NACA0012', or provide a custom name)
output_file = './airfoils/coord/NACA0012.dat'; % Output file name
xfoil_path = '.\sim\aerodynamic_model\XFOIL\xfoil.exe'; % Path to the XFOIL executable

% Create XFOIL input commands
commands = {
    sprintf('NACA %s', airfoil_name(5:end)) % Specify the NACA airfoil
    'PANE'                                  % Refine paneling
    sprintf('SAVE %s', output_file)         % Save coordinates to file
    'QUIT'                                  % Exit XFOIL
};

% Write commands to a temporary file
input_file = 'xfoil_input.txt';
fid = fopen(input_file, 'w');
for i = 1:length(commands)
    fprintf(fid, '%s\n', commands{i});
end
fclose(fid);

% Run XFOIL with the input file
system(sprintf('%s < %s', xfoil_path, input_file));

% Load and plot the generated airfoil coordinates (optional)
% Verifique se o arquivo existe
if isfile(output_file)
    % Abra o arquivo e leia as coordenadas ignorando a primeira linha
    fid = fopen(output_file, 'r');
    fgetl(fid); % Ignora a primeira linha
    coords = fscanf(fid, '%f %f', [2 Inf])'; % Lê os dados numéricos
    fclose(fid);
    
    % Plote as coordenadas
    figure;
    plot(coords(:, 1), coords(:, 2), 'b-');
    axis equal;
    grid on;
    title(sprintf('Airfoil: %s', airfoil_name));
    xlabel('x-coordinate');
    ylabel('y-coordinate');
else
    error('Failed to generate airfoil coordinates. Check your XFOIL setup.');
end

% Clean up temporary files
delete(input_file);
