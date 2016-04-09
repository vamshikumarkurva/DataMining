function [X_norm, maxim] = normalize2(X)

X_norm = X;
c = size(X,2);
maxim = zeros(1,c);

 for i=1:c     
     maxim(i) = max(X(:,i))- min(X(:,i));
     X_norm(:,i) = X(:,i)/maxim(i);    
 end
 
end