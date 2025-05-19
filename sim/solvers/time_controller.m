%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time_controller.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function updates the simulation clock by advancing it with the
% defined time step. It also checks whether the maximum simulation time 
% has been reached and sets a stop flag accordingly.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TIME = time_controller (TIME, VEHICLE)



if TIME.clock > TIME.time_limit_sim
    TIME.stop_flag = true;
end


TIME.clock = TIME.clock + TIME.dt;

end