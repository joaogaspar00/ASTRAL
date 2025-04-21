function [induced_velocity, induced_velocity_converged, UP_old, error] = compute_induced_velocity(UP_old, VEHICLE, ATMOSPHERE)

g = 9.81;

R = VEHICLE.position(3);

R_i_r = rotationMatrix_generator(VEHICLE.orientation(1), VEHICLE.orientation(2), VEHICLE.orientation(3), "deg");

V_r = R_i_r * VEHICLE.velocity;

Vc = V_r(3);
Vh = sqrt((VEHICLE.mass * g)/(2*ATMOSPHERE.density * pi * (R^2)));

Vi = Vh * ((Vc)/(2*Vh) - sqrt(((Vc)/(2*Vh)))^2 - 1);

UP_new = Vc + Vi;

error = abs(UP_old - UP_new);

if error < 0.5
    
    induced_velocity_converged = true;

else

    induced_velocity_converged = false;

end

induced_velocity = [0; 0; Vi];
UP_old = UP_new;

end