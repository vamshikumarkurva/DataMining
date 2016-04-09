clc;
close all;
data1 = load('C:\Users\pc\Documents\MATLAB\assignment3\wdbc_new.csv');
[r,c] = size(data1);
alpha = 0.01;
lambda = 0;
num_iter = 1000;
data = [data1(:,3:c) data1(:,2)];
[r,c]=size(data);

trainX = data(:,1:c-1);
trainY = data(:,c);

m = length(trainY); % number of training examples

fprintf('Normalizing Features ...\n');
% Z score normalization of training data
[trainX,mu,sigma] = zscore(trainX);

trainX = [ones(r,1) trainX];
theta = zeros(size(trainX,2),1);

%gradient descent
[theta, J_cost] = grad(trainX, trainY, theta, alpha, lambda, num_iter);

% Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta);
fprintf('\n');

% plot the cost function vs iterations graph
figure;
plot(1:num_iter, J_cost, '-b', 'LineWidth', 2);
xlabel('Number of iterations');
ylabel('Cost J');
title('convergence plot');

%plot ROC curve
sens = zeros(100,1);
spec = zeros(100,1);
i = 0; tp = 0; tn = 0; fp = 0; fn = 0;
for thresh=0:0.0125:1
    out = 1./(1+exp(-trainX*theta));
    outY = (out>=thresh);
    TP = and(trainY, outY);
    FP = and(~trainY, outY);
    FN = and(trainY, ~outY);
    TN = and(~trainY, ~outY);
    if thresh==0.5
        tp = sum(TP);
        fp = sum(FP);
        fn = sum(FN);
        tn = sum(TN);
    end
    sens(i+1) = sum(TP)/(sum(TP)+sum(FN));
    spec(i+1) = sum(TN)/(sum(TN)+sum(FP));
    i = i+1;
end

figure;
plot((0:i-1)/80, 1-spec(1:i,1), '-b','LineWidth',2);
xlabel('----> threshold');
hold on;
plot((0:i-1)/80, sens(1:i,1), '-r','LineWidth',2);
legend('(1-specificity)','sensitivity')
hold off;
figure(4);
plot(1-spec(1:i,1), sens(1:i,1), '-r','LineWidth',2);
xlabel('---->(1-specificity)');
ylabel('sensitivity');
title('ROC curve');

disp('For threshold of 0.5');
disp('True Positives = '); disp(tp);
disp('True Negatives = '); disp(tn);
disp('False Positives = '); disp(fp);
disp('False negatives = '); disp(fn);




