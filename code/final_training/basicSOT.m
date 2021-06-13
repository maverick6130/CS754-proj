function G = basicSOT(H, X, lambda, epsilon)
    HCost = CNCost(H,X, lambda);
    while true
        % optimize coefficients to reduce cost
        C = H' * X;
        C(abs(C) < sqrt(lambda)) = 0;
        % optimize tranform to reduce cost 
        Y = C * X';
        [U,~,V] = svd(Y);
        G = V * U';
        GCost = CNCost(G,X,lambda);
        if abs(GCost - HCost) < epsilon
            break;
        end
        H = G;
        HCost = GCost;
    end 
end