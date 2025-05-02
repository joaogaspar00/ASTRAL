function  [VEHICLE, ROTOR] = vi_convergency_helper(VEHICLE, ROTOR)

if ROTOR.vi_iter_counter > 3 && ROTOR.vi_iter_counter < 5

    VEHICLE.velocity = (VEHICLE.conv_velocity_vec(:, end) + VEHICLE.conv_velocity_vec(:, end-1)) / 2; 
    ROTOR.velocity = (ROTOR.conv_velocity_vec(end) + ROTOR.conv_velocity_vec(end-1)) / 2;

elseif ROTOR.vi_iter_counter == 10

    VEHICLE.velocity = (VEHICLE.conv_velocity_vec(:, 2) + VEHICLE.conv_velocity_vec(:, 3)) / 2; 
    ROTOR.velocity = (ROTOR.conv_velocity_vec(2) + ROTOR.conv_velocity_vec(3)) / 2;
    
end


end