%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pos_sim_processing.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function performs post-processing on the simulation output.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function OUTPUT = pos_sim_processing(OUTPUT, rotor_data)

    OUTPUT.height = OUTPUT.vehicle_position(:, 3);

    OUTPUT.rotor_data = rotor_data;

end