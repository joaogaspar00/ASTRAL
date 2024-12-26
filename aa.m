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
 



