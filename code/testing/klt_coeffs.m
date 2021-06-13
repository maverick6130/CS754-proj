function coeffs = klt_coeffs(H,x,n)
    c = H'*x;
    [~,I] = maxk(abs(c),n);
    coeffs = zeros(64,1);
    coeffs(I) = c(I);
end