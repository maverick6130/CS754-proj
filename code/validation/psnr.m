function dB = psnr(img1, img2)
    diff = img1 - img2;
    dim = size(img1,1)*size(img1,2);
    mse = norm(diff, 'fro')/dim;
    dB = 10*log(1/mse);
end