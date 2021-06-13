function coeffs = dct_coeffs(x, n)
    img = reshape(x, [8 8]);
    c = reshape(idct2(img), [64 1]);
    coeffs = zeros(64,1);
    [~,I] = maxk( abs(c), n);
    coeffs(I) = c(I);
end