function ROTOR = compute_rotor_induced_velocity(VEHICLE, ROTOR, ATMOSPHERE)

R_i_r = rotationMatrix_generator(VEHICLE.orientation(1), VEHICLE.orientation(2), VEHICLE.orientation(3), "deg");
V_r = R_i_r * VEHICLE.velocity;

if ROTOR.velocity == 0
    ROTOR.induced_velocity = 0;
    ROTOR.operation_mode = "Rotor Off";
    return;
end

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

    vr_Vc = -Vc/vh;

    vr_vi = 1 + k1 * vr_Vc + k2 * vr_Vc^2 + k3 * vr_Vc^3 + k4 * vr_Vc^4;

    ROTOR.induced_velocity = vh * vr_vi;


end

end