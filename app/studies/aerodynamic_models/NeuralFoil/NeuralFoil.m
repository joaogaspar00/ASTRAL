

function [CL, CD, conf] = NeuralFoil(airfoil, Re, Ma, alpha)

aeroCoeffs = double(pyrunfile("NeuralAirfoil_2D.py", "aeroCoeff", airfoil=airfoil, Re=Re, Ma=Ma, alpha=alpha));
CL = aeroCoeffs(1);
CD = aeroCoeffs(2);
conf = aeroCoeffs(3);
end


