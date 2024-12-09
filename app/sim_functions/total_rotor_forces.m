function [F, T, T_shaft] = total_rotor_forces(F_blade, T_blade)


F(1) = 0;

F(2) = 0;

F(3) = sum(F_blade(3,:  ));


T(1) = 0;

T(2) = 0;

T(3) = 0;

T_shaft = sum(T_blade(1,:));

F = F';
T = T';

end
