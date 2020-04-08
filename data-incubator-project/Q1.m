clear all
clc

k=1;
for n=[10]
    C = perms(1:n);

    for i=1:length(C)
        P(i,1) = C(i,1)+sum(abs(diff(C(i,:))));
    end
    
    digits(10);
    P_mean(k) = mean(P);
    P_std(k) = std(P);
    k=k+1;
end

sort(P);
P45 = length(find(P>=45))/length(P);