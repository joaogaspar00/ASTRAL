function CD2 = poststallRegime_CD(alpha, aerodas_data)


if alpha > (2*aerodas_data.A0 - aerodas_data.ACL1) && alpha < aerodas_data.ACD1
    CD2=0;
elseif alpha >= aerodas_data.ACD1
    CD2 = aerodas_data.CD1max + (aerodas_data.CD2max - aerodas_data.CD1max) * sind((alpha-aerodas_data.ACD1)/(90-aerodas_data.ACD1)*90);   
end


end
