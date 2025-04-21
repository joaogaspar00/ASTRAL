function [int, error_v, error_p] = boole_integration(x, y)
    % x: vector of x values (coordinates of the data points)
    % y: vector of y values (function values at corresponding x values)
    
    % Check if x and y have the same length
    if length(x) ~= length(y)
        error('Vectors x and y must have the same length.');
    end
    
    % Calculate the number of intervals n (which is length of x - 1)
    n = length(x) - 1;
    
    % Ensure that n is a multiple of 4
    if mod(n, 4) ~= 0
        error('The number of subintervals n must be a multiple of 4.');
    end
    
    % Calculate the step size h
    h = (x(end) - x(1)) / n;
    
    % Apply the Boole's rule formula for numerical integration
    int = (2 * h) / 45 * (7 *(y(1) + y(end)) + ...
                          32 * sum(y(1:2:n-1)) + ...
                          12 * sum(y(2:4:n-2)) + ...
                          14 * sum(y(4:4:n-4)));

    error_v = 0;
    error_p = 0;
    
end
