function [vi_convergency, counter_vi] = check_induced_velocity_convergency(CURRENT, VEHICLE, ROTOR, counter_vi)

R_i_r_new = rotationMatrix_generator(VEHICLE.orientation(1), VEHICLE.orientation(2), VEHICLE.orientation(3), "deg");
R_i_r_old = rotationMatrix_generator(CURRENT.vehicle_orientation(1), CURRENT.vehicle_orientation(2), CURRENT.vehicle_orientation(3), "deg");

old_vel = R_i_r_old * VEHICLE.velocity;
new_vel = R_i_r_new * CURRENT.vehicle_velocity;

old_UP = old_vel(3) - CURRENT.rotor_induced_velocity;
new_UP = new_vel(3) - ROTOR.induced_velocity;

fprintf("\told_UP = %.3f | new_UP = %.3f | diff = %.10e\n", old_UP, new_UP, abs(old_UP - new_UP));

if counter_vi == 10
    % fprintf("\ttime step convergency FORCED [%d]\n\n", counter_vi)
    vi_convergency = true;
    return;
end

if abs(old_UP - new_UP) < 0.1
    % fprintf("\ttime step convergency [%d]\n\n", counter_vi)
    vi_convergency = true;
else
     % fprintf("\ttime step not convergency [%d]\n\n", counter_vi);
     vi_convergency = false;
     counter_vi = counter_vi + 1;
end


end