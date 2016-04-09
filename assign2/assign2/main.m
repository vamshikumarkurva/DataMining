
clc;
close all;
data = load('C:\Users\pc\Documents\MATLAB\assign2\assign2\Data11.csv');
[r,c] = size(data);
data3 = 0;

% 70%--->training, 30%---->validation
val = (70*r)/100;
trainX = data(1:val,1:c-1);
trainY = data(1:val,c);
valX = data(val+1:r,1:c-1);
valY = data(val+1:r,c);


fprintf('Normalizing Features ...\n');
% Z score normalization of training data
[trainX,mu,sigma] = normalize(trainX);
%[trainY,mu1,sigma1] = normalize(trainY);

% Z score normalization of validation data
for i=1:c-1
  valX(:,i) = (valX(:,i)-mu(i))./sigma(i); 
end
  %valY(:,1) = (valY(:,1)-mu1(1))./sigma1(1);


% appending intercept term
trainX = [ones(val,1) trainX];
valX = [ones(r-val,1) valX];

% set the hyperparameters
alpha = 0.01;
num_iter = 1000;
lambda = 1;
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

if data3==1,
    % plotting the data for data3
    figure(2);
    plot(data(:,1),data(:,2),'b*');
    xlabel('----->x');
    ylabel('----->y');
    title('Given data');
    hold on;
    plot(data(1:val,1),trainX*theta,'-');
    legend('Training data', 'Linear regression')
    hold off;

    %plotting cost function versus theta for data3
    theta0 = linspace(1, 20, 100);
    theta1 = linspace(-10, 10, 100);
    J_vals = zeros(length(theta0), length(theta1));

    for i = 1:length(theta0)
        for j = 1:length(theta1)
            t = [theta0(i); theta1(j)];    
            J_vals(i,j) = computecost(valX, valY, t);
        end
    end


    %J_vals = J_vals'; % since surf command expects col, row format 
    % Surface plot
    figure(3);
    surf(theta1, theta0, J_vals);
    xlabel('\theta_1'); ylabel('\theta_0');
    title('Cost function');
end
 
if data3 == 0
    figure;
    plot3(data(:,1),data(:,2),data(:,3),'r*');
    xlabel('--->x1');
    ylabel('--->x2');
    zlabel('--->y');
    title('Given data');
    hold on;
    
    x1 = (trainX(:,2))';
    x2 = (trainX(:,3))';
    J_vals = zeros(length(x1), length(x2));

    for i = 1:length(x1)
        for j = 1:length(x2)
            t = [1; x1(i); x2(j)];    
            J_vals(i,j) = theta'*t;
        end
    end

    J_vals=J_vals';
    surf(data(1:val,1),data(1:val,2),J_vals);
    legend('Training data', 'Linear regression')
    hold off;    
end
    
