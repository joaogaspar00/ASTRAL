function OUTPUTS = rotor_analysis(VEHICLE, ROTOR, BLADE, SIM, ATMOSPHERE)
    
OUTPUTS.U_T=[];
OUTPUTS.U_R=[];
OUTPUTS.U_P=[];
OUTPUTS.flowMode=[];
OUTPUTS.df_x=[];
OUTPUTS.df_y=[];
OUTPUTS.df_z=[];
OUTPUTS.alpha=[];
OUTPUTS.phi=[];
OUTPUTS.element_state=[];
OUTPUTS.Ma=[];
OUTPUTS.Re=[];
OUTPUTS.Cd=[];
OUTPUTS.Cl=[];

BLADE.R_i_b = rotationMatrix_generator(VEHICLE.orientation(1), VEHICLE.orientation(2), VEHICLE.orientation(3));
BLADE.R_b_i = transpose(BLADE.R_i_b);

for azimute_index = 1:length(ROTOR.azimutal_positions)

    fprintf("> Azimute: %.2f\n", ROTOR.azimutal_positions(azimute_index)*180/pi)

    VEHICLE.velocity_b = ROTOR.R_r_b(:, :, azimute_index) *   BLADE.R_i_b * VEHICLE.inertial_velocity;

    % fprintf("Vb_x = %.2f | Vb_y = %.2f | Vb_z = %.2f \n", V_b(azimute_index, :));

   [OUTPUTS, ~, ~] = compute_blade_force_testFunc(OUTPUTS, VEHICLE, ROTOR, BLADE, SIM, ATMOSPHERE);

end




end