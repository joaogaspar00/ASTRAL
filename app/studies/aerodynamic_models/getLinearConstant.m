function S1 = getLinearConstant(alpha, Cl, k, perc)



alpha = alpha(1:round(k*perc));
Cl = Cl(1:round(k*perc));

coeff = polyfit(alpha, Cl, 1);

S1 = coeff(1);

end