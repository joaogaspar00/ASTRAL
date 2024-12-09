function A0 = getAlphaZeroCL(alpha, Cl)

    [~, i] = min(abs(Cl));

    A0 = alpha(i);

end