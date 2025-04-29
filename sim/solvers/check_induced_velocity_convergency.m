function ROTOR = check_induced_velocity_convergency(PREV_STATE, VEHICLE, ROTOR)

if ~ROTOR.rotorIsOpen
    ROTOR.vi_convergency = true;
end

R_i_r = rotationMatrix_generator(PREV_STATE.vehicle_orientation(1), PREV_STATE.vehicle_orientation(2), PREV_STATE.vehicle_orientation(3), "deg");

old_vel = R_i_r * VEHICLE.prev_velocity;
old_UP = old_vel(3) - ROTOR.prev_induced_velocity;

new_vel = R_i_r * VEHICLE.velocity;
new_UP = new_vel(3) - ROTOR.induced_velocity;

ROTOR.vi_error = abs(old_UP - new_UP);

if ROTOR.vi_error < 1e-2

    ROTOR.vi_convergency = true;

else

    ROTOR.vi_convergency = false;
    ROTOR.vi_iter_counter = ROTOR.vi_iter_counter + 1;
    fprintf("\t [%d] Error: %.5e \n", ROTOR.vi_iter_counter, ROTOR.vi_error)

    % Limit vi convergency loop no. of iterations
    if ROTOR.vi_iter_counter == 10
         ROTOR.vi_convergency = true;
    end
    
end

end