function [IDX,visit] = expandcluster(i,idx,nbd,X,clust_num,eps,minpts,visit)
    idx(i) = clust_num;
    j = 1;
    while true
        if visit(nbd(j))~=1
            visit(nbd(j))=1;
            nbd1 = findnbd(X(nbd(j),:),X,eps);
            if numel(nbd1) >= minpts
               nbd = [nbd;nbd1];
            end
        end
        if idx(nbd(j))==0
           idx(nbd(j))=clust_num; 
        end
        j = j+1;
        if j > numel(nbd)
            break;
        end
    end
    IDX = idx;
end