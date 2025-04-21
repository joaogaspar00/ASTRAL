%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotationMatrix_generator.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function generates a rotation matrix based on three Euler angles 
% (roll, pitch, and yaw). The function takes the input angles and converts 
% them into a rotation matrix that can be used for transforming vectors between 
% different coordinate frames. The rotation is performed in a "ZYX" sequence, 
% meaning yaw (ang_z), pitch (ang_y), and roll (ang_x) rotations are applied 
% in that order.
%
% The input angles can be provided in either radians or degrees, depending 
% on the specified angle mode.
%
% Inputs:
% - ang_z: Yaw angle (in radians or degrees).
% - ang_y: Pitch angle (in radians or degrees).
% - ang_x: Roll angle (in radians or degrees).
% - angle_mode: The unit of the input angles, either "RAD" for radians or 
%               "DEG" for degrees.
%
% Outputs:
% - R: The 3x3 rotation matrix (dimensionless) that represents the combined
%      rotations defined by the Euler angles.
%
% Errors:
% - If any of the angles (ang_x, ang_y, ang_z) or the angle_mode are not 
%   provided, an error message will be displayed.
% - The function assumes the "ZYX" rotation sequence.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function R = rotationMatrix_generator(ang_z, ang_y, ang_x, angle_mode)
    
    % Check for missing inputs
    if isempty(ang_x) || isempty(ang_y) || isempty(ang_z)
        error("Error: Euler angle not defined (rotationMatrix_generator)")
    end

    if isempty(angle_mode)
        error("Error: Error mode not defined (rotationMatrix_generator)")
    end    

    % Convert angles to radians if necessary
    if strcmp(angle_mode, "RAD") || strcmp(angle_mode, "rad")
        eul = [ang_z, ang_y, ang_x];
    elseif strcmp(angle_mode, "DEG") || strcmp(angle_mode, "deg")
        eul = pi / 180 * [ang_z, ang_y, ang_x];  % Convert from degrees to radians
    else
        error("Error: Invalid angle mode. Use 'RAD' or 'DEG'.")
    end

    % Generate rotation matrix using Euler angles in ZYX convention
    R = eul2rotm(eul, "ZYX");

end
