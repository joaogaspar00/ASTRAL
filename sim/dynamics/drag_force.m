function drag_force = drag_force(VEHICLE, ATMOSPHERE)
    
    Cd = 0.2;
    
    % A área de referência do cilindro pode ser ajustada
    A = 1; % Área de seção transversal do cilindro (m^2), ajuste conforme necessário
   
    % Força de arrasto na direção z (direção da queda)


    drag_force = 1/2 * ATMOSPHERE.density * A * (VEHICLE.velocity).^2 * Cd;

    if VEHICLE.velocity(1) > 0
        drag_force(1) = -drag_force(1);
    end

    if VEHICLE.velocity(2) > 0
        drag_force(2) = -drag_force(2);
    end

    if VEHICLE.velocity(3) > 0
        drag_force(3) = -drag_force(3);
    end
    
end