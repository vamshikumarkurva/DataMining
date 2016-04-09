clc;
close all;
data = load('C:\Users\pc\Documents\MATLAB\assign2\assign2\Data33.csv');
[r,c] = size(data);
data3 = 1;
folds = 4; 
val = floor(r/folds);

% set the hyperparameters
alpha = 0.01;
num_iter = 1000;
lambda = 0;

J_val_fin = zeros(num_iter,1);
J_train_fin = zeros(num_iter,1);
for k=1:1:folds
    starting = val*(k-1)+1;
    ending = val*(k);
    valX = data(starting:ending, 1:c-1);
    valY = data(starting:ending, c);
    if starting ==1
        trainX = data(ending+1:r,1:c-1);
        trainY = data(ending+1:r,c);
    elseif ending == r
        trainX = data(1:starting-1,1:c-1);
        trainY = data(1:starting-1,c);
    else 
            x = data(1:starting-1,1:c-1);
            y = data(ending+1:r,1:c-1);
            trainX = [x;y];
            
            x = data(1:starting-1,c);
            y = data(ending+1:r,c);
            trainY = [x;y];
    end
    

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
    trainX = [ones(val*(folds-1),1) trainX];
    valX = [ones(val,1) valX];

    theta = zeros(size(trainX,2),1);

    fprintf('Running gradient descent ...\n');
    % run gradient descent
    [theta, J_val,J_train] = gradient(trainX, trainY, valX, valY, theta, alpha,lambda, num_iter); 
    J_val_fin = J_val_fin + J_val; 
    J_train_fin = J_train_fin + J_train;
end

    J_val_fin = J_val_fin./folds;
    J_train_fin = J_train_fin./folds;
    
    % plot the cost function vs iterations graph
    figure(1);
    plot(1:numel(J_val_fin), J_val_fin, '-b', 'LineWidth', 2);
    xlabel('Number of iterations');
    ylabel('Cost J');
    hold on;
    plot(1:numel(J_train_fin), J_train_fin, '-r', 'LineWidth', 1);
    legend('Validation error', 'Training error');
    title('convergence plot');

    % Display gradient descent's result
    fprintf('Theta computed from gradient descent: \n');
    fprintf(' %f \n', theta);
    fprintf('\n');
    data1 = [trainX;valX];
    
if data3==1,
    % plotting the data for data3
    figure(2);
    plot(data(:,1),data(:,2),'b*');
    xlabel('----->x');
    ylabel('----->y');
    title('Given data');
    hold on;
    plot(data(:,1),data1*theta,'-');
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
    x1 = (data1(:,2))';
    x2 = (data1(:,3))';
    J_vals = zeros(length(x1), length(x2));

    for i = 1:length(x1)
        for j = 1:length(x2)
            t = [1; x1(i); x2(j)];    
            J_vals(i,j) = theta'*t;
        end
    end

    J_vals=J_vals';
    surf(data1(:,2),data1(:,3),J_vals);
    legend('Training data', 'Linear regression')
    hold off;    
end
    
% Mean square error
x = data(:,1:c-1);
y = data(:,c);
for i=1:c-1
    x(i) = x(i)- mu(i)/sigma(i);
end
x = [ones(r,1) x];
err = (x*theta-y)'*(x*theta-y);
err = sqrt(err/r);
disp('mean square error');
disp(err);