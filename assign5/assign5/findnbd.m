function nbd = findnbd(P,X,eps)
    r = size(X,1);
    dis = zeros(r,1);
    for i=1:r
        dis(i) = norm(P-X(i,:));
    end
    dis = dis < eps;
    nbd = find(dis==1);
end