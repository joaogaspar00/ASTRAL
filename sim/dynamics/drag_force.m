function drag_force = drag_force(VEHICLE, ATMOSPHERE)
    
    Cd = 0.35;
    
    % A área de referência do cilindro pode ser ajustada
    A = 1; % Área de seção transversal do cilindro (m^2), ajuste conforme necessário
   
    % Força de arrasto na direção z (direção da queda)
    drag_force = 1/2 * ATMOSPHERE.density * A * (VEHICLE.velocity).^2 * Cd;

end