clc;
close all;
data = load('C:\Users\pc\Documents\MATLAB\assign2\assign2\housingdata.csv');
[r,c] = size(data);

% 70%--->training, 30%---->validation
val = floor((80*r)/100);
trainX = data(1:val,1:c-1);
trainY = data(1:val,c);
valX = data(val+1:r,1:c-1);
valY = data(val+1:r,c);


fprintf('Normalizing Features ...\n');
% Z score normalization of training data
[trainX,maxim] = normalize2(trainX);
%[trainY,mu1,sigma1] = normalize(trainY);

% Z score normalization of validation data
for i=1:c-1
  valX(:,i) = (valX(:,i))/maxim(i); 
end
  %valY(:,1) = (valY(:,1)-mu1(1))./sigma1(1);


% appending intercept term
trainX = [ones(val,1) trainX];
valX = [ones(r-val,1) valX];

% set the hyperparameters
alpha = 0.01;
num_iter = 3000;
lambda = 0;
theta = zeros(size(trainX,2),1);

fprintf('Running gradient descent ...\n');
% run gradient descent
[theta, J_history,J_history_train] = gradient(trainX, trainY, valX, valY, theta, alpha,lambda, num_iter); 
                                          
% plot the cost function vs iterations graph
figure(1);
plot(1:numel(J_history), J_history, '-b', 'LineWidth', 1);
xlabel('Number of iterations');
ylabel('Cost J');
hold on;
plot(1:numel(J_history_train), J_history_train, '-r', 'LineWidth', 1);
legend('Validation error', 'Training error');
title('convergence plot');

% Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta);
fprintf('\n');

err = zeros(r,1);
trainX = data(1:r,1:c-1);
trainY = data(1:r,c);

for i=1:c-1
    trainX(:,i) = trainX(:,i)/maxim(i);
end
%[trainX, maxim] = normalize2(trainX);

trainX = [ones(r,1) trainX];
err = trainX*theta;

% final error plot
figure(2);
plot(1:numel(err), err, '-b');
xlabel('--->example number');
ylabel('--->output');
hold on;
plot(1:numel(trainY), trainY, '-r');
legend('prediction', 'original');
hold off;
figure(3);
err = trainY-trainX*theta;
plot(1:numel(err), err, '-b');
xlabel('--->example number');
ylabel('--->error');
title('absolute error plot');

mse = (trainY-trainX*theta)'*(trainY-trainX*theta);
mse = (mse)/r;
mse = sqrt(mse);
disp('mean square error');
disp(mse);
