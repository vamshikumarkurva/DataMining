clc;
close all;
data1 = load('C:\Users\pc\Documents\MATLAB\assignment3\wdbc_new.csv');
[r,c] = size(data1);
data = [data1(:,3:c) data1(:,2)];
[r,c]=size(data);
X = data(:,1:c-1);
Y = data(:,c);
m = length(Y);

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
theta0 = (Mu0*(sigma\(Mu0'))) - (Mu1*(sigma\(Mu1'))) + 2*log(k/(m-k));
theta0 = 0.5*theta0;
theta1 = sigma\((Mu1-Mu0)');
theta = [theta0 theta1'];

% GDA parameters
fprintf('Theta computed from GDA: \n');
fprintf(' %f \n', theta);
fprintf('\n');

%plot ROC curve
X = [ones(r,1) X];
sens = zeros(200,1);
spec = zeros(200,1);
i = 0; tp = 0; tn = 0; fp = 0; fn = 0;
for thresh=0:0.00625:1
    out = 1./(1+exp(-X*theta'));
    outY = (out>=thresh);
    TP = and(Y, outY);
    FP = and(~Y, outY);
    FN = and(Y, ~outY);
    TN = and(~Y, ~outY);
    if thresh==0.4
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
plot((0:i-1)/160, 1-spec(1:i,1), '-b');
xlabel('----> threshold');
hold on;
plot((0:i-1)/160, sens(1:i,1), '-r');
legend('(1-specificity)','sensitivity')
hold off;
figure;
plot(1-spec(1:i,1), sens(1:i,1), '-r','LineWidth',2);
xlabel('---->(1-specificity)');
ylabel('sensitivity');
title('ROC curve');

disp('For threshold of 0.4');
disp('True Positives = '); disp(tp);
disp('True Negatives = '); disp(tn);
disp('False Positives = '); disp(fp);
disp('False negatives = '); disp(fn);

%X1 = [ones(k,1) X1];
%out = 1./(1+exp(-X1*theta'))-0.5;