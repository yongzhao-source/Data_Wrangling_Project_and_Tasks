
Quesion1
a)
```{r}
#install.packages("tidyverse")
library(tidyverse)

final_data<-read.csv('IC_BP_v2.csv')
names(final_data)[names(final_data) == "BPAlerts"] <- "BP Status"  #Chaneg columns name to "BP Status"
final_data[sample(nrow(final_data), 10), ] #print random 10 rows
```


b)
```{r}
final_data$'BP Status' [which(final_data$'BP Status' =="Hypo1")]<-1 	#Define Hypo-1 as Controlled blood pressure, which is equal to 1
final_data$'BP Status' [which(final_data$'BP Status' =="Normal")]<-1 #Define Normal as Controlled blood pressure, which is equal to 1
final_data$'BP Status' [which(final_data$'BP Status' =="Hypo2")]<-0 #Define Hypo2 as Uncontrolled blood pressure, which is equal to 0
final_data$'BP Status' [which(final_data$'BP Status' =="HTN1")]<-0 #Define HTN1 as Uncontrolled blood pressure, which is equal to 0
final_data$'BP Status' [which(final_data$'BP Status' =="HTN2")]<-0 #Define HTN2 as Uncontrolled blood pressure, which is equal to 0
final_data$'BP Status' [which(final_data$'BP Status' =="HTN3")]<-0##Define HTN3 as Uncontrolled blood pressure, which is equal to 0
final_data[sample(nrow(final_data), 10), ] # print random 10 rows 
```
c)
```{r}
library("RODBC")
library(dplyr)
library(sqldf)
library(stringr)
library(lubridate)
#install.packages('anytime')
library(anytime)


#install.packages("gettz")
myconnection  <- odbcConnect("dartmouth2","yzhao","yzhao@qbs181")
IC_Demo<-sqlQuery(myconnection,"select * from Demographics")
merge_two_table <- sqldf("select * from IC_Demo d inner join final_data f on d.contactid = f.ID") #Merge two tables

#Enrollmentcompletedate is the emrollment date:merge_two_table$tri_enrollmentcompletedate
merge_two_table[sample(nrow(merge_two_table), 10), ] # print random 10 rows 
```
d)
```{r}

#Convert timestamp to date, Observed time is Unix time whih is the number of seconds that have passed since January 1, 1970 (the birth of Unix a.k.a. the Unix epoch). So, I define the date of observe interval is Enrollmentdate +observetime = final date 
#anytime(merge_two_table$ObservedTime)

a<-as.factor(merge_two_table$tri_enrollmentcompletedate)
abis<-strptime(a,format="%m/%d/%Y") #defining what is the original format of your date
b<-as.Date(abis,format="%Y-%m-%d")  #defining what is the desired format of your date
c<-as.numeric(as.POSIXct(b, format="%Y-%m-%d"))
merge_two_table$ObservedTime<-(c+merge_two_table$ObservedTime)
value <- merge_two_table$ObservedTime
merge_two_table$ObservedTime<-as.Date(as.POSIXct(merge_two_table$ObservedTime, origin="1970-01-01"))
merge_two_table$ObservedTime<-anytime(merge_two_table$ObservedTime)

merge_two_table[sample(nrow(merge_two_table), 10), ] #print random 10 rows

#Average of Systolic Value and Diastolic value 
merge_two_table%>%
  group_by(ID)%>% #Group by ID
  summarise(mean(SystolicValue))  
merge_two_table%>%       
  group_by(ID)%>%  #Group by ID
  summarise(mean(Diastolicvalue))  
```

e) f)There are two assumaptions to define observed time. First, if the observed time is a duration which is long enough, We could divide the duration to 12-weeks and look at the BP status of patients. But, according to the observed time, which only contains 5 digit. If the unit is seconds, it is not long enough for 12 weeks.For example, 1 day has 86400 seconds. If it is minutes, one day contains 1440 minutes. 

Secondly, observed time is the timestamps. So after patients finish Enrollment(tri_enrollmentcompletedate), they start to do the test. The observe time is when they finish their testing. So, the duration should be observed time - tri_enrollmentcompletedate.The duration could be divided by 12-weeks to see the BP status of patients.  However, according to what I see, observedtime is 6 digits, tri_enrollmentcompletedate is 10 digit. 

Becasue oberve time is only 6 digit, so I prefer it is a observe duration. If I could convert the 6 digit code to a duration, which is up to around 12-weeks,then i could see the change from baseline to endpoint and compare the BP status for patients over a period. 
```{r}
#I prefer to assume the unit of  observed time is minutes. But, the problem is that for each individuals, their observe time are very close. For example,the time difference is only a couple seconds. 
#merge_two_table <- sqldf("select * from IC_Demo d inner join final_data f on d.contactid = f.ID") #Merge two tables
#merge_two_table[sample(nrow(merge_two_table), 10), ] # print random 10 rows 
#merge_two_table$ObservedTime
#merge_two_table%>%
#distinct(ObservedTime)%>%


```









2
```{r}
#get table from server
IC_Condition<-sqlQuery(myconnection,"select * from Conditions")
IC_Text<-sqlQuery(myconnection,"select * from Text")
#IC_Demo<-sqlQuery(myconnection,"select * from Demographics") 

#Merge Table by SQL
merge_three_table<-sqldf("select * from IC_Demo d 
inner join IC_Condition c on d.contactid =c.tri_patientid 
inner join IC_Text t 
on d.contactid = t.tri_contactId
group by d.contactid ")   #Merge table 

#select all columns and latest date 
merge_three_table<- sqldf("select contactid,gendercode,tri_age,parentcustomeridname,tri_imaginecareenrollmentstatus,address1_stateorprovince,tri_imaginecareenrollmentemailsentdate,tri_enrollmentcompletedate,gender,tri_patientid,tri_name,tri_contactId,SenderName,max(TextSentDate) from merge_three_table group by contactid ") 


#Rename the column 
names(merge_three_table)[names(merge_three_table) == "Latest Textsentdate"] <- "Latestdate" 


#Convert the timestamps to real date. 
merge_three_table$Latestdate<-as.Date(as.POSIXct(merge_three_table$Latestdate, origin="1970-01-01"))  

# print random 10 rows 
merge_three_table[sample(nrow(merge_three_table), 10), ] 



```


3
```{r}
#get table from server
#IC_Condition<-sqlQuery(myconnection,"select * from Conditions")
#IC_Text<-sqlQuery(myconnection,"select * from Text")
#IC_Demo<-sqlQuery(myconnection,"select * from Demographics") 

#Merge Table by dplyr
Demo_Condition<-inner_join(IC_Demo, IC_Condition, by = c("contactid" = "tri_patientid"))
Demo_Condition_Text<-inner_join(Demo_Condition,IC_Text,by = c("contactid" = "tri_contactId"))

#Use dplyr find the latest sent date. One row one ID. 
Demo_Condition_Text%>%
  group_by(contactid)%>%
  slice(which.max(TextSentDate)) 

# print random 10 rows 
Demo_Condition_Text[sample(nrow(Demo_Condition_Text), 10), ] 

```

