function [II, II_inv] = inertia_tensor(ROTOR, BLADE)

II_BC = zeros(3,3);
II = zeros(3,3);

identity = ones(3,3);


II_BC(1,1) = 1/12 * BLADE.mass * (BLADE.Span^2 + BLADE.thickness^2);
II_BC(2,2) = 1/12 * BLADE.mass * (BLADE.chord^2 + BLADE.thickness^2);
II_BC(3,3) = 1/12 * BLADE.mass * (BLADE.Span^2 + BLADE.chord^2 ); 

for  i=1:length(ROTOR.azimutal_positions)
    R = rotationMatrix_generator(0, 0 , ROTOR.azimutal_positions(i), 'DEG');
    
    Rt = transpose(R);
    
    II = II + R * (II_BC + BLADE.mass * BLADE.RootBladeDistance * identity) * Rt;
end

II_inv = inv(II);

end