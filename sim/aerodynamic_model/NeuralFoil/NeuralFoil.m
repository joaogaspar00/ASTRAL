function [CL, CD, CM, conf] = NeuralFoil(airfoil, Re, Ma, alpha)

aeroCoeffs = double(pyrunfile("NeuralAirfoil_2D.py", "aeroCoeff", airfoil=airfoil, Re=Re, Ma=Ma, alpha=alpha));
CL = aeroCoeffs(1);
CD = aeroCoeffs(2);
CM = aeroCoeffs(3);
conf = aeroCoeffs(4);
end


    