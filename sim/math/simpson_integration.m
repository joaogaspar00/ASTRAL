function [int, error_est, error_percent] = simpson_integration(x, y)
    % Check if x and y have the same length and an odd number of points
    if length(x) ~= length(y)
        error('Vectors x and y must have the same length');
    end
    if mod(length(x)-1, 2) ~= 0
        error('Simpsons rule requires an even number of subintervals');
    end
    
    % Compute integral using Simpson's rule
    h = (x(end) - x(1)) / (length(x) - 1);
    int = y(1) + y(end);
    for i = 2:2:length(x)-1
        int = int + 4 * y(i);
    end
    for i = 3:2:length(x)-2
        int = int + 2 * y(i);
    end
    int = int * h / 3;    
    
    
    % Compute error
    if int == 0

        error_est = 0;
        error_percent = 0;

    else

        % Estimate error using numerical fourth derivative
        d4y = diff(y,4) / h^4; % Approximate fourth derivative
        max_d4y = max(abs(d4y));
        error_est = -((x(end) - x(1))^5 / (180 * (length(x)-1)^4)) * max_d4y;
        error_percent = abs(error_est / int) * 100;
        
    end

    
end