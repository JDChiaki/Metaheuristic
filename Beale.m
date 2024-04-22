function f = Beale(x)
    % Extract x1 and x2 from input vector x
    x1 = x(1);
    x2 = x(2);
    
    % Compute the Beale function value
    term1 = (1.5 - x1 + x1*x2)^2;
    term2 = (2.25 - x1 + x1*x2^2)^2;
    term3 = (2.625 - x1 + x1*x2^3)^2;
    
    f = term1 + term2 + term3;
end
