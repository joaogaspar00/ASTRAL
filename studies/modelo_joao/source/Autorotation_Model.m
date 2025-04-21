%////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\%
%////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\%
%///                                                                   \\\%
%///             Master's Thesis in Aerospace Engineering              \\\%
%///        Instituto Superior Técnico, Universidade de Lisboa         \\\%
%///        Title: Rocket system recovery using rotative wings         \\\%
%%%%           Author: João Pedro Caldeira de Sousa Marques            %%%%
%\\\       Supervisors: Prof. Filipe Szolnoky Ramos Pinto Cunha        ///%
%\\\                    Dr. Alain de Souza                             ///%
%\\\           Contact: joaopedrocaldeira@tecnico.ulisboa.pt           ///%
%\\\                                                                   ///%
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/////////////////////////////////////%
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/////////////////////////////////////%

% Model of the descent of an Autorotation Recovery System for 
% recovery of the 1st stage of a Model Rocket

clear
close all
clc 

airfoil_name_toLoad = 'n0012';
airfoil_data_file = "./airfoils/data/" + airfoil_name_toLoad + ".mat";
airfoil = load(airfoil_data_file).airfoil;
BLADE.airfoil_name = airfoil.name;
BLADE.airfoil_data = airfoil.data;

% Rotor parameters

n = 3; % Number of blades
b = 1; % Span of a blade (m)
c = 0.17; % Chord of a blade (m)
epsilon = 0.1; % blade root distance (m)

theta = 10; % Pitch angle of the blades (º)
sigma = n*b*c/(pi*b^2); % Rotor solidity (area of the blades/area of the disk)

% Characteristics of 1st Stage + Rotor System
L = 3; % Lenght of the first stage (m)
D = 0.133; % Diameter of the first stage (m) - RED
AR = L/D; % Aspect ratio of the cylinder (1st stage)
m_stage = 19; % Mass of the firs stage (kg)

m_rot = n*0.4*(b^(2.6)); % Mass of the rotor (kg)
m_control = 2.75*(b^(1.8)); % Mass of the control systems on the rotor (kg)
m_recovery = m_rot + m_control; % Mass of the recovery system (kg)
m = m_stage + m_recovery; % Mass of the system (1st stage+rotor) (kg)
percmrot = (m_recovery/m)*100;
I = (c^2+4*b^2)*m_rot/12; % Moment of Inertia of the rotor(kg*m^2) - thin rectangular plate
DL = m/(pi*b^2); % Rotor's disk loading (kg/m^2)

% Initial kinematic conditions
h0 = 1000; % Initial/Apogee height (m)
v0 = 0; % Initial vertical velocity (m/s)
w0 = 0; % Initial angular velocity of the rotor (rad/s)

% Initialisation of vectors
t = zeros(); 
h = zeros();
v = zeros();
w = zeros();

% Constants for the iterative calculation of the gravitational acceleration
% with height of the system
G = 6.674184*10^(-11); % Gravitational constant (N m^2/kg^2)
m_earth = 5.97237*10^24; % Mass of the Earth (kg)
r_earth = 6371*1000; % Earth radius (m)

% Import of the atmosphere data of density and temperature with height
height_atm = readmatrix('Atmosphere','Range','A2:A214');
rho_atm = readmatrix('Atmosphere','Range','B2:B214');
temp_atm = readmatrix('Atmosphere','Range','C2:C214');

rho_function = fit(height_atm, rho_atm,'smoothingspline');
temp_function = fit(height_atm, temp_atm,'smoothingspline');

% Import of the Cl and Cd tables with Reynols number and angle of attack
Re_low = readmatrix('CL_lowRe.xlsx','Range','B1:K1');
Cl_low = readmatrix('CL_lowRe.xlsx','Range','B2:K62');
Cd_low = readmatrix('CD_lowRe.xlsx','Range','B2:K62');
AoA_low = readmatrix('CL_lowRe.xlsx','Range','A2:A62');

