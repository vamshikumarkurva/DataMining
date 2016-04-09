function Mu_new = ComputeMu(X,idx,K)
    [r,c] = size(X);
    Mu_new = zeros(K, c);
    freq = zeros(K,1);
    means = zeros(K,c);
    for i=1:r
        for j=1:K
            if idx(i)==j
                freq(j) = freq(j)+1;
                means(j,:) = means(j,:)+X(i,:);
                break;
            end
        end
    end
    for i=1:K
        Mu_new(i,:) = means(i,:)/freq(i);
    end
end