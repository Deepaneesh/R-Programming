x=c(0,1,2,3)
f=c(8,11,5,1)

###FUNCTION FOR CALCULATING CENTRAL TENDENCY #####

Central_Tendency_Discreate_case=function(x,f){
  
  ## for data ====
  data=rep(x,f)
  
  ## FOR MEAN ====
  MEAN=round(mean(data),3)
  
  ## MEADIAN =====
  MEDIAN=round(median(data),3)
  
  ## MODE =====
  MODE=names(table(data))[table(data)==max(table(data))]
  
  ## RESULT ====
  return(c("Mean"=MEAN,"Median"=MEDIAN,"Mode"=MODE))
  
}
Central_Tendency_Discreate_case(x,f)