Re_med = readmatrix('CL_medRe.xlsx','Range','B1:X1');
Cl_med = readmatrix('CL_medRe.xlsx','Range','B2:X57');
Cd_med = readmatrix('CD_medRe.xlsx','Range','B2:X57');
AoA_med = readmatrix('CL_medRe.xlsx','Range','A2:A57');

Re_high = readmatrix('CL_highRe.xlsx','Range','B1:U1');
Cl_high = readmatrix('CL_highRe.xlsx','Range','B2:U76');
Cd_high = readmatrix('CD_highRe.xlsx','Range','B2:U76');
AoA_high = readmatrix('CL_highRe.xlsx','Range','A2:A76');

% Import the Cd data with AR for a cylinder (1st stage approximation)
Cd_cylinderdata = readmatrix('Cdcylinder.xlsx','Range','B1:B31');
AR_data = readmatrix('Cdcylinder.xlsx','Range','A1:A31');

Cd_cylinderfunction = fit(AR_data, Cd_cylinderdata,'smoothingspline');

% Compute the value of the Cd of the cylinder (1st stage)
Cd_cylinder = Cd_cylinderfunction(AR);

% Free fall until deployment of the rotor
t_freefall = 3.09; % Time in seconds until the deployment of the rotor (t=tdeploy=tfreefall)
t_freefallvec(1) = 0;
dt = 0.01; % Time step(s)
g = G*m_earth/(r_earth+h0)^2; % Calculation of the gravitational accerho_functionleration with height
a_freefallvec(1) = - g;
v_freefallvec(1) = v0;
h_freefallvec(1) = h0;
g_forcefreefallvec(1) = -1;   

rho = rho_function(h0); % Compute density (kg/m^3) for h0
Tp = temp_function(h0); % Compute temperature (K) for h0

% Cycle in order to compute the initial conditions at the moment of rotor's
% deployment (t=tdeploy=tfreefall)
for dtf=1:1:(t_freefall/dt)
    rho = rho_function(h_freefallvec(dtf));
    Tp = temp_function(h_freefallvec(dtf));
    D_cylinder(dtf) = 0.5*Cd_cylinder*rho*((v_freefallvec(dtf))^2)*(pi*(D^2)/4); % Drag caused by the cylinder on descent
    a_freefallvec(dtf+1) = - G*m_earth/((r_earth+h_freefallvec(dtf))^2) + D_cylinder(dtf)/m;
    g = G*m_earth/(r_earth+h_freefallvec(dtf))^2;
    g_forcefreefallvec(dtf+1) = a_freefallvec(dtf+1)/g;
    
    v_freefallvec(dtf+1) = v0 - a_freefallvec(dtf+1)*dt;
    v0 = v_freefallvec(dtf+1);
    h_freefallvec(dtf+1) = h0 - v_freefallvec(dtf+1)*dt + 0.5*a_freefallvec(dtf+1)*(dt^2);
    h0 = h_freefallvec(dtf);
    t_freefallvec(dtf+1) = t_freefallvec(dtf) + dt;
end    

a_freefall = a_freefallvec(end);
a_freefallvec(end) = [];
g_forcefreefallvec(end) = [];

t_freefallvec(end) = [];

% Initialize vector for the rotor's parameters
w_freefallvec(1:1:length(t_freefallvec)) = 0;
a_angfreefallvec(1:1:length(t_freefallvec)) = 0;
thrust_freefallvec(1:1:length(t_freefallvec)) = 0;
torque_freefallvec(1:1:length(t_freefallvec)) = 0;
Cd_rotfreefallvec(1:1:length(t_freefallvec)) = 0;
lambda_freefallvec(1:1:length(t_freefallvec)) = 0;

v_freefall = v_freefallvec(end);
v_freefallvec(end) = [];
h_freefall = h_freefallvec(end);
h_freefallvec(end) = [];

% New values of v0 and h0
v0 = v_freefall;
h0 = h_freefall;

M0 = v_freefall/(331.3*sqrt(Tp/273.15)); % Mach number of the system

% Initialize vectors for the system's descent with rotor
i=1;
t(1) = t_freefall;
h(1) = h_freefall;
height = h_freefall;
v(1) = v_freefall;
w(1) = w0;
a_result(1) = a_freefall;
g = G*m_earth/(r_earth+h_freefall)^2;
g_force(1) = a_freefall/g;
a_angvec(1)=0;
lambda(1)=0;
Cd_rot(1)=0;
thrust(1)=0;
torque(1)=0;

