function II = inertia_tensor(BLADE)

II_BC = zeros(3,3);
II = zeros(3,3);

identity = ones(3,3);


II_BC(1,1) = 1/12 * BLADE.mass * (BLADE.Span^2 + BLADE.thickness^2);
II_BC(2,2) = 1/12 * BLADE.mass * (BLADE.chord^2 + BLADE.thickness^2);
II_BC(3,3) = 1/12 * BLADE.mass * (BLADE.chord^2 + BLADE.Span^2); 

for  i=1:length(BLADE.fixed_positions)

    R = rotationMatrix_generator(BLADE.fixed_positions(i), 0 , 0, 'DEG');
    
    Rt = transpose(R);
    
    II = II + R * (II_BC + BLADE.mass * BLADE.RootBladeDistance * identity) * Rt;
end

end