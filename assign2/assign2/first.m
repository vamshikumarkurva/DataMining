clc;
close all;
data = load('C:\Users\pc\Documents\MATLAB\assign2\assign2\Data11.csv');
[r,c] = size(data);

% 70%--->training, 30%---->validation
val = (70*r)/100;
trainX = data(1:val,1:c-1);
trainY = data(1:val,c);
valX = data(val+1:r,1:c-1);
valY = data(val+1:r,c);

fprintf('Normalizing Features ...\n');
% Z score normalization of training data
[trainX,mu,sigma] = normalize(trainX);

% Z score normalization of validation data
for i=1:c-1
   valX(:,i) = (valX(:,i)-mu(i))./sigma(i); 
end

% appending intercept term
trainX = [ones(val,1) trainX];
valX = [ones(r-val,1) valX];

% set the hyperparameters
alpha = 0.01;
num_iter = 500;
lambda = 0.7;
theta = zeros(size(trainX,2),1);

fprintf('Running gradient descent ...\n');
% run gradient descent
[theta, J_history] = gradient(trainX, trainY, valX, valY, theta, alpha,lambda, num_iters); 
                                          
% plot the graph
figure;
seq = 1:1:num_iter;
plot(1:numel(J_history), J_history, '-b', 'LineWidth', 1);
xlabel('Number of iterations');
ylabel('Cost J');
title('convergence plot');

% Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta);
fprintf('\n');
