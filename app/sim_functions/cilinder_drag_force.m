function F_drag_cilinder = cilinderDrag_force(velocity, ATMOSPHERE)
    
    Cd_cilinder = 1.15;
    
    % A área de referência do cilindro pode ser ajustada
    A = 1; % Área de seção transversal do cilindro (m^2), ajuste conforme necessário
    
    % Força de arrasto
    Fz_cilinder = 0.5 * ATMOSPHERE.density * norm(velocity)^2 * Cd_cilinder * A;
    
    % Força de arrasto na direção z (direção da queda)
    F_drag_cilinder = [0; 0; Fz_cilinder];
end