function induced_velocity = compute_rotor_induced_velocity(VEHICLE, ROTOR, ATMOSPHERE, BLADE, F_rotor)

% fprintf(">> Compute Rotor Induced Velocity started\n");

R_i_r = rotationMatrix_generator(VEHICLE.orientation(1), VEHICLE.orientation(2), VEHICLE.orientation(3), "deg");

V_r = R_i_r * VEHICLE.velocity;

% fprintf(">> V_r: [%f, %f, %f]\n", V_r(1), V_r(2), V_r(3));

Vf = [V_r(1); V_r(2); 0];
Vc = [0; 0; V_r(3)];

ang_vel_tip = ROTOR.velocity * (BLADE.Span + BLADE.RootBladeDistance);
% fprintf(">> Angular velocity at the tip: %f\n", ang_vel_tip);

if ang_vel_tip == 0
    induced_velocity = 0;
    return;
end

mu_x = norm(Vf) / ang_vel_tip;
mu_y = norm(Vc) / ang_vel_tip;

% fprintf(">> mu_x: %f, mu_y: %f\n", mu_x, mu_y);

alpha = acosd(dot(V_r, Vf) / (norm(V_r) * norm(Vf)));
% fprintf(">> Alpha: %f degrees\n", alpha);

if abs(alpha) < 85

    mode = "forward flight";
 
    Ct = F_rotor(3) / (0.5 * ATMOSPHERE.density * ROTOR.disk_area * (ang_vel_tip^2));
    
    % fprintf(">> Ct: %f\n", Ct);
    
    lambda_h = sqrt(Ct / 2);
    
    prev_lambda = lambda_h;
    
    counter = 1;
    
    % fprintf(">> Starting iteration for lambda convergence\n");
    
    while true
        ff = prev_lambda - mu_x * tand(alpha) - Ct / (2 * sqrt(mu_x^2 + prev_lambda^2)) + mu_y;
        fd = 1 + Ct / 2 * (mu_x^2 + prev_lambda^2)^(-3/2) * prev_lambda;
        
        lambda = prev_lambda - (ff / fd);
    
        error_lambda = abs((lambda - prev_lambda) / prev_lambda);
    
        % fprintf(">> Iteration [%d]: lambda = %f, error = %f\n", counter, lambda, error_lambda);
    
        if error_lambda < 0.001
            fprintf("\t vi converged [%d]\n", counter);
            break;
        else
            fprintf("\t>> vi not converged [%d], updating lambda\n", counter);
            prev_lambda = lambda;
            counter = counter + 1;
        end
    end
    
    induced_velocity = lambda * ang_vel_tip;  
    
else
    
    vh = sqrt(F_rotor(3)/(2 * ATMOSPHERE.density * ROTOR.disk_area));
    Vc = V_r(3);

    if -2*vh <= Vc 
        mode = "vortex ring state"; 
        k1 = - 1.125;
        k2 = - 1.372; 
        k3 = - 1.718;
        k4 = - 0.655;

        v_v = Vc/vh;
 
        induced_velocity = -vh * (1 + k1 * v_v + k2 * v_v^2 + k3 * v_v^3 + k4 * v_v^4);
    else
        mode = "windmill break state";
        induced_velocity = -vh * (- Vc/(2*vh) - sqrt((Vc/(2*vh))^2 - 1));
    end

end

% fprintf("\t[%s] induced velocity: %.3f\n", mode, induced_velocity);


end







