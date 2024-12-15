function F_prandtl = prandtl_function (phi_root, phi_tip, ROTOR, BLADE)

phi_root = abs(phi_root * pi / 180);
phi_tip = abs(phi_tip * pi /180);

r = BLADE.pos_sec(:,2) ./BLADE.Span;

f_tip = ROTOR.Nb/2 .* ((1-r)./(r*phi_tip));
f_root = ROTOR.Nb/2 .* r./((1-r)*phi_root) ;           

F_root = 2/pi * acos(exp(-f_root));
F_tip = 2/pi * acos(exp(-f_tip));

F_prandtl = F_tip.*F_root;

end



