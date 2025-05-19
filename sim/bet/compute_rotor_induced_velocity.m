function ROTOR = compute_rotor_induced_velocity(VEHICLE, ROTOR, BLADE, ATMOSPHERE, F_rotor)

R_i_r = rotationMatrix_generator(VEHICLE.orientation(1), VEHICLE.orientation(2), VEHICLE.orientation(3), "deg");
V_r = R_i_r * VEHICLE.velocity;

if ROTOR.velocity == 0
    ROTOR.induced_velocity = 0;
    ROTOR.operation_mode = "Off";
    return;
end


disp(VEHICLE.velocity)

if abs(VEHICLE.velocity(1)) > 0.01 || abs(VEHICLE.velocity(2)) > 0.01

    ROTOR.operation_mode = 2;

    Vf = [V_r(1); V_r(2); 0];
    Vc = [0; 0; V_r(3)];

    ang_vel_tip = ROTOR.velocity * (BLADE.Span + BLADE.RootBladeDistance);

    if ang_vel_tip == 0
         ROTOR.induced_velocity = 0;
         ROTOR.operation_mode = -1;
         return;
    end

    mu_x = norm(Vf) / ang_vel_tip;
    mu_y = norm(Vc) / ang_vel_tip;

    alpha = acosd(dot(V_r, Vf) / (norm(V_r) * norm(Vf)));       

    Ct = F_rotor(3) / (0.5 * ATMOSPHERE.density * ROTOR.disk_area * (ang_vel_tip^2));

    lambda_h = sqrt(Ct / 2);

    prev_lambda = lambda_h;

    counter = 1;

    while true
        ff = prev_lambda - mu_x * tand(alpha) - Ct / (2 * sqrt(mu_x^2 + prev_lambda^2)) + mu_y;
        fd = 1 + Ct / 2 * (mu_x^2 + prev_lambda^2)^(-3/2) * prev_lambda;

        lambda = prev_lambda - (ff / fd);

        error_lambda = abs((lambda - prev_lambda) / prev_lambda);


        if error_lambda < 0.001
            fprintf("\t vi converged [%d]\n", counter);
            break;
        else
            fprintf("\t>> vi not converged [%d], updating lambda\n", counter);
            prev_lambda = lambda;
            counter = counter + 1;
        end
    end

    ROTOR.induced_velocity = lambda * ang_vel_tip;

else

    vh = sqrt((VEHICLE.mass * 9.81)/(2 * ATMOSPHERE.density * ROTOR.disk_area));

    Vc = V_r(3);

    if Vc/vh < -2
        
            ROTOR.operation_mode = 0;
            
            ROTOR.induced_velocity = -vh * (Vc/(2*vh) + sqrt((Vc/(2*vh))^2 - 1));
        
    else
        
        ROTOR.operation_mode = 1;
    
        k1 = -1.125;
        k2 = -1.372; 
        k3 = -1.718;
        k4 = -0.655;
    
        vr_Vc = Vc/vh;
    
        vr_vi = 1 + k1 * vr_Vc + k2 * vr_Vc^2 + k3 * vr_Vc^3 + k4 * vr_Vc^4;
    
        ROTOR.induced_velocity = vh * vr_vi;
    end

end


end