% Variables for analysis of maximum and minimum of v_res, alpha and vtip
vres_min = 500;
vres_max = -500;
alpha_max = -500;
alpha_min = 500;
v_tipmax = -500;

% Mesh parameters
dx = 0.01; % Length of a blade element (m)
dt=0.01; % Time step (s)

% Initialize variables for axial induced velocity vi
vi=0; % Axial induced velocity (m/s)
vi_vec(1) = vi;
state = 0; % State=0 -> Windmill brake state
med = 1;
med2= 1;

% Cycle for the system's descent with the rotor
%(terminates when the system reached the ground)
while height > 0

    fprintf(">> Height = %.2f\n", height)
    
    % Atmospheric parameters
    rho = rho_function(height); % Density (kg/m^3)
    Tp = temp_function(height); % Temperature (K)
    % Sutherland's Formula for calculation of the dynamic viscosity (kg/(m*s))
    mu = 1.716*10^(-5)*((Tp/273)^(3/2))*(384/(Tp+111));

    % Initialization of variables for the cycle of convergence of vy
    conv = 1;
    convergence = 0;
    vy(1) = v0-vi;    
    w0_conv = w0;
    v0_conv = v0;
    avg=0;
    avg2=0;
    
    % Cycle for the convergence of vy (repeated for the same height until
    %the convergence is verified)
    while convergence < 1  
    
        df = 1; % Counter for going through the blade
        
        % Cycle that goes through the blade to perform calculations
        for x=epsilon:dx:(b+epsilon)
    
            v_rot = x*w0_conv; % Horizontal velocity UT (m/s)
            v_res = sqrt(v_rot^2+vy(conv).^2); % Resultant velocity U (m/s)
         
            % Induced angle of attack (º)
            if v_rot == 0
                phi = 90;
            else
                phi = atand(vy(conv)./v_rot);
            end
            
            Re = rho*v_res*c/mu; % Reynolds Number
            alpha = phi - theta; % Angle of attack (º)
                
            % Assess the maximum and minimum v_res, Re and alpha
            if v_res > vres_max
                vres_max = v_res;
                Re_max = rho*v_res*c/mu;
            end
            if v_res < vres_min
                vres_min = v_res;
                Re_min = rho*v_res*c/mu;
            end    
            if alpha > alpha_max
                alpha_max = alpha;
            end
            if alpha < alpha_min
                alpha_min = alpha;
            end    
        
            % Selects the Cl, Cd and alpha data for the correspondant Re
            % if Re < 9500
            %     LowRe=1;
            %     Re = round(Re,-3);
            %     column_Re = find(Re_low == Re);
            %     Cl_Re = Cl_low(:,column_Re);
            %     Cd_Re = Cd_low(:,column_Re);
            %     AoA = AoA_low;
            %     t_minRe = t(i);
            %     alpha_minRe = alpha;
            %     break; % There are values missing until 90º of AoA (this condition does not work)
            % 
            %     elseif (Re >= 9500 && Re < 950000)    
            %         MedRe = 1;
            %         [min,column_Re] = min(abs(Re_med - Re));
            %         clear min
            %         Re = Re_med(column_Re);
            %         Cl_Re = Cl_med(:,column_Re);
            %         Cd_Re = Cd_med(:,column_Re);
            %         AoA = AoA_med;
            %         clear column_Re
            %     else
            %         HighRe = 1;
            %         [min,column_Re] = min(abs(Re_high - Re));
            %         clear min
            %         Re = Re_high(column_Re);
            %         Cl_Re = Cl_high(:,column_Re);
            %         Cd_Re = Cd_high(:,column_Re);
            %         AoA = AoA_high;
            %         clear column_Re
            % end 
            % 
            % % Creates a spline for Cl and Cd with alpha
            % Cl_function = fit(AoA, Cl_Re,'smoothingspline');
            % Cd_function = fit(AoA, Cd_Re,'smoothingspline'); 
            % 
            % % Goes to the function to find the values of Cl and Cd for the current alpha
            % Cl = Cl_function(alpha);
            % Cd = Cd_function(alpha);

            [Cl, Cd, ~] = AerodynamicModel(alpha, Re, BLADE.airfoil_data, false);
            
            % Calculation of the infinitesimal area, lift and drag
            dA = dx*c;
            dL = 0.5*rho*dA*(v_res^2)*Cl;
            dD = 0.5*rho*dA*(v_res^2)*Cd;
            
            % Calculation of the vertical (thrust) and horizontal (torque)
            % components of the infinitesimal resultant force
            dFy(df) = dL*cosd(phi)+dD*sind(phi);
            dFz_x(df) = x*(dL*sind(phi)-dD*cosd(phi));
            
            df = df+1; 
       
        end
       
        T = n*sum(dFy); % Lift force (N) (depends on the number of blades)
        Q = n*sum(dFz_x); % Torque force (N*m) (depends on the number of blades) 
        clear dFy;
        clear dFz_x;
        
        % Drag force caused by the first stage's bogy
        D_cylinder = 0; %0.5*Cd_cylinder*rho*(v0_conv)^2*(pi*(D^2)/4);
        
        % Calculation of the new values (for the next iteration on the converngence cycle)
        a_res = (T+D_cylinder)/m - g; % Resultant acceleration (m/s^2)
        v0_conv = v0 - a_res*dt; % Vertical velocity of the system (m/s)
        a_ang = Q/I; % Angular acceleration (rad/s^2)
        w0_conv = w0 + a_ang*dt; % Angular velocity (rad/s)
        
        w0_convvec(conv+1) = w0_conv; % To make an average calculation if the converging stops
        
        vh = sqrt((m*g)/(2*rho*pi*b^2)); % Hover velocity (m/s)
        
        % Assess if the operational state of the rotor
        % Vortex Ring State should not be entered, in this model
        if(abs(v0_conv)/vh < 2) && state == 0
           DISP2 = ['Entered in Vortex Ring State. Vc/(2*vh)=',num2str(v0_conv/(2*vh))];
           disp(DISP2);
           %break;
           state = 1;
        end 
       
       if state==0 % Windmill Brake State
        vi = vh*((v0_conv/(2*vh)) - sqrt((v0_conv/(2*vh))^2-1)); % Axial Induced Velocity (m/s)
       else % Vortex Ring State
        vi = 1 - 1.125*(-v0_conv/vh)-1.372*((-v0_conv/vh)^2)-1.718*((-v0_conv/vh)^3)-0.655*((-v0_conv/vh)^4);      
       end
       
       vy(conv+1) = v0_conv - vi; % Velocity in the plane of the rotor (UP=v0-vi) (m/s)
       
       if abs(vy(conv+1)-vy(conv)) < 10^(-4) % Convergence criterion
           convergence = 1; % Convergence achieved (the cycle will terminate 
                            %and the model will follow for the next time step)
       end
       
       % Adjustment if vy is not converging. This should only be considered,
       % though, if the model already reached and equilibrium state (meaning that the adjusment
       % will not provoke major changes in the final result). This is a rare situation.
       
       if avg2 == 1
           convergence = 1
           for s=1:1:length(vy)
            vyavg(med2-1,s) = vy(s);
           end
       end    
       
       if conv > 99 && avg == 0 % Adjustment for helping converging (After 99 iterations)
           avg = 1
           t_avg(med) = t(i) % To assess the time at which it happened
           vy(conv+1) = (vy(conv)+vy(conv-1))/2; % Average of the most recent value and the previous
           w0_conv = (w0_convvec(conv) + w0_convvec(conv-1))/2;
           med = med+1; % Counter to assess how many times it happened
       end  
       
       if conv > 199 && avg == 1 && convergence == 0 % Adjustment for helping converging (After 199 iterations and if the first adjusment did not solve the problem)
           avg2 = 1;
           vy(conv+1) = (vy(2)+vy(3))/2; % Average between the second and third iterations' values
           w0_conv = (w0_convvec(2) + w0_convvec(3))/2;
           med2 = med2 + 1; % Counter to assess how many times it happened
       end   
    
       conv = conv+1;
       
     end
     
       % Following the convergence, calculation of the parameters for the next
       % time step
       Cd_rot(i+1) = T/(0.5*rho*(vy(conv))^2*(pi*b^2));
       torque(i+1) = Q;
       thrust(i+1) = T;
       a_result(i+1) = a_res;
       g_force(i+1) = a_res/g;
       vi_vec(i+1) = vi;
       
       % Prepare the initial values of velocity and height for the next
       % iteration
       v(i+1) = v0_conv;
       v0 = v(i+1);
       h(i+1) = h0 - v(i+1)*dt + 0.5*a_res*(dt^2);
       h0 = h(i+1);
       height = h(i+1);
       
       % Calculation of the gravitational acceleration for the next iteration
       % (depends on the height of the system)
       g = G*m_earth/(r_earth+h0)^2;
       
       % Calculation of the values for the next time step (iteration)
       a_angvec(i+1) = a_ang;
       w(i+1) = w0_conv;
       % Prepare the initial values of angular velocity the next iteration
       w0 = w(i+1);
       
       Tp = temp_function(height);
       a_sound = 331.3*sqrt(Tp/273.15);
       v_tip = w0*b; % Rotor's tip velocity (m/s)
       
       % Assess the maximum tip Mach Number
       if v_tip > v_tipmax
           v_tipmax = v_tip;
           M_maxtip = v_tip/a_sound;
       end    
       
       lambda(i+1) = vy(conv)/v_tip; % Axial advance ratio
       
       clear vy;
        
       t(i+1)=t(i)+dt; % Store time values
        
       i=i+1; 
     
