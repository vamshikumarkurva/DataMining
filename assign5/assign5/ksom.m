X = csvread('cluster1.csv');
[r,c] = size(X);
m = 2;
n = 2;
T = 100;
alpha = 0.01;
sigma = 10;
nodes = zeros(m,n);
weights = randi(1,m*n,c);
weights1 = weights;
pos = zeros(m*n,2);
idx = zeros(r,1);

for i=1:m
    for j=1:n
        pos((j-1)*n+i,:) = [m n];
    end
end

dis = zeros(m*n,1);
for t=1:T
    sigmat = sigma*(1-(t-1)/T);
    alphat = alpha*(1-(t-1)/T);
    for i=1:r
        for a=1:m
            for b=1:n
                dis((b-1)*n+a) = norm(X(i,:)-weights((b-1)*n+a,:));  
            end
        end
        [MIN,id]= min(dis);
        idr = rem(id,n);
        idc = floor(id/n)+1;
        for a=1:m
            for b=1:n
                N = nbdfn([a b],[idr idc],sigmat);
                wk = weights((b-1)*n+a,:);
                weights((b-1)*n+a,:) = wk+alphat*N*(X(i,:)-wk);
            end
        end
        tol = 0;
        for a=1:m
           tol = tol+norm(weights1(a,:)-weights(a,:));
        end
        weights1 = weights;
        if tol < 1e-3
            break;
        end
    end
    
end

for i=1:r
    for a=1:m
        for b=1:n
            dis((b-1)*n+a) = norm(X(i,:)-weights((b-1)*n+a,:));  
        end
    end
    [MIN,id]= min(dis);  
    idx(i) = id;
end

figure;
hold on;
for i=1:r
    if idx(i)==1
        plot3(X(i,1),X(i,2),X(i,3),'*b');
    elseif idx(i)==2
        plot3(X(i,1),X(i,2),X(i,3),'*r');
    elseif idx(i)==3
        plot3(X(i,1),X(i,2),X(i,3),'*g');
    elseif idx(i)==4
        plot3(X(i,1),X(i,2),X(i,3),'*k');
    end
end
