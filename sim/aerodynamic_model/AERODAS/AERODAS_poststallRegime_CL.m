function CL2 = poststallRegime_CL(alpha, aerodas_data)

CL2 = 0;

if alpha >= aerodas_data.ACL1 && alpha <= 92
    CL2 = -0.032 * (alpha-92) - aerodas_data.RCL2 * ((92-alpha)/(51))^aerodas_data.N2;
elseif alpha > 92
    CL2 = -0.032 * (alpha-92) + aerodas_data.RCL2 * ((alpha-92)/(51))^aerodas_data.N2;
end

end
