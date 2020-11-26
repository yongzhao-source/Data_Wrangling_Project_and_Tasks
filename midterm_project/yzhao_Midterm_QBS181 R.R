library(SASxport)
DIQ<-read.xport("DIQ_I.XPT")
View(DIQ)
library(dplyr)
library(sqldf)


#In DIQ010 column, there are not group together, which is not informative. I think it will be better if we group the participants based on their health conidtion.
#There are five conditions according to the website, 1,2,3,7,9.
#For this table, I am going to focus on the patients who got the diabetes, which is DIQ010=1
#The reason I focus on manipulating the data frame where DIQ010 = 1 is if people don't have diabetes, the other columns which about diabetes have no meaning for those people who don't have diabetes. 
#Check and verify each columns has the same values as the website provided. 

#After checking,there are no missing value in the participant ID column, I split into five data frame relative to condition

#After manipulating the data, I will merge these five data frames back to the large data frame.

#SQL:
#sqldf does not support the "labeled" column class produced 
#All the columns seem to be integer or numeric so convert the columns to numeric first:
DIQ[] <- lapply(DIQ, as.numeric)

condition_1<-sqldf("select * from DIQ where DIQ010 ==1")
View(condition_1)

condition_2<-sqldf("select * from DIQ where DIQ010 ==2")
View(condition_2)

condition_3<-sqldf("select * from DIQ where DIQ010 ==3")
View(condition_3)

condition_7<-sqldf("select * from DIQ where DIQ010 ==7")
View(condition_7)


condition_9<-sqldf("select * from DIQ where DIQ010 ==9")
View(condition_9)



#We could use sql aggregate function to first see the average values(e.g. average age of getting the diabetes) from the raw data. 

avg_year1<-sqldf("select avg(DID040) from condition_1")
#avg_year2<-sqldf("select avg(DID040) from condition_2")
#avg_year3<-sqldf("select avg(DID040) from condition_3")
#avg_year7<-sqldf("select avg(DID040) from condition_7")
#avg_year9<-sqldf("select avg(DID040) from condition_9")




#After splitting the data frame, it become more clear. Then I will use R to impute the mean for numeric missing value. We could use mean to estimate the patients with missing value.  
#And I will impute 0 for factor missing value. 
#I will leave missing value for those columns which only have missing value. 
#Also, for some columns and rows, I will leave missing value, becasue whether change to mean, median, or 0 doesn't make any sense.
#To locate the outliers, I will use plot  to locate them. 

#R
#Same step as SQL
#I split the data set. Use plot to find the outliers. If there are few outliers, and it has the numerical meaning, I make the outliers to missing value and impute the mean. If there are many outliers and non-numerical meaning, I will make them equal to 0. 


DIQ1 = DIQ[DIQ$DIQ010 == 1,]   #Have diabetes 
DIQ2 = DIQ[DIQ$DIQ010== 2,]    #No diabetes
DIQ3 = DIQ[DIQ$DIQ010== 3,]    #Borderline
DIQ7 = DIQ[DIQ$DIQ010== 7,]    #Refused 
DIQ9 = DIQ[DIQ$DIQ010== 9,]    #Don't know 
##Have diabetes  DIQ1
View(DIQ1)
View(DIQ2)
View(DIQ3)
View(DIQ7)
View(DIQ9)


typeof(DIQ1$DID040)
#According to the plot, there are a couple outliers, I will make the outliers to NA. And did the mean imputation. 

#people cannot live more than 200 years old
DIQ1$DID040[DIQ1$DID040 >= 200] <- NA

#There are missing value for the age of patients who was told by doctors that they have diabetes 
#I will use use mean imputation for those missing value. 
DIQ1$DID040[is.na(DIQ1$DID040)] <- mean(DIQ1$DID040, na.rm = TRUE)
DIQ1$DID040<-round(DIQ1$DID040,2)
plot(DIQ1$DID040)


#Remove the columns which only contain missing values. This means at condition1, these columns have no meaning. 
check_NA<-select(DIQ1, DIQ160:DIQ180)
check_NA[is.na(check_NA)]<-0
sum(check_NA)  # Because it is O, so all of these column are missing values, we could delete these columns 

DIQ1<-select(DIQ1, -(DIQ160:DIQ180))
View(DIQ1)


#DIDO60: How long take insulin is only applied for people is taking insulin. I made DIDO60 and DIDO60S missing value equal to 0.   
sum(is.na(DIQ1$DIQ050))
DIQ1$DID060[is.na(DIQ1$DID060)]<-0
DIQ1$DIQ060U[is.na(DIQ1$DIQ060U)]<-0

sum(is.na(DIQ1$DIQ70))  # There is no missing value in "Take diabetes pills to lower blood sugar

DIQ1$DIQ230[is.na(DIQ1$DIQ230)]<-mean(DIQ1$DIQ230,na.rm = TRUE) #impute the missing value as mean


which(is.na(DIQ1$DIQ240))

