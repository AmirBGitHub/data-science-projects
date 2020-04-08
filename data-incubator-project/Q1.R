rm(list = setdiff(ls(), lsf.str()))

library(gtools)

P_mean<-numeric()
P_sd<-numeric()
Prob<-numeric()
P_check<-c(45,160)
m<-1
for (k in c(10,20)){
  x <- seq(1,k)
  #get all permutations
  C <- permutations(n=k,r=k,v=x,repeats.allowed=F)
  P<-rep(0,length(C[,1]))
  #calculate the payments
  for (i in seq(1,length(C[,1]))){
    P[i]<-C[i,1]+sum(abs(diff(C[i,])))
  }
  #find mean and standard deviation
  P_mean <- append(P_mean,mean(P))
  P_sd <- append(P_sd,sd(P))
  Prob <- append(Prob,sum(P >= P_check[m])/length(P))
  m<-m+1
}

# P_mean(10) = 38.5000000000 
# P_sd(10) = 6.3652712300 
# P_prob(10) = 0.1817956349 
# P_mean(20) = 103.5000000000
# P_sd(20) =  15.3191627357
# P_prob(20) = 0.1090773792 



