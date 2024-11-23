day_of_the_date=function(d,M,y){
  m=M-1
  year=y-1
  k=year%%100
  century_year=(year-k)%%400
  odd_day_1=ifelse(century_year==1,5,
                   ifelse(century_year==2,3,
                          ifelse(century_year==3,1,0)))
  odd_day_2=k+(k-(k%%4))/4
  
  odd_day_3=ifelse(m==1,3,
                   ifelse(m==3,6,
                          ifelse(m==4,1,
                                 ifelse(m==5,4,
                                        ifelse(m==6,6,
                                               ifelse(m==7,2,
                                                      ifelse(m==8,5,
                                                             ifelse(m==9,0,
                                                                    ifelse(m==10,3,
                                                                           ifelse(m==11,5,
                                                                                  ifelse(m==12,1,0)))))))))))
  odd_day_4=ifelse(y%%4==0,1,0)
  total_odd_days=d+odd_day_1+odd_day_2+odd_day_3+odd_day_4
  remaining_odd_days=total_odd_days%%7
  day=ifelse(remaining_odd_days==0,"sunday",
             ifelse(remaining_odd_days==1,"Monday",
                    ifelse(remaining_odd_days==2,"Tuesday",
                           ifelse(remaining_odd_days==3,"Wednesday",
                                  ifelse(remaining_odd_days==4,"Thusday",
                                         ifelse(remaining_odd_days==5,"Friday",
                                                ifelse(remaining_odd_days==6,"Saturday",0)))))))
  return((day))
  
}
day_of_the_date()# the input should be in (dd,mm,yyyy) formate 
# giving the input manually 
day_of_the_date(09,08,2002)
day_of_the_date(15,09,1945)
day_of_the_date(23,08,2024)

# Creating a function for the day of the date function to give the input in proper way
day_of_the_date_function=function(value){
  day=day_of_the_date(value[1],value[2],value[3])
  return(day)
}
# getting an input by using scan function (dd,mm,yyyy)formate 
k=scan(what=as.numeric(),nmax = 3)
day_of_the_date_function(k)

#getting an input by using readline function (the input str is in dd/mm/yyyy formate )
k1=readline("date:")|>strsplit(split ="/")|>unlist()|>as.numeric()
day_of_the_date_function(k1)



# Default R function for finding day of the date 
library(lubridate)
# the str of lubridate is (YYYY-mm-dd)
date=as.Date("2002-08-09")
weekdays(date)