mean(DIQ1$DIQ240,na.rm = TRUE) #Becasue the mean is 1.24619, which is closer to 1 than 2. 1 mean yes, 2 mean no.  I will impute the missing value as 1. 

DIQ1$DIQ240[is.na(DIQ1$DIQ240)]<-1


#make a plot to check outliers. For column in the past years, how many times seen doctor
plot(DIQ1$DID250)
#From the plot, we can see that there are three 9999, I will treat them as outliers. 
#Imputate the mean to missing value 

DIQ1$DID250[DIQ1$DID250 == 9999] <- NA

DIQ1$DID250[is.na(DIQ1$DID250)]<-mean(DIQ1$DID250,na.rm = TRUE)
DIQ1$DID250<-round(DIQ1$DID250,2)


which(is.na(DIQ1$DID260))

#If DIQ260 = 0, DIQ260U = 0 
is.na(DIQ1$DIQ260==0) == is.na(DIQ1$DIQ260U)

DIQ1$DIQ260U[is.na(DIQ1$DIQ260U)]<-0




which(is.na(DIQ1$DIQ275))


#Make don't know as missing value 
plot(DIQ1$DIQ275)

DIQ1$DIQ275[DIQ1$DIQ275 == 9] <- NA
#closer to 1, 1.195734, impute the missing value as 1
mean(DIQ1$DIQ275,na.rm = TRUE)
DIQ1$DIQ275[is.na(DIQ1$DIQ275)]<-1



DIQ1$DIQ280[DIQ1$DIQ280 >700] <- NA
plot(DIQ1$DIQ280)

DIQ1$DIQ280[is.na(DIQ1$DIQ280)]<-mean(DIQ1$DIQ280,na.rm = TRUE)

DIQ1$DIQ280<-round(DIQ1$DIQ280,2)



DIQ1$DIQ291[DIQ1$DIQ291 >70] <- NA
DIQ1$DIQ291[is.na(DIQ1$DIQ291)]<-mean(DIQ1$DIQ291,na.rm = TRUE)
DIQ1$DIQ291<-round(DIQ1$DIQ291,2)
plot(DIQ1$DIQ291)


DIQ1$DIQ300S[DIQ1$DIQ300S >201] <- NA

DIQ1$DIQ300S[is.na(DIQ1$DIQ300S)]<-mean(DIQ1$DIQ300S,na.rm = TRUE)
DIQ1$DIQ300S<-round(DIQ1$DIQ300S,2)

DIQ1$DIQ300D[DIQ1$DIQ300D >251] <- NA
DIQ1$DIQ300D[is.na(DIQ1$DIQ300D)]<-mean(DIQ1$DIQ300D,na.rm = TRUE)
DIQ1$DIQ300D<-round(DIQ1$DIQ300D,2)


DIQ1$DID310S[DIQ1$DID310S >251] <- NA
DIQ1$DID310S[is.na(DIQ1$DID310S)]<-mean(DIQ1$DID310S,na.rm = TRUE)
DIQ1$DID310S<-round(DIQ1$DID310S,2)


DIQ1$DID310D[DIQ1$DID310D >140] <- 0
DIQ1$DID310D[is.na(DIQ1$DID310D)]<-mean(DIQ1$DID310D,na.rm = TRUE)


#Because there are many outliers, I make the outliers as 0 instead of mean. 
DIQ1$DID320[DIQ1$DID320 >520] <- 0
DIQ1$DID320[is.na(DIQ1$DID320)]<-mean(DIQ1$DID320,na.rm = TRUE)
DIQ1$DID320<-round(DIQ1$DID320,2)


DIQ1$DID330[DIQ1$DID330 >205] <- 0

DIQ1$DID330[is.na(DIQ1$DID330)]<-mean(DIQ1$DID330,na.rm = TRUE)

DIQ1$DID330<-round(DIQ1$DID330,2)



DIQ1$DID341[DIQ1$DID341 >34] <- NA

DIQ1$DID341[is.na(DIQ1$DID341)]<-mean(DIQ1$DID341,na.rm = TRUE)

DIQ1$DID341<-round(DIQ1$DID341,2)




DIQ1$DID350[DIQ1$DID350 >20] <- NA

DIQ1$DID350[is.na(DIQ1$DID350)]<-mean(DIQ1$DID350,na.rm = TRUE)

DIQ1$DID350<-round(DIQ1$DID350,2)







DIQ1$DIQ350U[is.na(DIQ1$DIQ350U)]= 0 




DIQ1$DIQ080[DIQ1$DIQ080 >2] <- NA

DIQ1$DIQ080[is.na(DIQ1$DIQ080)]<-mean(DIQ1$DIQ080,na.rm = TRUE)

DIQ1$DIQ080<-round(DIQ1$DIQ080,2)


DIQ1$DIQ360[is.na(DIQ1$DIQ360)] = 0




plot(DIQ1$DID341)


#Finally I merge back to the large data frame. 
new_dataframe <- rbind(DIQ1,DIQ2,DIQ3,DIQ7,DIQ9)
View(new_dataframe)








