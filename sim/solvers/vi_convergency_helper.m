function  [VEHICLE, ROTOR] = vi_convergency_helper(VEHICLE, ROTOR)

if ROTOR.vi_iter_counter > 3
    
   VEHICLE.velocity = (VEHICLE.conv_velocity_vec(end) + VEHICLE.conv_velocity_vec(end-1) + VEHICLE.conv_velocity_vec(end-2))/3; 
   ROTOR.velocity = (ROTOR.conv_velocity_vec(end) + VEHICLE.conv_velocity_vec(end-1) + VEHICLE.conv_velocity_vec(end-2))/3;

end
    
end