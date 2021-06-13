% Given trained dictiorary collection C and a vectorized patch x, find the
% best representation acc to CNCost(G,lambda) and keep the largest n values
% from it

function [coeffs,label] = find_coeffs(G, x, lambda, n)
    K = size(G,1);
    costs = zeros(1,K);
    for k=1:K
        costs(k) = CNCost( reshape(G(k,:,:), [64,64]), x, lambda);
    end
    [~, label] = min(costs);
    c = reshape( G(label,:,:), [64 64] )'*x;
    [~,I] = maxk(abs(c),n);
    coeffs = zeros(64,1);
    coeffs(I) = c(I);
end