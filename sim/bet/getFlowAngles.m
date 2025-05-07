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
% 
% fprintf(">> U_T = %.2f | theta = %.2f \n", U_T, theta)

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
    % alpha = phi-theta;
    % element_state = -1;

    alpha = theta - phi;
    element_state = -1;
     
    % %# CASE 1
    % if theta >= 0 && phi < 0 && phi > -90
    %     element_state = 1;
    %     alpha = theta - phi;
    % 
    % %# CASE 2
    % elseif theta < 0 && phi < theta && phi >= -90
    %     alpha = phi - theta;
    %     element_state = 2;
    % 
    % %# CASE 3 
    % elseif theta < 0 && theta < phi && phi >= -90
    %     element_state = 3;
    %     alpha = theta - phi;
    % 
    % %# CASE 4
    % elseif theta >= 0 && phi < -90
    %     element_state = 4;
    %     alpha = theta - phi;
    % 
    % %# CASE 5
    % elseif theta < 0 && phi < -90
    %     element_state = 5;
    %     alpha = theta - phi;  
    % 
    % else
    %     error("ERROR : phi = %.2f | theta = %.2f\n", phi, theta)
    % end

end
  


end
