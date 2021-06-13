function dict_train(n, l, filename)
    path = '../data/';
    ext = '.tiff';

    sz = 0;
    for k = 1:n
        name = strcat(path,num2str(k),ext);
        img = im2double(imread(name));
        sz = sz + size(img,1)*size(img,2)/64;
    end

    imset = zeros(sz,8,8);

    idx = 1;
    for k = 1:n
        name = strcat(path,num2str(k),ext);
        img = im2double(imread(name));
        szx = size(img,1) - 7;
        szy = size(img,2) - 7;
        for i = 1:8:szx
            for j = 1:8:szy
                imset(idx,:,:) = img(i+(0:7),j+(0:7));
                idx = idx + 1;
            end
        end
    end

    K = 8;
    lambda = l;
    dl = l;
    lmax = 10*l;
    
    H = zeros(K,64,64);
    label = zeros(1,sz);
    S = zeros(64,sz);
    for i= 1:sz
        img = reshape(imset(i,:,:), [8,8]);
        dx = diff(img,1,1);
        dy = diff(img,1,2);
        theta = atan(norm(dx,'fro')/norm(dy,'fro'));
        label(i) = floor(2*theta*K/pi);
        S(:,i) = reshape(img, [64 1]);
    end
    for k=1:K
        H(k,:,:) = KLT(S(:,label==k));
    end
    
    H0 = KLT(S);
    G = SOT(K, H, S, label, lambda, dl, lmax, 1e-4, 1.0);
    save(filename, 'G','H0');
end