clear;
close all;
clc;

lambda = 2e-3;
dict = load('dict.mat');

G = dict.G;
H = dict.H0;

for idx=21:30
    img = im2double(imread(strcat('../data/',num2str(idx),'.tiff')));
    szx = size(img,1)-7;
    szy = size(img,2)-7;

    sotpsnr = zeros(1,20);
    kltpsnr = zeros(1,20);
    dctpsnr = zeros(1,20);
    range = 5:2:43;

    c1M = zeros((szx+7)/8, (szy+7)/8, 64);
    kM  = zeros((szx+7)/8, (szy+7)/8);
    c2M = zeros((szx+7)/8, (szy+7)/8, 64);
    c3M = zeros((szx+7)/8, (szy+7)/8, 64);

    for i = 1:8:szx
        for j = 1:8:szy
            patch = img(i+(0:7),j+(0:7));
            x = reshape(patch, [64 1]);
            [c1M((i+7)/8, (j+7)/8, :), kM((i+7)/8, (j+7)/8)] = find_coeffs(G,x,lambda, 64);
            c2M((i+7)/8, (j+7)/8, :) = dct_coeffs(x, 64);
            c3M((i+7)/8, (j+7)/8, :) = klt_coeffs(H, x, 64);
        end
    end

    for n=range
        img1 = zeros(size(img));
        img2 = zeros(size(img));
        img3 = zeros(size(img));

        for i = 1:8:szx
            for j = 1:8:szy
                c1t = reshape(c1M((i+7)/8, (j+7)/8, :), [64,1]);
                [~,I] = maxk(abs(c1t),n);
                c1 = zeros(64,1);
                c1(I) = c1t(I);

                c2t = reshape(c2M((i+7)/8, (j+7)/8, :), [64,1]);
                [~,I] = maxk(abs(c2t),n);
                c2 = zeros(64,1);
                c2(I) = c2t(I);

                c3t = reshape(c3M((i+7)/8, (j+7)/8, :), [64,1]);
                [~,I] = maxk(abs(c3t),n);
                c3 = zeros(64,1);
                c3(I) = c3t(I);

                k = kM((i+7)/8, (j+7)/8);

                Gk = reshape(G(k,:,:), [64 64]);
                img1(i+(0:7),j+(0:7)) = reshape( Gk*c1, [8 8]);
                img2(i+(0:7),j+(0:7)) = dct2(reshape(c2, [8 8]));
                img3(i+(0:7),j+(0:7)) = reshape( H*c3, [8 8]);
            end
        end
        
        sotpsnr((n-3)/2) = psnr(img1, img);
        dctpsnr((n-3)/2) = psnr(img2, img);
        kltpsnr((n-3)/2) = psnr(img3, img);
    end
    f = figure();
    subplot(1,2,1);
    imshow(img);
    subplot(1,2,2);
    plot(range,sotpsnr,'r',range,kltpsnr,'y',range,dctpsnr,'g');
    xlabel("number of values retained per patch");
    ylabel("PSNR");
    legend("SOT","KLT","DCT");
    saveas(f,strcat('results/',num2str(idx),'.png'),'png');
    close;
    fprintf("Stored file %d\n",idx);
end