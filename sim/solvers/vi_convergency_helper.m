function  [VEHICLE, ROTOR] = vi_convergency_helper(VEHICLE, ROTOR)

if ROTOR.vi_iter_counter > 5 && ROTOR.vi_iter_counter <= 10
    alpha = 0.5;
    beta = 0.5;
else
    alpha = 0.7;
    beta = 0.3;
end

if ROTOR.vi_iter_counter > 5
    VEHICLE.velocity = alpha * VEHICLE.conv_velocity_vec(:, end) + beta * VEHICLE.conv_velocity_vec(:, end-1); 
    ROTOR.velocity = alpha * ROTOR.conv_velocity_vec(end) + beta * ROTOR.conv_velocity_vec(end-1);
end

end