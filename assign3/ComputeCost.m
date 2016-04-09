function J = computecost(X, theta, y, lambda)

m = length(y);
f = 1+exp(-X*theta);
predict = 1./f;
err = y.*log(predict)+(1-y).*log(1-predict);
J = -sum(err)/m + (lambda/(2*m))*(theta)'*theta-(lambda/(2*m))*theta(1)*theta(1);

end
