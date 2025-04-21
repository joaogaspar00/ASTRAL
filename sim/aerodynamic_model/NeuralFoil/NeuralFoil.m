%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NeuralFoil.m
%
% Author: João Gaspar
% Last Modified: April 21, 2025
% Version: 1.0
%
% Description:
% This function interfaces with a Python script (NeuralAirfoil_2D.py) to 
% compute the aerodynamic coefficients (CL, CD, CM) of a given airfoil 
% based on the Reynolds number, Mach number, and angle of attack using 
% neural network-based models.
%
% The Python script is executed via the `pyrunfile` function and returns
% the aerodynamic coefficients for the specified conditions.
%
% Inputs:
% - airfoil: Name or identifier of the airfoil (e.g., 'NACA0012').
% - Re: Reynolds number (dimensionless).
% - Ma: Mach number (dimensionless).
% - alpha: Angle of attack (degrees).
%
% Outputs:
% - CL: Lift coefficient (dimensionless).
% - CD: Drag coefficient (dimensionless).
% - CM: Moment coefficient (dimensionless).
% - conf: Additional configuration or confidence metric returned from the 
%         neural network model (dimensionless).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [CL, CD, CM, conf] = NeuralFoil(airfoil, Re, Ma, alpha)

    % Call the external Python script 'NeuralAirfoil_2D.py' to calculate
    % the aerodynamic coefficients (CL, CD, CM) for the given airfoil
    % and operating conditions (Reynolds number, Mach number, angle of attack).
    % The Python function returns a vector containing these coefficients.
    
    aeroCoeffs = double(pyrunfile("NeuralAirfoil_2D.py", "aeroCoeff", ...
                                  airfoil=airfoil, Re=Re, Ma=Ma, alpha=alpha));
    
    % Extract the aerodynamic coefficients from the result returned by the Python script.
    CL = aeroCoeffs(1);  % Lift coefficient
    CD = aeroCoeffs(2);  % Drag coefficient
    CM = aeroCoeffs(3);  % Moment coefficient
    conf = aeroCoeffs(4); % Confidence or additional configuration data
    
end



    