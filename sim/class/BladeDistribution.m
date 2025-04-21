classdef BladeDistribution
    properties
        total_velocity
        dL
        dD

        phi
        alpha
        theta
        
        element_state

        Ma
        Re

        Cl
        Cd

        U_T
        U_R
        U_P
       
        flow_mode
        
        v_i       

        dF_a_x
        dF_a_y
        dF_a_z

        dF_e_x
        dF_e_y
        dF_e_z

        dF_i_x
        dF_i_y
        dF_i_z

        dT_r_x
        dT_r_y
        dT_r_z

        dT_r

        f_prandtl     
    end

    methods
        % Construtor
        function obj = BladeDistribution(total_velocity, dL, dD, phi, alpha, theta,...
                                         element_state, Ma, Re, Cl, Cd, ...
                                         U_T, U_R, U_P, flow_mode, v_i, ...
                                         dF_a, dF_e, dF_i, dT_r, ...
                                         f_prandtl)

            obj.total_velocity = total_velocity;
            obj.dL = dL;
            obj.dD = dD;

            obj.phi = phi;
            obj.alpha = alpha;
            obj.theta = theta;

            obj.element_state = element_state;

            obj.Ma = Ma;
            obj.Re = Re;

            obj.Cl = Cl;
            obj.Cd = Cd;

            obj.U_T = U_T;
            obj.U_R = U_R;
            obj.U_P = U_P;

            obj.flow_mode = flow_mode;

            obj.v_i = v_i;

            obj.dF_a_x = dF_a(1, :);
            obj.dF_a_y = dF_a(2, :);
            obj.dF_a_z = dF_a(3, :);

            obj.dF_e_x = dF_e(1, :);
            obj.dF_e_y = dF_e(2, :);
            obj.dF_e_z = dF_e(3, :);

            obj.dF_i_x = dF_i(1, :);
            obj.dF_i_y = dF_i(2, :);
            obj.dF_i_z = dF_i(3, :);

            obj.dT_r_x = dT_r(1, :);
            obj.dT_r_y = dT_r(2, :);
            obj.dT_r_z = dT_r(3, :);

            obj.f_prandtl = f_prandtl;


        end
    end
end
