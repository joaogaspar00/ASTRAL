function ROTOR = check_induced_velocity_convergency(PREV_STATE, VEHICLE, ROTOR)

if ~ROTOR.rotorIsOpen
    ROTOR.vi_convergency = true;
end

R_i_r = rotationMatrix_generator(PREV_STATE.vehicle_orientation(1), PREV_STATE.vehicle_orientation(2), PREV_STATE.vehicle_orientation(3), "deg");

old_vel = R_i_r * VEHICLE.prev_velocity;
old_UP = old_vel(3) - ROTOR.prev_induced_velocity;

new_vel = R_i_r * VEHICLE.velocity;
new_UP = new_vel(3) - ROTOR.induced_velocity;


% fprintf("\t\t[%s]  V_old [%.2f %.2f %.2f] | V_new [%.2f %.2f %.2f] -- vi_old = %.5f | old_UP = %.2f | vi_new = %.5f | new_UP = %.2f | diff = %.10e\n\n", ...
%         ROTOR.operation_mode, VEHICLE.prev_velocity, VEHICLE.velocity, ROTOR.prev_induced_velocity, old_UP, ROTOR.induced_velocity, new_UP, abs(old_UP - new_UP));


ROTOR.vi_error = abs(old_UP - new_UP);

if abs(old_UP - new_UP) < 0.1

    ROTOR.vi_convergency = true;

else

    if ROTOR.vi_iter_counter == 1
        return;

    else
        ROTOR.vi_convergency = false;
        ROTOR.vi_iter_counter = ROTOR.vi_iter_counter + 1;
    end
     
end


end