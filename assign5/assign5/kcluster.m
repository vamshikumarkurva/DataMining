X = csvread('cluster1.csv');
[r,c] = size(X);
K = 4;
m = ceil(max(max(X))/2);
num_iter = 15;
max_iter = 50;
J_cost = zeros(num_iter,max_iter);
final = 1;
p1 = zeros(num_iter,1);
MIN = 1e10;

for iter = 1:num_iter
    Mu_old = randi(m,K,c);
    idx = findMu(X,Mu_old);
    Mu_new = ComputeMu(X,idx,K);

    dist = 0;
    for i=1:K
        dist = dist+norm(Mu_old(i,:)-Mu_new(i,:));
    end

    Mu_old = Mu_new;
    p = 0;

    while dist~=0
        idx = findMu(X,Mu_old);
        Mu_new = ComputeMu(X,idx,K);

        dist = 0;
        for i=1:K
            dist = dist+norm(Mu_old(i,:)-Mu_new(i,:));
        end
        Mu_old = Mu_new;

        sum1 = 0;
        for j=1:r
            sum1 = sum1 + norm(X(j,:)-Mu_new(idx(j),:));
        end
        p = p+1;
        J_cost(iter,p) = sum1;

        if p > max_iter
            break;
        end
    end
    
    p1(iter) = p;
    if J_cost(iter,p)<MIN
        final = iter;
        ID = idx;
        MIN = J_cost(iter,p);
    end
    
end

figure;
hold on;
for i=1:r
    if ID(i)==1
        plot3(X(i,1),X(i,2),X(i,3),'*b');
    elseif ID(i)==2
        plot3(X(i,1),X(i,2),X(i,3),'*r');
    elseif ID(i)==3
        plot3(X(i,1),X(i,2),X(i,3),'*g');
    else
        plot3(X(i,1),X(i,2),X(i,3),'*k');
    end
end
figure;
plot(1:p1(final),J_cost(final,1:p1(final))','-b');



