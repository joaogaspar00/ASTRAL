% update this file with the global variables

% Global variables
global M_terra;
global R_terra;
global G;
global M_vehicle;
global M_rotor;
global M_system;
global R_rotor;
global c_rotor;
global AR;
global tc;
global Nb;
global No_elements;
global I_rotor;

global pos_sec;
global dy;
global theta;

global root_theta;
global tip_theta;

global fileID;
global fileID_elemForces;
global debbug;

global AR_input;
global AERODAS_coeff;

global sBlades_position;

global dt_steady;  
global dt_var;
global t_deploy_rotor;
global t_steady_rotor;
global time_limit_sim;

global init_height;

global solver;

global version;

global limit_rpm;  

global debbug_elements;
global debbug_file;

global openRotor;

% General simulation state
global sTime;

global sA;
global sV;
global sP;

global sF_gravity;
global sF_drag_cilinder;

global sF_blade;
global sT_blade;

global sF_rotor;
global sT_rotor;

global sF;
global sT;

global sRotor_angular_position;
global sRotor_angular_velocity;
global sRotor_angular_acceleration;

% Element specific state
global s_t_elements;

global s_df_x;
global s_df_y;
global s_df_z;

global s_dtau_x;
global s_dtau_y;
global s_dtau_z;

global s_v_x;
global s_v_y;
global s_v_z;

global s_ang_v;
global s_total_v;

global s_dL;
global s_dD;

global s_alpha;
global s_theta;
global s_phi;
global s_element_state;

global s_Ma;  
global s_Re;

global s_Cl;
global s_Cd;

global s_U_T;
global s_U_R;
global s_U_P;

global s_F_prandtl;

global outputFile_AERODAS;
global cmd_debug_AERODAS;
