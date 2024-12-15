function [alpha, phi, element_state] = getFlowAngles(U_T, U_P, theta)

element_state = -1;


if U_P == 0 && U_T == 0
    element_state = 1;
    phi = 0;
    alpha = 0;
elseif U_P == 0 && U_T ~= 0
    if U_T > 0
        element_state = 2;
        phi = 0;
        alpha = theta;
    elseif U_T < 0
        element_state = 3;
        phi = 180;
        alpha = theta - phi;
    end
elseif U_T == 0 && U_P ~= 0
    if U_P > 0
        element_state = 4;
        phi = 90;
        alpha = theta - phi; 
    elseif U_P < 0
        element_state = 5;
        phi = -90;
         alpha = theta - phi;
    end
else

    phi_ = atand (abs(U_P/U_T));
 

    %1º QUADRANTE
    if U_T < 0 && U_P > 0
        element_state = 6;
        phi = 180 - phi_;
    %2º QUADRANTE
    elseif U_T > 0 && U_P > 0
        element_state = 7;
        phi = 90 - phi_;
    %3º QUADRANTE
    elseif U_T > 0 && U_P < 0
        element_state = 8;
        phi = -phi_;
    %4º QUADRANTE
    elseif U_T < 0 && U_P < 0
        element_state = 9;
        phi = -180 + phi_;
    end

    alpha = theta - phi ;
end

phi = mod(phi + 180, 360) - 180;
alpha = mod(alpha + 180, 360) - 180;

end