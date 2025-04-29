%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pos_sim_processing.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function performs post-processing on the simulation OUTPUT.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function OUTPUT = pos_sim_processing(OUTPUT, rotor_data)

    OUTPUT.rotor_rpm = OUTPUT.rotor_velocity * 60/(2*pi);

    OUTPUT.rotor_data = rotor_data;

end