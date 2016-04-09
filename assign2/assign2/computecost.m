function J = computecost(X, y, theta)

m = length(y); % number of training examples
J = 0;
msev=X*theta-y;
sum1 = sum(msev.^2);
J = sum1/(2*m);

end
