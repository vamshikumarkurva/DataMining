clc;
close all;
data = load('C:\Users\pc\Documents\MATLAB\assign2\assign2\polynomial_data2.csv');
[r,c] = size(data);
degree = 9; 

trainX = data(:,1:c-1);
trainY = data(:,c);

TempTrainX = trainX;
for i=2:degree
    TempTrainX = [TempTrainX trainX.^i];
end
trainX = TempTrainX

fprintf('Normalizing Features ...\n');
% Z score normalization of training data
[trainX,mu,sigma] = normalize(trainX);
  %[trainY,mu1,sigma1] = normalize(trainY);

% appending intercept term
trainX = [ones(r,1) trainX];

% set the hyperparameters
alpha = 0.01;
num_iter = 5000;
lambda = 0;

theta = zeros(degree+1,1);
fprintf('Running gradient descent ...\n');
% run gradient descent
[theta, J_history,J_history_train] = gradient(trainX, trainY, trainX, trainY, theta, alpha, lambda, num_iter); 
% plot the cost function vs iterations graph
figure(1);
plot(1:numel(J_history), J_history, '-b');
xlabel('Number of iterations');
ylabel('Cost J');
title('convergence plot');
hold off

% Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta);
fprintf('\n');

% plotting the given data and hypothesis
        
figure(2);
plot(data(:,1),data(:,2),'b*');
xlabel('----->x');
ylabel('----->y');
title('Given data');
hold on;
plot(data(:,1),trainX*theta,'r+');
legend('Training data', 'Linear regression')
hold off;
        
trainX*theta-trainY
err = (trainX*theta-y)'*(trainX*theta-y);
trainX*theta-y;
err = sqrt(err/r);
disp('mean square error');
disp(err);
                