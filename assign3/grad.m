function [theta, J_cost] = grad(X, y, theta, alpha, lambda, num_iter)

m = length(y);
scale = -(alpha*lambda)/m;
J_cost = zeros(num_iter,1);
for i=1:num_iter
    f = 1./(1+exp(-X*theta));
    predict = X'*(f-y);
    temp = (1-scale)*theta - (alpha/m)*predict;
    temp2 = temp(1) + scale*theta(1);
    theta = temp;
    theta(1) = temp2;
    J_cost(i) = ComputeCost(X,theta,y,lambda);
end

end
