%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getFlowAngles.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function computes the angle of attack (alpha) and inflow angle (phi)
% for a given blade element based on the tangential (U_T) and axial (U_P)
% components of the relative velocity. The function uses basic vector math
% to calculate the angles, and it also determines the flow regime (element_state).
%
% Inputs:
% - U_T: Tangential velocity component at the blade element [m/s]
% - U_P: Axial velocity component at the blade element [m/s]
% - theta: Blade pitch angle at the element [degrees]
%
% Outputs:
% - alpha: Angle of attack at the blade element [degrees]
% - phi: Inflow angle at the blade element [degrees]
% - element_state: Flow regime indicator:
%   - 0: No flow (if velocity magnitude is zero)
%   - 1: Flow is present
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [alpha, phi, element_state] = getFlowAngles(U_T, U_P, theta)

% Initialize velocity vector in the effective flow direction (U_T in x, U_P in z)
U_e = [U_T; 0; U_P];

% Unit vector pointing in the negative x direction (reference for inflow angle)
ex_e = [-1; 0; 0];

% Check if the velocity vector is zero (no relative motion)
if norm(U_e) == 0
    % If no velocity, both angles are zero and no flow state
    phi = 0;
    alpha = 0;
    element_state = 0;
else
    % Calculate the inflow angle phi using the dot product between the velocity vector and reference
    if U_T == 0
        phi = -90;
    else
        if U_T > 0
            phi = atand(U_P / U_T);
        else
            phi = -90 - atand(U_P / U_T);
        end
    end

    % Calculate the angle of attack alpha based on the pitch angle and inflow angle
    if phi >= theta
        alpha = phi - theta; % Positive angle of attack (relative to blade pitch)
    else
        alpha = theta - phi; % Negative angle of attack (relative to blade pitch)
    end
    
    % Set the flow state to 1 indicating that there is flow
    element_state = 1;
end

end
