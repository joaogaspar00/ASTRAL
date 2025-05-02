function[TIME, ROTOR] = RK4_solver_convergency (TIME, ROTOR)

if abs(ROTOR.last_velocity - ROTOR.velocity) < 1e-3
    ROTOR.convergency_counter = ROTOR.convergency_counter + 1;
else
    TIME.convergency_flag = false;
    ROTOR.convergency_counter = 0;
end
 
if ROTOR.convergency_counter == 1e6 && ROTOR.rotorIsOpen
    TIME.convergency_flag = true;
    ROTOR.convergency_counter = 0;
    disp("achieved convergency")
end

ROTOR.last_velocity = ROTOR.velocity;

end

