function R = rotationMatrix_generator(alfa, theta, phi)
    

    if isempty(phi) || isempty(theta) ||isempty(alfa)
        error("Error: Euler angle not defined (rotationMatrix_generator)")
    end

    eul = [alfa, theta, phi];
    R = eul2rotm(eul);

end