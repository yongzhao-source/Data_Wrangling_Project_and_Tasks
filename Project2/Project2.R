library("RODBC")
library(sqldf)
library(stringr)
myconnection  <- odbcConnect("dartmouth2","yzhao","yzhao@qbs181")


#Question1:
IC_Phonecall_Encounter<-sqlQuery(myconnection ,"select*from PhoneCall_Encounter")
View(IC_Phonecall_Encounter)
IC_Phonecall_Encounter$Enrollmentgroup<-as.character(IC_Phonecall_Encounter$EncounterCode)
IC_Phonecall_Encounter$Enrollmentgroup<-sub("125060000","Clinical Alert",IC_Phonecall_Encounter$Enrollmentgroup)
IC_Phonecall_Encounter$Enrollmentgroup<-sub("125060001","Health Coaching",IC_Phonecall_Encounter$Enrollmentgroup)
IC_Phonecall_Encounter$Enrollmentgroup<-sub("125060002","Technixal Question",IC_Phonecall_Encounter$Enrollmentgroup)
IC_Phonecall_Encounter$Enrollmentgroup<-sub("125060003","Administrative",IC_Phonecall_Encounter$Enrollmentgroup)
IC_Phonecall_Encounter$Enrollmentgroup<-sub("125060004","Other",IC_Phonecall_Encounter$Enrollmentgroup)
IC_Phonecall_Encounter$Enrollmentgroup<-sub("125060005","Lack of engagement",IC_Phonecall_Encounter$Enrollmentgroup)
View(IC_Phonecall_Encounter)


#Question2:

Clinical_Alert<-grep("Clinical Alert",IC_Phonecall_Encounter$Enrollmentgroup, value = TRUE)
length(Clinical_Alert)


Health_Coaching<-grep("Health Coaching",IC_Phonecall_Encounter$Enrollmentgroup, value = TRUE)
length(Health_Coaching)


Technixal_Question<-grep("Technixal Question",IC_Phonecall_Encounter$Enrollmentgroup, value = TRUE)
length(Technixal_Question)


Administrative<-grep("Administrative",IC_Phonecall_Encounter$Enrollmentgroup, value = TRUE)
length(Administrative)


Other<-grep("Other",IC_Phonecall_Encounter$Enrollmentgroup, value = TRUE)
length(Other)


Lack_of_engagement<-grep("Lack of engagement",IC_Phonecall_Encounter$Enrollmentgroup, value = TRUE)
length(Lack_of_engagement)



#Question3:

Call_Duration<-sqlQuery(myconnection ,"select*from CallDuration")
Call_Duration<-as.data.frame(Call_Duration)
View(Call_Duration)
merge_dataframe<-sqldf("select*from IC_Phonecall_Encounter e inner join Call_Duration c on e.Customerid = c.tri_CustomerIDEntityReference")
View(merge_dataframe)



#Question4:

merge_dataframe$CallOutcome<-as.character(merge_dataframe$CallOutcome)


merge_dataframe$CallOutcome<-sub("1","Inbound",merge_dataframe$CallOutcome)
call_outcomes_inbound<-grep("Inbound",merge_dataframe$CallOutcome, value = TRUE)
length(call_outcomes_inbound)




merge_dataframe$CallOutcome<-sub("2","Outbound",merge_dataframe$CallOutcome)
call_outcomes_outbound<-grep("Outbound",merge_dataframe$CallOutcome, value = TRUE)
length(call_outcomes_outbound)




merge_dataframe$CallType<-as.character(merge_dataframe$CallType)


merge_dataframe$CallType<-sub("1","No response",merge_dataframe$CallType)
Call_Type_No_response<-grep("No response",merge_dataframe$CallType, value = TRUE)
length(Call_Type_No_response)





merge_dataframe$CallType<-sub("2","Left voice mail",merge_dataframe$CallType)
Call_Type_Left_voice_mail <-grep("Left voice mail",merge_dataframe$CallType, value = TRUE)
length(Call_Type_Left_voice_mail)



merge_dataframe$CallType<-sub("3","successful",merge_dataframe$CallType)
Call_Type_successful <-grep("successful",merge_dataframe$CallType, value = TRUE)
length(Call_Type_successful)






Call_Duration_Clinical_Alert<-sqldf("select sum(CallDuration) from merge_dataframe where Enrollmentgroup like'Clinical Alert'")

Call_Duration_H<-sqldf("select sum(CallDuration) from merge_dataframe where Enrollmentgroup like'H%' ")

Call_Duration_T<-sqldf("select sum(CallDuration) from merge_dataframe where Enrollmentgroup like'T%' ")

Call_Duration_A<-sqldf("select sum(CallDuration) from merge_dataframe where Enrollmentgroup like'A%' ")

Call_Duration_O<-sqldf("select sum(CallDuration) from merge_dataframe where Enrollmentgroup like'O%' ")

Call_Duration_L<-sqldf("select sum(CallDuration) from merge_dataframe where Enrollmentgroup like'L%' ")




#Question5


IC_Demo<-sqlQuery(myconnection,"select distinct *from Demographics")
IC_Condition<-sqlQuery(myconnection,"select distinct*from Conditions")
IC_Text<-sqlQuery(myconnection,"select distinct *from Text")
merge_three_table <- sqldf("select* from IC_Demo d inner join IC_Condition c on d.contactid = c.tri_patientid inner join IC_Text t on d.contactid = t.tri_contactid")

View(merge_three_table)


numbers_of_week<-(max(merge_three_table$TextSentDate) - min(merge_three_table$TextSentDate))/7




type_of_sneder<-sqldf("select distinct (SenderName) from merge_three_table")


number_of_clinicians<-sqldf("select count(SenderName) from merge_three_table where SenderName like 'Cli%'")
number_of_clinicians/51.71429

number_of_customer<-sqldf("select count(SenderName) from merge_three_table where SenderName like 'Cu%'")
number_of_customer/51.71429

number_of_Sysyem<-sqldf("select count(SenderName) from merge_three_table where SenderName like 'S%'")
number_of_Sysyem/51.71429




#Question 6:
type_of_chronic_condition<-sqldf("select distinct tri_name from merge_three_table")
type_of_chronic_condition


number_of_Activity_Monitoring<-sqldf("select count(tri_name) from merge_three_table where tri_name like 'Acti%'")
number_of_Activity_Monitoring/51.71429


number_of_Hypertension<-sqldf("select count(tri_name) from merge_three_table where tri_name like 'Hyper%'")
number_of_Hypertension/51.71429


number_of_Diabetes<-sqldf("select count(tri_name) from merge_three_table where tri_name like 'Diab%'")
number_of_Diabetes/51.71429

number_of_COPD<-sqldf("select count(tri_name) from merge_three_table where tri_name like 'COPD%'")
number_of_COPD/51.71429

number_of_Congestive_Heart_Failure<-sqldf("select count(tri_name) from merge_three_table where tri_name like 'Conges%'")
number_of_Congestive_Heart_Failure/51.71429

