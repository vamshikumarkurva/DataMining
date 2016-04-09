clc;
close all;
data = load('C:\Users\pc\Documents\MATLAB\assign2\assign2\polynomial_data2.csv');
[r,c] = size(data);
degree = 3; 
folds = 4; 
val = floor(r/folds);

theta_all = zeros(degree+1,folds);
% set the hyperparameters
alpha = 0.01;
num_iter = 2500;
lambda = 20;
J_val_fin = zeros(num_iter,1);
J_train_fin = zeros(num_iter,1);

Temp = data(:,1);
Temp2 = data(:,2);

for i=2:degree
    Temp = [Temp, data(:,1).^i];
end

data1 = [Temp Temp2];
[r,c]= size(data1);

lam_iter = lambda;
test_error = zeros(lam_iter,1);
    
for lam=0:lam_iter
    J_val_fin = zeros(num_iter,1);
    J_train_fin = zeros(num_iter,1);

for k=1:folds;
    starting = val*(k-1)+1;
    ending = val*(k);
    valX = data1(starting:ending, 1:c-1);
    valY = data1(starting:ending, c);
    if starting ==1
        trainX = data1(ending+1:r,1:c-1);
        trainY = data1(ending+1:r,c);
    elseif ending == r
        trainX = data1(1:starting-1,1:c-1);
        trainY = data1(1:starting-1,c);
    else 
        x = data1(1:starting-1,1:c-1);
        y = data1(ending+1:r,1:c-1);
        trainX = [x;y];
            
        x = data1(1:starting-1,c);
        y = data1(ending+1:r,c);
        trainY = [x;y];
    end
    
    
    fprintf('Normalizing Features ...\n');
    % Z score normalization of training data
    [trainX1,mu,sigma] = normalize(trainX);
      %[trainY,mu1,sigma1] = normalize(trainY);

    % Z score normalization of validation data
    valX1 = zeros(size(valX));
    for i=1:c-1
       valX1(:,i) = (valX(:,i)-mu(i))/sigma(i); 
    end
      % valY(:,i) = (valY(:,1)-mu1(1))./sigma1(1);
    
    % appending intercept term

    trainX1 = [ones(val*(folds-1),1) trainX1];
    valX1 = [ones(val,1) valX1];
    theta = zeros(degree+1,1);
    size(trainX1)
    size(valX1)
    size(theta)
    fprintf('Running gradient descent ...\n');
    % run gradient descent
    [theta, J_val,J_train] = gradient(trainX1, trainY, valX1, valY, theta, alpha,lam, num_iter); 
    % plot the cost function vs iterations graph
    J_val_fin = J_val_fin + J_val;
    J_train_fin = J_train_fin + J_train;
            
    % Display gradient descent's result
    fprintf('Theta computed from gradient descent: \n');
    fprintf(' %f \n', theta);
    fprintf('\n');
    theta_all(:,k) = theta; 

end
 
    % Mean square error
    %{
    x = data1(:,1:c-1);
    y = data1(:,c);
    for i=1:c-1
        x(i) = x(i)- mu(i)/sigma(i);
    end
    x = [ones(r,1) x];
    err = (x*theta-y)'*(x*theta-y);
    err = sqrt(err/r);
    test_error(lam+1) = err;
    %}

end

    
    J_val_fin = J_val_fin./folds;
    J_train_fin = J_train_fin./folds;

    figure(1);
    plot(1:numel(J_val_fin), J_val_fin, '-b');
    xlabel('Number of iterations');
    ylabel('Cost J');
    hold on;
        
    plot(1:numel(J_train_fin), J_train_fin, '-r');
    legend('Validation error', 'Training error');
    title('convergence plot');
    hold off
    
    temp = [trainX1; valX1];
    % plotting the given data and hypothesis
    figure(2);
    plot(data(:,1),data(:,2),'b*');
    xlabel('----->x');
    ylabel('----->y');
    title('Given data');
    hold on;
    plot(data(:,1),temp*theta,'r*');
    legend('Training data', 'Linear regression')
    hold off;
    

    
    % Mean square error
    
    x = data1(:,1:c-1);
    y = data1(:,c);
    %for i=1:c-1
     %   x(i) = x(i)- mu(i)/sigma(i);
    %end
    [x, mu, sigma] =normalize(x);
    x = [ones(r,1) x];
    x*theta;
    err = (x*theta-y)'*(x*theta-y);
    err = sqrt(err/r);
    disp('mean square error');
    disp(err);
    
    
    %{
    figure(3);
    plot(0:lam_iter-1,test_error,'-b');
    xlabel('----> lambda');
    ylabel('----> error');
    title('lambda Vs Error');
    test_error
    %}
    
    
    