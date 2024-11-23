midx=seq(25,85,10)
frequency=c(10,24,18,12,8,5,3)
brk=seq(20,90,10)

# Data creating #######
data=rep(midx,frequency)

# Histrogram #####
hist(data,breaks = brk,xlab = "pocket money",
     ylab = "no of student",col = "gray",main = "Histogram")

# Line plot #####
plot(midx,frequency,type="o",lwd=2,xlab="pocket money",ylab = "no of student",
     col = "black",main = "Line diagram")
