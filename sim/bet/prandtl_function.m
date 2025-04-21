%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prandtl_function.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function calculates the Prandtl tip and root losses for a rotor blade
% using the Prandtl's tip loss model. The tip and root losses are important
% factors in rotor aerodynamics, particularly for calculating the distribution 
% of aerodynamic forces along the blade span.
%
% The function computes the tip and root correction factors (F_root and F_tip)
% based on the angle of attack at the root and tip, as well as the radial position
% of the blade, using the formula derived from Prandtl's loss model.
%
% The final output is the combined Prandtl loss factor, which accounts for both
% the tip and root corrections.
%
% Inputs:
% - phi_root: Angle of attack at the root (in degrees).
% - phi_tip: Angle of attack at the tip (in degrees).
% - ROTOR: Structure containing rotor parameters such as number of blades (Nb).
% - BLADE: Structure containing blade parameters such as position sections and span.
%
% Outputs:
% - F_prandtl: The combined Prandtl loss factor for the rotor blade (dimensionless).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function F_prandtl = prandtl_function (phi_root, phi_tip, ROTOR, BLADE)

    % Convert angles from degrees to radians
    phi_root = phi_root * pi / 180;
    phi_tip = phi_tip * pi / 180;

    % Compute the radial position of the blade elements (normalized)
    r = (BLADE.pos_sec(2,:) - BLADE.RootBladeDistance) ./ BLADE.Span;

    % Calculate the Prandtl loss factors for the root and tip regions
    % Ensure f_root and f_tip are positive to avoid issues with the exponential function
    f_root = abs(ROTOR.Nb/2 .* r ./ ((1 - r) * phi_root));  
    f_tip = abs(ROTOR.Nb/2 .* ((1 - r) ./ (r * phi_tip)));

    % Calculate the loss factors using the inverse cosine function,
    % ensuring that the values inside the cosine function are within the valid range [-1,1]
    F_root = 2 / pi * acos(min(1, exp(-f_root))); 
    F_tip = 2 / pi * acos(min(1, exp(-f_tip)));

    % The final Prandtl loss factor is the product of the tip and root loss factors
    F_prandtl = F_tip .* F_root;

end



