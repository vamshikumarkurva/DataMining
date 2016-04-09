clc;
close all;
data = csvread('C:\Users\pc\Documents\MATLAB\assignment3\Data1.csv');
[r,c] = size(data);
X = data(:,1:c-1);
Y = data(:,c);

m=length(Y);
for i=1:m
    if Y(i)==-1
        Y(i)=0;
    end
end

k=sum(Y);
X1 = zeros(k,c-1);
X0 = zeros(m-k,c-1);
a=1;
b=1;
for i=1:r
    if Y(i)==1
        X1(a,:) = X(i,:);
        a = a+1;
    else
        X0(b,:) = X(i,:);
        b = b+1;
    end
end

Mu0 = mean(X0);
Mu1 = mean(X1);

Xn = zeros(size(X));
for i=1:r
    if Y(i)==0
        Xn(i,:) = X(i,:)-Mu0;
    else
        Xn(i,:) = X(i,:)-Mu1;
    end
end

sigma = (Xn'*Xn)/(c-1);
sigma_inv = inv(sigma);
theta0 = (Mu0*sigma_inv*(Mu0)') - (Mu1*sigma_inv*(Mu1)') + 2*log(k/(m-k));
theta0 = 0.5*theta0;
theta1 = sigma_inv*(Mu1-Mu0)';
theta = [theta0 theta1'];

% GDA parameters
fprintf('Theta computed from GDA: \n');
fprintf(' %f \n', theta);
fprintf('\n');

%plot the data
plotdata(data(:,1:c-1), data(:,c));
boundary = -(theta(1)+theta(2)*X(:,1))/theta(3);
plot(data(:,1),boundary,'-','LineWidth', 2);
plot(Mu1(1), Mu1(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
plot(Mu0(1), Mu0(2), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;

% negative data
x0 = linspace(-1,9,100);
x1 = linspace(-1,9,100);
gaussain1 = zeros(length(x0),length(x1));
for i=1:length(x0)
    for j=1:length(x1)
        x2 = [ x0(i) ; x1(j) ];
        x2 = x2-(Mu0)';
        val = x2'*sigma_inv*x2;
        gaussian1(i,j) = exp(-0.5*val)/abs(det(sigma));
    end
end
gaussian1 = gaussian1';


figure;
surf(x0,x1,gaussian1);
hold on;
contour(x0,x1,gaussian1,10);
plot(Mu0(1), Mu0(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;


% positive data
x3 = linspace(-6,6,100);
x4 = linspace(-6,6,100);
gaussain2 = zeros(length(x3),length(x4));
for i=1:length(x3)
    for j=1:length(x4)
        x5 = [x3(i) ; x4(j)];
        x5 = x5-(Mu1)';
        val = x5'*sigma_inv*x5;
        gaussian2(i,j) = exp(-0.5*val)/abs(det(sigma));
    end
end
gaussian2 = gaussian2';


figure;
surf(x3,x4,gaussian2);
hold on;
contour(x3,x4,gaussian2,10);
plot(Mu1(1), Mu1(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;


plotdata(data(:,1:c-1), data(:,c));
boundary = -(theta(1)+theta(2)*X(:,1))/theta(3);
plot(data(:,1),boundary,'-','LineWidth', 2);
plot(Mu1(1), Mu1(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
plot(Mu0(1), Mu0(2), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
contour(x0,x1,gaussian1,7);
contour(x3,x4,gaussian2,7);
hold off;

%plot ROC curve
X = [ones(r,1) X];
sens = zeros(100,1);
spec = zeros(100,1);
i = 0; tp = 0; tn = 0; fp = 0; fn = 0;
for thresh=0:0.0125:1
    out = 1./(1+exp(-X*theta'));
    outY = (out>=thresh);
    TP = and(Y, outY);
    FP = and(~Y, outY);
    FN = and(Y, ~outY);
    TN = and(~Y, ~outY);
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
plot((0:i-1)/80, 1-spec(1:i,1), '-b','LineWidth', 2);
xlabel('----> threshold');
hold on;
plot((0:i-1)/80, sens(1:i,1), '-r','LineWidth', 2);
legend('(1-specificity)','sensitivity')
hold off;
figure;
plot(1-spec(1:i,1), sens(1:i,1), '-r','LineWidth', 2);
xlabel('---->(1-specificity)');
ylabel('sensitivity');
title('ROC curve');

disp('For threshold of 0.5');
disp('True Positives = '); disp(tp);
disp('True Negatives = '); disp(tn);
disp('False Positives = '); disp(fp);
disp('False negatives = '); disp(fn);