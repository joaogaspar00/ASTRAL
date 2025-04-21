function DATA = AERODAS_model_coefficients(Re, alpha, CL, CD, CONF, stall_index, stall_angle, stall_cl, tc, AR)

% Armazena os resultados no struct DATA
DATA.Re = Re;  % Armazenando o número de Reynolds
DATA.alpha = alpha;
DATA.CL = CL;
DATA.CD = CD;
DATA.CONF = CONF; 
DATA.stall_index = stall_index;

DATA.A0 = getAlphaZeroCL(DATA.alpha, DATA.CL);     
DATA.ACL1 = stall_angle;
DATA.CL1max = stall_cl;
DATA.S1 = getLinearConstant(DATA.alpha, DATA.CL, stall_index, 0.75);
DATA.RCL1 = DATA.S1 * (DATA.ACL1 - DATA.A0)-DATA.CL1max;
DATA.N1 = 1 + DATA.CL1max / DATA.RCL1;

DATA.CD0 = DATA.CD(DATA.stall_index);
[DATA.CD1max, cd_stall_index] = max(DATA.CD(1:DATA.stall_index));
DATA.ACD1 = DATA.alpha(cd_stall_index);

DATA.M = 3;

DATA.F1 = 1.190 * (1 - (tc^2));
DATA.F2 = 0.65 + 0.35 * exp(-(9.0 / AR)^2.3);

DATA.G1 = 2.3 * exp(- (0.65 * 0.12) ^ 0.9);
DATA.G2 = 0.52 + 0.48 * exp(-((6.5 / AR)^(1.1)));

DATA.CL2max = DATA.F1 * DATA.F2;
DATA.RCL2 = 1.632 - DATA.CL2max;
DATA.N2 = 1 + DATA.CL2max / DATA.RCL2;
DATA.CD2max = DATA.G1 * DATA.G2;

if DATA.RCL1 > 0
    DATA.preStallMode = "AERODAS";
else
    DATA.preStallMode = "NeuralFoil";
end

DATA.preStallCurve_CL = fit(alpha', CL', 'smoothingspline');
DATA.preStallCurve_CD = fit(alpha', CD', 'smoothingspline');

end