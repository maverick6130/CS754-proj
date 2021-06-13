clear;
close all;
clc;

lambda = [2e-4 4e-4 6e-4 8e-4 1e-3 2e-3 4e-3 6e-3 8e-3 1e-2];

% No need to run this a second time
%for i = 1:10
%    dict_train(5, lambda(i), strcat('dictionaries/validn-',num2str(i),'.mat'));
%end

dict = zeros(10,8,64,64);
for i = 1:10
    dict(i,:,:,:) = load(strcat('dictionaries/validn-',num2str(i),'.mat')).G;
end

range = 5:10:45;

for idx=31:33
    img = im2double(imread(strcat('../data/',num2str(idx),'.tiff')));
    szx = size(img,1)-7;
    szy = size(img,2)-7;

    recpsnr = zeros(10,5);

    c1M = zeros(10,(szx+7)/8, (szy+7)/8, 64);
    kM  = zeros(10,(szx+7)/8, (szy+7)/8);

    for d = 1:10
        for i = 1:8:szx
            for j = 1:8:szy
                patch = img(i+(0:7),j+(0:7));
                x = reshape(patch, [64 1]);
                G = reshape(dict(d,:,:,:), [8 64 64]);
                [c1M(d,(i+7)/8, (j+7)/8, :), kM(d,(i+7)/8, (j+7)/8)] = find_coeffs(G,x,lambda(d), 64);
            end
        end
    end

    for n=range
        rec = zeros(10,size(img,1), size(img,2));

        for d = 1:10
            for i = 1:8:szx
                for j = 1:8:szy
                    c1t = reshape(c1M(d,(i+7)/8, (j+7)/8, :), [64,1]);
                    [~,I] = maxk(abs(c1t),n);
                    c1 = zeros(64,1);
                    c1(I) = c1t(I);

                    k = kM(d,(i+7)/8, (j+7)/8);
                    
                    G = reshape(dict(d,:,:,:), [8 64 64]);
                    Gk = reshape(G(k,:,:), [64 64]);
                    rec(d,i+(0:7),j+(0:7)) = reshape( Gk*c1, [8 8]);
                end
            end
            recpsnr(d,(n+5)/10) = psnr( reshape(rec(d,:,:), [size(img,1), size(img,2)]), img );
        end
    end
    figure();
    hold on;
    for d = 1:10
        plot( range, reshape(recpsnr(d,:), [1 5]) );
    end
    xlim([5 60]);
    legend("v1","v2","v3","v4","v5","v6","v7","v8","v9","v10");
end