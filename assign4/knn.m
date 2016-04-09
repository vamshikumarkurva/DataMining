[num,txt,raw] = xlsread('crx.csv');
[r,c] = size(txt);
tmp = zeros(r,1);
for i=1:r
    tmp(i) = randi(r);
end
idxT = unique(tmp);
ind = 1:1:r;
ind = ind';
idxV = setdiff(ind,tmp);

numT = zeros(length(idxT),size(num,2));
txtT = cell(length(idxT),size(txt,2)-1);
yT = zeros(length(idxT),1);
numV = zeros(r-length(idxT),size(num,2));
txtV = cell(r-length(idxT),size(txt,2)-1);
yV = zeros(r-length(idxT),1);

for i=1:length(idxT)
   numT(i,:) = num(idxT(i),:);
   txtT(i,:) = txt(idxT(i),1:size(txt,2)-1);
   if txt{idxT(i),size(txt,2)}=='+'
       yT(i) = 1;
   else
       yT(i) = 0;
   end
end

for i=1:length(idxV)
   numV(i,:) = num(idxV(i),:);
   txtV(i,:) = txt(idxV(i),1:size(txt,2)-1);
   if txt{idxV(i),size(txt,2)}=='-'
       yV(i) = 1;
   else
       yV(i) = 0;
   end   
end

numT = zscore(numT);
numV = zscore(numV);

K = 7;
dis1 = zeros(length(idxT),1);
dis2 = zeros(length(idxT),size(txtT,2));
DIS = zeros(length(idxT),1);
outV = zeros(length(idxV),1);

for i=1:length(idxV)
    for j = 1:length(idxT)
        dis1(j) = norm(numV(i,:)-numT(j,:));
        dis2(j,:) = cellfun(@strcmp,txtV(i,:),txtT(j,:));
        DIS(j) = dis1(j)+sum(dis2(j,:));
    end
    [dis,id] = sort(DIS);
    pos = sum(yT(id(1:K)));
    neg = K-pos;
    if pos>neg
        outV(i) = 1;
    else
        outV(i) = 0;
    end
end

tp = sum(and(yV,outV))
tn = sum(and(~yV,~outV))
fp = sum(and(~yV,outV))
fn = sum(and(yV,~outV))
accuracy = (tp+tn)/(tp+tn+fp+fn)



