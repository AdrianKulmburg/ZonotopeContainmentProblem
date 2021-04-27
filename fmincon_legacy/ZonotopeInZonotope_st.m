function isIn = ZonotopeInZonotope_st(c1, G1, c2, G2)
    % Sadraddini, Tedrake Implementation
    Z1  = zonotope(c1, G1);
    Z2 = zonotope(c2, G2);
    isIn = inLinearProgram(Z1, Z2);
end