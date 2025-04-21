function [value, isterminal, direction] = height_event(~, y)
    % Função de evento para parar a simulação quando a altura for 0
    value = y(3);        % Queremos que a simulação pare quando a altura for 0
    isterminal = 1;      % Pare a integração quando o evento ocorrer
    direction = -1;      % O evento deve ser detectado apenas quando a altura estiver caindo
end