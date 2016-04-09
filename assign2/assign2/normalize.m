function [X_norm, mu, sigma] = normalize(X)

X_norm = X;
c = size(X,2);
mu = zeros(1,c);
sigma = zeros(1,c);

 for i=1:c
     
     mu(i) = mean(X(:,i));
     sigma(i) = std(X(:,i));
     X_norm(:,i) = (X(:,i)-mu(i))./sigma(i);
     
 end
 
end