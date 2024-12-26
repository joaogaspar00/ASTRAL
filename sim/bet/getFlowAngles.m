function [alpha, phi, element_state] = getFlowAngles(U_T, U_P, theta)


U_e = [U_T; 0; U_P];

ex_e = [1; 0; 0];

if U_e(3)>=0
    phi = acosd(dot(ex_e, U_e )/(norm(U_e)*norm(ex_e)));
else
    phi = -acosd(dot(ex_e, U_e )/(norm(U_e)*norm(ex_e)));
end

alpha = phi - theta;

element_state = 0;

end