end

% Concatenation of the freefall and descent with rotor's vectors for plots
v_final = [v_freefallvec v];
h_final = [h_freefallvec h];
t_final = [t_freefallvec t];
a_final = [a_freefallvec a_result];
w_final = [w_freefallvec w];
a_angfinal = [a_angfreefallvec a_angvec];
g_forcefinal = [g_forcefreefallvec g_force];
thrust_final = [thrust_freefallvec thrust];
torque_final = [torque_freefallvec torque];
Cd_rotfinal = [Cd_rotfreefallvec Cd_rot];
lambda_final = [lambda_freefallvec lambda];
RPM = w_final*60./(2*pi);

results = [t_final' h_final' v_final' a_final' w_final' a_angfinal' g_forcefinal' thrust_final' torque_final' Cd_rotfinal' lambda_final'];

%%


save(".\studies\modelo_joao\source\sim_mod_prev.mat");

% Plots

% figure(1)
% plot(t_final,h_final)
% title('Model Rocket height with time')
% xlabel('Time (s)')
% ylabel('Height (m)')
% 
% figure(2)
% plot(t_final,v_final)
% title('Model Rocket vertical velocity with time')
% xlabel('Time (s)')
% ylabel('Vertical velocity (m/s)')
% 
% figure(3)
% plot(t_final,a_final)
% title('Model Rocket vertical acceleration with time')
% xlabel('Time (s)')
% ylabel('Vertical acceleration (m/s^2)')
% 
% figure(4)
% plot(t_final,w_final)
% title('Model Rocket angular velocity with time')
% xlabel('Time (s)')
% ylabel('Angular velocity (rad/s)')
% 
% figure(5)
% plot(t_final,a_angfinal)
% title('Model Rocket angular acceleration with time')
% xlabel('Time (s)')
% ylabel('Angular acceleration (rad/s^2)')
% 
% figure(6)
% plot(t_final,g_forcefinal)
% title('Model Rocket Gs with time')
% xlabel('Time (s)')
% ylabel('Gs')
% 
% figure(7)
% plot(t_final,torque_final)
% title('Model Rocket Torque with time')
% xlabel('Time (s)')
% ylabel('Torque (N*m)')
% 
% figure(8)
% plot(t_final,thrust_final)
% title('Model Rocket Thrust with time')
% xlabel('Time (s)')
% ylabel('Thrust (N)')