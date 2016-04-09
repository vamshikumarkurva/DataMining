function [theta, J_val, J_train] = gradient(X, y, valX, valY, theta, alpha, lambda, num_iters)

    m = length(y); % number of training examples
    J_val = zeros(num_iters, 1);
    J_train = zeros(num_iters, 1);
    scale = (alpha*lambda)/m;

    for iter = 1:num_iters

        predict = X'*(X*theta-y);
        temp = (1-scale)*theta - (alpha/m)*predict;
        temp2 = temp(1) + scale*theta(1);
        theta = temp;
        theta(1) = temp2;

        J_val(iter) = computecost(valX, valY, theta);
        J_train(iter) = computecost(X, y, theta);

    end

end
