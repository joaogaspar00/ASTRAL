function [int, error_est, error_percent] = rectangle_integration(x, y)
    % Check if x and y have the same length
    if length(x) ~= length(y)
        error('Vectors x and y must have the same length');
    end
    
    % Compute integral using the left rectangle rule
    int = 0;
    for i = 1:length(x)-1
        int = int + y(i) * (x(i+1) - x(i));
    end
    
    if int == 0

        error_est = 0;
        error_percent = 0;

    else
    
        % Estimate error using numerical second derivative
        h = x(2) - x(1); % Assume uniform spacing
        d2y = diff(y,2) / h^2; % Approximate second derivative
        max_d2y = max(abs(d2y));
        error_est = -((x(end) - x(1))^3 / (24 * (length(x)-1)^2)) * max_d2y;
        
        % Compute error in percentage
        error_percent = abs(error_est / int) * 100;
        
    end
end