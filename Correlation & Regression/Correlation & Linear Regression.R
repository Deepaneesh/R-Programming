x=c(10,43,76,78,55,48,93)

y=c(70,56,46,79,49,58,63)

# data frame 
datam=data.frame(x,y)

# correlation
cor(datam)

#Regression 
new_data=data.frame(x=c(100))
model=lm(y~x,data=datam)
model
predict(model,new_data)


