ll=seq(499.5,1099.5,100)
ul=seq(599.5,1199.5,100)
f=c(0,85,77,124,78,36,0)

af=cumsum(f)# ascending order cumsum
df=rev(cumsum(rev(f))) # decending order cumsum

#plot the diagram 
plot(ul,af,type="l",col="blue",xlab = "life of bulbs",ylab = "cummulative frequency",
     main="OGive curve",xlim=c(499.5,1199.5),lwd=2)
lines(ll,df,col="red",type="l",lwd=2)
