
clc;
clear;
close all;


M=csvread('cluster2.csv')
save('cluster2.mat','M')

data=load('cluster2');
M=data.M;




epsilon=1.5;
MinPts=3;
[IDX a]=DBSCAN(M,epsilon,MinPts);





