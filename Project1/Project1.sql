    
--Question1 :
-- delete all null values, calculate the different 
-- store in the new column 

--Rename
select * from Demographics
select*into yzhao.Demographics from dbo.Demographics
select contactid as ID, gendercode as Gender, tri_age as Age, parentcustomeridname, tri_imaginecareenrollmentstatus, address1_stateorprovince, tri_imaginecareenrollmentemailsentdate as EmailSentdate, tri_enrollmentcompletedate as completedate from yzhao.Demographics
alter table yzhao.Demographics
add timecompleteenrollment int
select* from yzhao.Demographics
delete from yzhao.Demographics where tri_enrollmentcompletedate like 'NULL'


--Calculate the time (in days) to complete enrollment and create a new column to have this data
select* from yzhao.Demographics


-- Try to convert the data type in two columns 
-- Try to calculate the difference between two columns and store in the new column
update yzhao.Demographics
set timecompleteenrollment = datediff(day, try_convert(datetime,tri_imaginecareenrollmentemailsentdate),try_convert(datetime,tri_enrollmentcompletedate))
select timecompleteenrollment from yzhao.Demographics




-- Question 2
-- select different code
-- make a new column 
-- 
select * from yzhao.Demographics
-- Create a new column:
alter table yzhao.Demographics
add Enrollmentstatus nvarchar(max)  -- why if I didn't write (max), the error would show "String or binary data would be truncated" what does this error mean? 



-- based on different number, define different status in the new column: 
select * from yzhao.Demographics
update yzhao.Demographics
set Enrollmentstatus = 'Complete'
where tri_imaginecareenrollmentstatus = 167410011 

update yzhao.Demographics
set Enrollmentstatus = 'Email sent'
where tri_imaginecareenrollmentstatus = 167410001 

update yzhao.Demographics
set Enrollmentstatus = 'Non responder'
where tri_imaginecareenrollmentstatus = 167410004 

update yzhao.Demographics
set Enrollmentstatus = 'Facilitated Enrollment'
where tri_imaginecareenrollmentstatus = 167410005 

update yzhao.Demographics
set Enrollmentstatus = 'Incomplete Enrollments'
where tri_imaginecareenrollmentstatus = 167410002 

update yzhao.Demographics
set Enrollmentstatus = 'Opted Out'
where tri_imaginecareenrollmentstatus = 167410003 

update yzhao.Demographics
set Enrollmentstatus = 'Unprocessed'
where tri_imaginecareenrollmentstatus = 167410000 


update yzhao.Demographics
set Enrollmentstatus = 'Second email sent'
where tri_imaginecareenrollmentstatus = 167410006 


--Question 3 

select* from yzhao.Demographics

alter table yzhao.Demographics
add Gender1 nvarchar(MAX)

update yzhao.Demographics
set Gender1 = 'female'
where try_convert(int,gender) = 2  

update yzhao.Demographics
set Gender1 = 'male'
where try_convert(int,gender) = 1


update yzhao.Demographics
set Gender1 = 'other'
where try_convert(int,gender) = 167410000


update yzhao.Demographics
set Gender1 = 'Unknown'
where gender is NULL 

select* from yzhao.Demographics



--Question 4 
select* from yzhao.Demographics
alter table yzhao.Demographics
add AgeGroup nvarchar(max)


update yzhao.Demographics
set AgeGroup = '0-25'
where tri_age<25

update yzhao.Demographics
set AgeGroup = '26-50'
where tri_age<=50 and tri_age>=25

update yzhao.Demographics
set AgeGroup = '51-75'
where tri_age<=75 and tri_age>=51

update yzhao.Demographics
set AgeGroup = '76-100'
where tri_age<=100 and tri_age>=76

--check whether people are older than 100
select tri_age from yzhao.Demographics
where tri_age >100
