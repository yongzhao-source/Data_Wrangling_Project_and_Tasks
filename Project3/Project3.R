#Question1
library(dplyr)
library(tidyverse)
library(magrittr)
library(nycflights13)
#a)Compute the rate for table2, and table4a+table4b and perform the four operation
#table2
#table2%>%mutate(rate=cases/population *10000)
cases<-filter(table2,type == 'cases')
population<-filter(table2,type == 'population')
table2_rate<-cases$count/population$count
#table4a+table4b 
table4a_gather<-table4a%>%gather(`1999`,`2000`,key="year",value="cases")
table4b_gather<-table4b%>%gather(`1999`,`2000`,key="year",value="population")
table4a_gather$cases/table4b_gather$population

#b) Extract the number of TB cases per country per year
Afghanistan_1999_cases<-filter(table2,type =='cases',country =='Afghanistan',year=='1999')

Afghanistan_2000_cases<-filter(table2,type =='cases',country =='Afghanistan',year=='2000')

Brazil_1999_cases<-filter(table2,type =='cases',country =='Brazil',year=='1999')

Brazil_2000_cases<-filter(table2,type =='cases',country =='Brazil',year=='2000')

China_1999_cases<-filter(table2,type =='cases',country =='China',year=='1999')

China_2000_cases<-filter(table2,type =='cases',country =='China',year=='2000')



#c)	Extract the matching population per country per year
Afghanistan_1999_population<-filter(table2,type =='population',country =='Afghanistan',year=='1999')

Afghanistan_2000_population<-filter(table2,type =='population',country =='Afghanistan',year=='2000')

Brazil_1999_population<-filter(table2,type =='population',country =='Brazil',year=='1999')

Brazil_2000_population<-filter(table2,type =='population',country =='Brazil',year=='2000')

China_1999_population<-filter(table2,type =='population',country =='China',year=='1999')

China_2000_population<-filter(table2,type =='population',country =='China',year=='2000')


#d)Divide cases by population, and multiply by 10,000
Afghanistan_1999_rate<-(Afghanistan_1999_cases$count/Afghanistan_1999_population$count)*10000

Afghanistan_2000_rate<-(Afghanistan_2000_cases$count/Afghanistan_2000_population$count)*10000

Brazil_1999_rate<-(Brazil_1999_cases$count/Brazil_1999_population$count)*10000

Brazil_2000_rate<-(Brazil_2000_cases$count/Brazil_2000_population$count)*10000

China_1999_rate<-(China_1999_cases$count/China_1999_population$count)*10000

China_2000_rate<-(China_2000_cases$count/China_2000_population$count)*10000


#e)Store back in appropriate place.
calculate_rate<-c(0.372741,1.294466,2.19393,4.612363,1.667495,1.669488)
table3_new<-cbind(table3,calculate_rate)


#Question 2 :
#1999 and 2000 should have ""
#The correct code should be: table4a%>%gather(`1999`,`2000`,key="year",value="cases")


#table2
#spread(table2,key=type,value=count)
#table3
#separate(table3,rate,into=c("cases","population"))
#separate(table3,year,into=c("century","year"),sep=2)%>%separate(rate, into=c("cases","population"))
#table5
#unite(table5,new,century,year)




#3a:
  #Question3:
  #a:
  make_datetime_time100 <- function(year, month, day, time) {
    make_datetime(year, month, day, time %/% 100, time %% 100)
  }
flights_new <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(
    dep_time = make_datetime_time100(year, month, day, dep_time),
    arr_time = make_datetime_time100(year, month, day, arr_time),
    sched_dep_time = make_datetime_time100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_time100(year, month, day, sched_arr_time)
  ) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))
flights_new %>%
  filter(!is.na(dep_time)) %>%
  mutate(dep_hour = update(dep_time, yday = 1)) %>%
  mutate(month = factor(month(dep_time))) %>%
  ggplot(aes(dep_hour, color = month)) +
  geom_freqpoly(binwidth = 60 * 60)

#3b:
  #b
#They are not consistent 
flights$dep_time
flights$sched_dep_time
flights$dep_delay*60
flights$dep_time +flights$dep_delay*60 ==flights$sched_dep_time



#3c:
  flights_new%>%
  mutate(minute = minute(dep_time),
         early = dep_delay<0)%>%
  group_by(minute)%>%
  summarise(
    early = mean(early, na.rm= TRUE),
    n = n())%>%
  ggplot(aes(minute,early))+
  geom_line()


