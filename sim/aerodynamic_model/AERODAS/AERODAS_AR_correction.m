
function aerodas_data = AERODAS_AR_correction(aerodas_data, AR)

for i = 1:length(aerodas_data)

aerodas_data(i).Re = aerodas_data(i).Re;

aerodas_data(i).A0 = aerodas_data(i).A0;

aerodas_data(i).CL1max = aerodas_data(i).CL1max * (0.67 + 0.33 * exp(- (4.0/AR)^2));

aerodas_data(i).ACL1 = aerodas_data(i).ACL1 + 1.82 * aerodas_data(i).CL1max * AR^(-0.9);

aerodas_data(i).S1 = aerodas_data(i).S1 / (1 + 18.2 * aerodas_data(i).S1 * AR^(-0.9));

aerodas_data(i).CD0 = aerodas_data(i).CD0;

aerodas_data(i).ACD1 = aerodas_data(i).ACD1 + 18.2 * aerodas_data(i).CL1max * AR^(-0.9);

aerodas_data(i).CD1max = aerodas_data(i).CD1max + 0.28 * (aerodas_data(i).CL1max ^2) * AR^(-0.9);

end

end