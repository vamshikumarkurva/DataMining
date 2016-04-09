X = csvread('cluster1.csv');
[r,c]=size(X);
visit = zeros(r,1);
% 0--->unvisited, 1--->visited, 2--->noise

eps = 2;  %2 ---> cluster2, 2---->cluster1
minpts = 30; %6 --->cluster2, 30--->cluster1
idx = zeros(r,1);
clust_num = 1;

for i=1:r
   if visit(i)~=1
      visit(i)=1;
      P = X(i,:);
      nbd = findnbd(P,X,eps);
      if numel(nbd) < minpts
          visit(i)=2;
      else
          [idx1,visit] = expandcluster(i,idx,nbd,X,clust_num,eps,minpts,visit);
          clust_num = clust_num+1;
          idx = idx1;
      end
   end
end

figure;
hold on;
for i=1:r
    if idx(i)==0
        plot3(X(i,1),X(i,2),X(i,3),'*k');
    elseif idx(i)==1
        plot3(X(i,1),X(i,2),X(i,3),'*r');
    elseif idx(i)==2
        plot3(X(i,1),X(i,2),X(i,3),'*b');
    elseif idx(i)==3
        plot3(X(i,1),X(i,2),X(i,3),'*g');
    elseif idx(i)==4
        plot3(X(i,1),X(i,2),X(i,3),'*c'); 
    end
end
