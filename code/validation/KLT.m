function V = KLT(S)
    cov = S*S';
    [V, ~] = eig(cov);
end