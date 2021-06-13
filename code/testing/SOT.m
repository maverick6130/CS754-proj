function G = SOT(K, H, S, label, lambda, delta, l_max, eps1, eps2)
    
    sz = size(S,2);
    HCost = 0;
    for k=1:K
        HCost = HCost + CNCost( reshape(H(k,:,:), [64,64]), S(:, label==k), lambda);
    end
    
    count = 1;
    while true
        % Transform update
        G = H;
        for k=1:K
            l_term = l_max;
            while(l_term >= lambda)
                G(k,:,:) = basicSOT(reshape(G(k,:,:), [64,64]), S(:, label==k), l_term, eps1);
                l_term = l_term - delta;
            end
        end
        fprintf("Completed %d iteration of transform updates\n", count);
        % Reclassify
        for x=1:sz
            costs = zeros(K,1);
            for k=1:K
                costs(k) = CNCost( reshape(G(k,:,:), [64,64]), S(:,x), lambda);
            end
            [~, label(x)] = min(costs);
        end
        fprintf("Completed %d iteration of reclassification\n", count);
        count = count + 1;
        
        GCost = 0;
        for k=1:K
            GCost = GCost + CNCost( reshape(G(k,:,:), [64,64]), S(:, label==k), lambda);
        end
        fprintf("Initial cost was %f, cost now is %f\n", HCost, GCost);
        if HCost - GCost < eps2
            break;
        end
        
        H = G;
        HCost = GCost;
    end
end