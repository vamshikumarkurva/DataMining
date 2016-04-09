function plotdata(X, y)

figure; 
hold on;
m = length(y);

for i=1:m
    if y(i) == -1
        plot(X(i,1),X(i,2),'bo');
    else
        plot(X(i,1),X(i,2),'r+');
    end
end

end
