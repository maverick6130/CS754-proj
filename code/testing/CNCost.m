function cost = CNCost(G, X, lambda)
    C = G' * X;
    C(abs(C) < sqrt(lambda)) = 0;
    cost = (norm(X - G * C, 'fro'))^2 + lambda * sum(sum(abs(C)>0));
end