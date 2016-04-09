function idx = findMu(X,Mu_old)
    [r,c] = size(X);
    K = size(Mu_old,1);
    d = zeros(K,1);
    idx = zeros(r,1);
    for i = 1:r
        for j =1:K
            d(j) = norm(X(i,:)-Mu_old(j,:));
        end
        [m,idx(i)] = min(d);
    end
end