function CL1 = prestallRegime_CL(alpha, aerodas_data)

CL1 = 0;

if alpha >= aerodas_data.A0
    CL1 = aerodas_data.S1 * (alpha - aerodas_data.A0) - aerodas_data.RCL1 * ((alpha-aerodas_data.A0)/(aerodas_data.ACL1-aerodas_data.A0))^aerodas_data.N1;
else
    CL1 = aerodas_data.S1 * (alpha - aerodas_data.A0) + aerodas_data.RCL1 * ((aerodas_data.A0-alpha)/(aerodas_data.ACL1-aerodas_data.A0))^aerodas_data.N1;
end

end