# Central tendency code########
central_tendency=function(l,u,f){
  ##mean ====
  m=(l+u)/2
  data1=rep(m,f)
  mean=mean(data1)
  
  ##median ====
  c=cumsum(f)
  n=sum(f)
  prop=n/2
  medianclass=min(which(c>=prop))
  freq=f[medianclass]
  cf=c[medianclass-1]
  median_l=l[medianclass]
  median=median_l+((prop-cf)/freq)*(l[2]-l[1])
  
  ##mode ====
  modeclass=which(f==max(f))
  mode_l=l[modeclass]
  f0=f[modeclass-1]
  f1=f[modeclass]
  f2=f[modeclass+1]
  mode=mode_l+((f1-f0)/(2*f1-f0-f2))*(l[2]-l[1])
  
  ##result====
  return(c("mean"=round(mean,4),"median"=round(median,4),"mode"=round(mode,4)))
}

# Data for Calculating Central tendency ====
lo=c(145,150,155,160,165,170,175,180)
up=lo+5
fr=c(4,6,28,58,64,30,5,5)

# Function calling area ====
central_tendency(lo,up,fr)

