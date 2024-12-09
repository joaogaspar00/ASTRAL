function CD1 = prestallRegime_CD(alpha, aerodas_data)

if alpha >= 2*aerodas_data.A0-aerodas_data.ACD1 && alpha <= aerodas_data.ACD1
   CD1 = aerodas_data.CD0 + (aerodas_data.CD1max - aerodas_data.CD0)*((alpha-aerodas_data.A0)/(aerodas_data.ACD1  -aerodas_data.A0))^aerodas_data.M;

elseif alpha < (2*aerodas_data.A0-aerodas_data.ACD1) || alpha > aerodas_data.ACD1
    CD1 = 0;
end

end
