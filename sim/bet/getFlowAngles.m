function [alpha, phi, element_state] = getFlowAngles(U_T, U_P, theta)

if U_T == 0 && abs(U_P) > 0
                      
    phi = -90;

    if theta <= 0

        alpha = abs(phi) - abs(theta);

        element_state = 1;

    elseif theta > 0

        element_state = 5;

        alpha = abs(phi) + abs(theta);   

    else
        error("Check angles - 1")
    end

else

    phi = - atand(abs(U_P) / abs(U_T));

    % pitch angle negative
    if theta < 0

        if abs(phi) > abs(theta)
    
            alpha = abs(phi) - abs(theta);
    
            element_state = 2;
    
        elseif abs(phi) == abs(theta)
    
            alpha = 0;
    
            element_state = 3;
    
        elseif abs(phi) < abs(theta)
    
            alpha =  - (abs(theta) - abs(phi));
    
            element_state = 4;
    
        else
            error("Check angles - 2")
        end

    % pitch angle positive
    elseif theta >= 0
        
        alpha = abs(theta) + abs(phi);

        element_state = 6;

    else
        error("Check angles - 3")
    end
end

end