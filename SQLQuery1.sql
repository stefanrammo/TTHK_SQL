--loome db
create database TTHK_SQL

--db valimine
use TTHK_SQL	

--db kustutamine
drop database TTHK_SQL

--tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (1, 'Male'),
(2, 'Female'),
(3, 'Unknown')

--vaatame tabeli sisu
select * from Gender

--loome uue tabeli
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int 
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId) values
(1, 'Superman', 's@s.com', 1),
(2, 'Wonderwoman', 'w@w.com', 2),
(3, 'Batman', 'b@b.com', 1),
(4, 'Aquaman', 'a@a.com', 1),
(5, 'Catwoman', 'c@c.com', 2),
(6, 'Antman', 'ant"ant.com', 1),
(7, NULL, NULL, 3),
(8, 'Spiderman', 's@s.com', NULL)

--vaata tabel Person andmeid
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisetad uue rea andmeid ja ei ole sisestanud GenderId-d,
--siis see automaatselt sisestatakse sellele reale väärtusega 3 (unknown)
alter table Person
add constraint DF_persons_GenderId
default 3 for GenderId

--sisestame andmed default väärtusega GenderId's
insert into Person (Id, Name, Email) values
(9, 'Ironman', 'i@i.com')

--lisame uue veeru
alter table Person
add Age nvarchar(10)

--lisame nr piirangu vanuse sisestamisel
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--sisestame uue rea andmeid 
insert into Person (Id, Name, Email, GenderId, Age) values
(10, 'Kalevipoeg', 'k@k.com', 1, 154)

--muudame andmeid koodiga
update Person
set Age = 35
where Id = 9

select * from Person

--sisestame muutuja City nvarchar(50)
alter table Person
add City nvarchar(50)

--sisestame andmed City veergu
update Person
set City = 'Kaljuvald'
where Id = 10

select * from Person

--kõik kes elavad Gotham linnas
select * from Person where City = 'Gotham'
--kõik kes ei ela Gothamis
select * from Person where City != 'Gotham'
--kõik kes ei ela Gothamis
select * from Person where City <> 'Gotham'
--kõik kes ei ela Gothamis
select * from Person where not City = 'Gotham'

--näitab teatud vanusega inimesi
select * from Person where Age = 120 or Age = 35 or Age = 19
--näitab teatud vanusega inimesi
select * from Person where Age in (120, 35, 19)

--näitab teatud vanuse vahemikus inimesi (kaasa arvatud)
select * from Person where Age between 18 and 31

--wildcard ehk näitab kõik g-tähega algavad linnad
select * from Person where City like 'g%'
--kõik emailid kus on @ märk sees
select * from Person where Email like '%@%'

--näitab emaile kus ei ole @ sees
select * from Person where Email not like '%@%'

--näitab kellel on emailis ees ja peale @ märki ainult üks täht
select * from Person where Email like '_@_.com'

--näitab 3 märki enne ja peale @ emailis
update Person
set Email = 'bat@bat.com'
where Id = 3
select * from Person where Email like '___@___.com'

--kõik kellel nimes ei ole esimene täht w, a, c
select * from Person where Name like '[^WAC]%'

--kes elavad Gothamis ja New Yorkis
select * from Person where City = 'Gotham' or City = 'New York'

--kõik kes elavad välja toodud linnades ja on vanemad kui 29
select * from Person where City = 'Gotham' or City = 'New York' and Age > 29

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks nime
select * from Person order by Name
--kuvab vastupidi
select * from Person order by Name DESC

--võtab kolm esimest rida
select top 3 * from Person

--võtab kolm esimest rida, veergudega Age ja Name
select top 3 Age, Name from Person

--näita esimene 50% tabelist
select top 50 percent * from Person

--järjesta vanuse järgi isikud
select * from Person order by cast(Age as int)

--kõikide isikute koondvanus
select sum(cast(Age as int)) from Person

--kuvab kõige nooremat
select min(cast(Age as int)) from Person
--kuvab kõige vanemat
select max(cast(Age as int)) from Person

--näeme konkreetsetes linnades olevate isikute koondvanust
select City, sum(cast(Age as int)) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
ALTER TABLE Person ALTER COLUMN Age int

--kuvab esimeses reas vlja toodud järjestuses ja muudab Age-i TotalAge-ks
--järjestab City-s olevate nimede järgi ja siis GenderId järgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

insert into Person values
(11, 'Robin', 'robin@r.com', 1, 29, 'Gotham')

--näitab ridade arvu tabelis
select count(*) from Person
select * from Person

--näitab tulemust, et mitu inimest on GenderId väärtusega 1 konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total Person(s)]
from Person
where GenderId = '1'
group by GenderId, City

--näitab ära inimeste koondvanuse kui on suurem kui 41 ja kui palju igas linnas, eristab soo järgi
select GenderId, City, sum(Age) as TotalAge, count(Id)
as [Total Person(s)]
from Person
group by GenderId, City having sum(Age) > 41

--loome tabelid Employees ja Department
CREATE TABLE Department (
    Id int not null primary key,
	DepartmentName nvarchar(50),
	Location nvarchar(50),
	DepartmentHead nvarchar(50)
)

CREATE TABLE Employees (
    Id int not null primary key,
	Name nvarchar(50),
	Gender nvarchar(50),
	Salary nvarchar(50),
	DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId) values
(1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 1),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

insert into Department(Id, DepartmentName, Location, DepartmentHead) values
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

--left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--arvutab kõikide palgad kokku
select sum(cast(Salary as int)) from Employees
--min palga saaja
select min(cast(Salary as int)) from Employees
--linnade peale palk kokku
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location

alter table Employees
add City nvarchar(30)

select * from Employees
--määrab linna
update Employees
set City = 'London'
where Id = 8

--näitab kogu palkasi linna ja soo põhjal
select City, Gender, sum(cast(Salary as int)) as TotalSalary from Employees
group by City, Gender
--sama päring nagu eelmine, aga linnad on tähestikulises järjestuses
select City, Gender, sum(cast(Salary as int)) as TotalSalary from Employees
group by City, Gender
order by City

--loeb ära ridade arvu Employees tabelis
select count(*) from Employees

--mitu töötajat on soo ja linna kaupa
select count(Id) as [Total Employee(s)], Gender, City 
from Employees
group by Gender, City

--kuvab ainult kõik naised linnade kaupa
select count(Id) as [Total Employee(s)], Gender, City 
from Employees
where Gender = 'female'
group by Gender, City

--kuvab ainult kõik mehed linnade kaupa ja kasutame having
select count(Id) as [Total Employee(s)], Gender, City 
from Employees
group by City, Gender
having Gender = 'male'

--näidis kus ei tööta where
select * from Employees where sum(cast(Salary as int)) > 4000

select Gender, City, sum(cast(Salary as int)) as TotalSalary, count(Id) as [Total Employee(s)]
from Employees group by Gender, City
having sum(cast(Salary as int)) > 4000

--loome tabeli milles hakatakse automaatselt nummerdama Id-d
create table Test1 (
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')
select * from Test1

alter table Employees
drop column City

--inner join
--kuvab neid, kellel on DepartmentName all olemas väärtus
select Name, Gender, Salary, Department.DepartmentName --loetavuse mõttes kasutan Department.DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
--kuidas saada kõik andmed Employees't kätte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department --võib kasutada ka LEFT OUTER JOIN
on Employees.DepartmentId = Department.Id

---right join
---kuidas saada DepartmentName alla uus nimetus
select Name, Gender, Salary, DepartmentName
from Employees
right join Department --võib kasutada ka RIGHT OUTER JOIN
on Employees.DepartmentId = Department.Id

--kuidas saada kõikide tabelite väärtused ühte päringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id

--cross join võtab kaks allpool olevat tabelit kokku ja korrutab need omavahel läbi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--päringu sisu
select ColumnList
from LeftTable
joinType RightTable
on JoinCondition

--kuidas kuvada ainult need isikud, kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL

--teine variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is NULL

--full join
--mõlema tabeli mitte-kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL
or Department.Id is NULL

--kuidas saame Department tabelis oleva rea, kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL

--kuidas muuta tablei nime, alguses vana tabeli nimi ja siis uue nimi
sp_rename 'Department', 'Department1'
sp_rename 'Department1', 'Department'

--kasutame Employees tabeli asemel lühendit E ja Department asemel D
select E.Name as EmpName, D.DepartmentName as DeptName
from Employees E
left join Department D
on E.DepartmentId = D.Id

--inner join
--kuvab ainult DeptartmentId'ga isikuid
select E.Name as EmpName, D.DepartmentName as DeptName
from Employees E
inner join Department D
on E.DepartmentId = D.Id

--cross join
select E.Name as EmpName, D.DepartmentName as DeptName
from Employees E
cross join Department D

--kuvab 'Stefan' Manager veerus
select ISNULL('Stefan', 'No Manager') as Manager

--NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

--kui Expression on õige, siis paneb väärtuse, 
--mida soovid või mõne teise väärtuse
case when Expression then '' else '' end

---
alter table Employees
add ManagerId int

--neil, kellel ei ole ülemust, siis paneb No manager teksti
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--teeme päringu kus kasutame case-i
select E.Name as Employee, case when M.Name is null then 'No Manager'
else M.Name end as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30),
LastName nvarchar(30)

--muudame veeru nime
SP_RENAME 'Employees.Name','FirstName'

select * from Employees

--näidis nime updateimiseks
update Employees
where FirstName = NULL, MiddleName = NULL, LastName = NULL
where Id = NULL

--igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

--loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

insert into IndianCustomers (Name, Email)
values ('Raj', 'r@r.com'),
('Sam', 's@s.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

--ksautame union all, mis näitab kõiki ridu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtustega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--kuidas sorteerida nime järgi
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers
order by Name

---stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--nüüd saab kasutada selle nimelist sp-d
spGetEmployees
exec spGetEmployees
execute spGetEmployees

---
create proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

--kui nüüd allolevat käsklust käima panna, siis nõuab Gender parameetrit
exec spGetEmployeesByGenderAndDepartment
--õige variant
exec spGetEmployeesByGenderAndDepartment 'male', 1

--nii saab parameetrite järjestusest mööda minna
exec spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'male'

---saab sp sisu vaadata result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta sp-d ja võti peale panna, et keegi teine peale teie ei saaks muuta
alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
--with encryption
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

sp_helptext spGetEmployeesByGenderAndDepartment

create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--annab tulemuse kus loendab ära nõuetele vastavad read
--prindib ka tulemuse kirja teel
declare @TotalCount int
exec spGetEmployeeCountByGender 'male', @TotalCount out
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@TotalCount is not null'
print @TotalCount
go --tee ülevalpool ära ja siis mine edasi
select * from Employees

--näitab ära, et mitu rida vastab nõuetele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Female'
print @TotalCount

--sp/store procedure sisu vaatamine
sp_help spGetEmployeeCountByGender

--tabeli info
sp_help Employees

--kui soovide sp teksti näha
sp_helptext spGetEmployeeCountByGender

--vaatame millest sõltub sp
sp_depends spGetEmployeeCountByGender
--vaatame tabeli sõltuvust
sp_depends Employees

--sp tegemine
create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end

exec spGetNameById 1, 'Tom'

--annab kogu tablei ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = count(Id) from Employees
end

--saame teada, et mitu rida andmeid on tabelis
declare @TotalEmployees int
execute spTotalCount2 @TotalEmployees output
select @TotalEmployees

--mis id all on keegi nime järgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(50) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end
--annab tulemuse kus id esimesel real on keegi koos nimega
declare @FirstName nvarchar(50)
execute spGetNameById1 1, @FirstName output
print 'Name of the employee = ' + @FirstName

---
declare
@FirstName nvarchar(20)
execute spGetNameById 1, @FirstName out
print 'Name = ' + @FirstName

sp_help spGetNameById

--
create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end
--pole outputi seega ei tööta
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name = ' + @EmployeeName

---sisse ehitatud string funktsioonid

--see konverteerib ASCII tähe väärtuse numbriks
select ASCII('a')
--kuvab A-tähte
select char(65)

--prindime välja kogu tähestiku
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
	select char (@Start)
	set @Start = @Start + 1
end


--eemaldame tühjad kohad sulgudes
select ltrim('                   Hello')

--tühikute eemaldamine veerust
select ltrim(FirstName) as FirstName, MiddleName, LastName from Employees

select * from Employees

--paremalt poolt tühjad stringid lõikab ära
select rtrim('              Hello                 ')
select rtrim(FirstName) as FirstName, MiddleName, LastName from Employees

--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt upper ja lower-ga saan muuta märkide suurust
--reverse funktsioon pöörab kõik ümber
select REVERSE(UPPER(ltrim(FirstName))) as FirstName, MiddleName, lower(LastName),
rtrim(ltrim(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--näeb mitu täthe on sõnal ja loeb tühikud sisse
select FirstName, len(FirstName) as [Total Characters] from Employees
--näeb mitu tähte on sõnal ja ei ole tühikuid
select trim(FirstName), len(trim(FirstName)) as [Total Characters] from Employees

--left, right, substring
--vasakult poolt neli esimest tähte
select left('ABCDEF', 4)
--paremalt neli
select right('ABCDEF', 4)
--esimene nr peale koma kohta näitab, et mitmendast alustab ja siis teine, mitu nr kaasa arvatud esimesega peale seda kuvab
select substring('pam@bbb.com', 1, 3)

--kuvab @-tähe märgi asetust
select CHARINDEX('@', 'sara@aaa.com')

--@-märgist kuvab kolm tähemärki. Viimase nr saab määrata pikkust
select substring('pam@bbb.com', charindex('@', 'pam@bbb.com') +  2, len('pam@bbb.com') - CHARINDEX('@', 'pam@bbb.com'))

--saame teada domeeni nimed emailidest
select substring(Email, charindex('@', Email) + 1, len(Email) - CHARINDEX('@', Email)) as EmailDomain from Person

alter table Employees
add Email nvarchar(20)

select * from Employees
update Employees set Email = 'tom@tom.com' where Id = 1

--lisame *-märgi alates teatud kohast
select FirstName, LastName, 
	SUBSTRING(Email, 1, 2) + replicate('*', 5) + ---peale teist tähemärki paneb viis tärni
	SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - charindex('@', Email) + 1) as Email
from Employees

select replicate('asd', 3)

--kuidas sisestada tühikut kahe nime vahele
select SPACE(5)

--tühikute arv kahe nime vahel
select FirstName + space(3) + LastName as FullName from Employees

--patindex
--sama mis charindex aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@pam.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@pam.com', Email) > 0

--- kõik .com-d asendatakse .net-ga
select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail from Employees 

--soovin asendada peale esimest märki kolm tähte viie tärniga
select FirstName, LastName, Email,
	stuff(Email, 2, 3, '*****') as StuffedEmail
from Employees

create table DateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTime

--konkreetse masina kellaaeg
select getdate(), 'GETDATE()'

insert into DateTime 
values (getdate(), getdate(), getdate(), getdate(), getdate(), getdate())

update DateTime set c_datetimeoffset = '2024-04-02 09:33:43.5866667 +10:00'
where c_datetimeoffset = '2024-04-02 09:33:43.5866667 +00:00'

--aja päring
select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP'
select SYSDATETIME(), 'SYSDATETIME' --täpsem
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' --aja tsooniga UTC
select GETUTCDATE(), 'GETUTCDATE' --UTC aeg

select ISDATE('asd') --tagastab 0 kuna string pole kp
select ISDATE(getdate()) --tagastab 1 kuna on kp
select ISDATE('2024-04-02 09:33:43.586') --tagastab 1 max 3 komakohaga
select DAY(GETDATE()) --annab tänase kp numbri
select DAY('2024-04-15') --annab stringis oleva kp ja järjestus peab olema õige
select DAY('04/15/2024')
select MONTH(GETDATE()) --annab kuu numbri
select YEAR(GETDATE()) --annab aasta numbri

select DATENAME(day, '2024-04-02 09:33:43.586') --annab stringis oleva päeva numbri
select DATENAME(weekday, '2024-04-12 09:33:43.586') --annab stringis oleva nädala päeva
select DATENAME(MONTH, '2024-04-02 09:33:43.586') --annab stringis oleva kuu sõnana

create table EmployeesWithDates
(
Id nvarchar(2),
Name nvarchar(20),
DateOfBirth datetime
)

select * from EmployeesWithDates

insert into EmployeesWithDates values
(1, 'Sam', '1980-12-30 00:00:00.000'), 
(2, 'Pam', '1982-09-01 12:01:36.260'), 
(3, 'John', '1985-08-22 12:03:30.370'), 
(4, 'Sara', '1979-11-29 12:59:30.670'), 
(5, 'Todd', '1978-11-29 12:59:30.670')

--kuidas võtta ühest veerust andmeid ja selle abil luua uusi andmeid
select Name, DateOfBirth, DATENAME(WEEKDAY, DateOfBirth) as [Day], --vaatab DoB veerust päeva ja kuvab päeva nimetuse sõnana
	   Month(DateOfBirth) as MonthNumber, --vaatab DoB veerust kp ja kuvab kuu numbri
	   DateName(MONTH, DateOfBirth) as [MonthName], --vaatab DoB veerust kuud ja kuvab sõnana
	   YEAR(DateOfBirth) as [Year] --võtab DoB veerust aasta
from EmployeesWithDates

select DATENAME(WEEKDAY, '1998-07-21') --minu sünni nädala päev

select DATEPART(WEEKDAY, '2024-04-02 09:33:43.586') --kuvab 3 kuna USA nädal algab pühapäevaga
select DATEPART(MONTH, '2024-04-02 09:33:43.586') --kuvab kuu nr
select DATEADD(DAY, 20, '2024-04-02 09:33:43.586') --liidab päevale antud numbri
select DATEADD(DAY, -20, '2024-04-02 09:33:43.586') --lahutab päevale antud numbri
select DATEDIFF(MONTH, '11/30/2023', '04/02/2024') --leiab kuude vahe kahel stringil
select DATEDIFF(YEAR, '11/30/2023', '04/02/2024') --leiab aasta vahe kahe stringi vahel

---
create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
		select @tempdate = @DOB

		select @years = DATEDIFF(year, @tempdate, getdate()) - case when (month(@DOB) > MONTH(GETDATE())) or (month(@DOB))
		= month(GETDATE()) and day(@DOB) > day(GETDATE()) then 1 else 0 end
		select @tempdate = dateadd(year, @years, @tempdate)

		select @months = DATEDIFF(MONTH, @tempdate, getdate()) - case when day(@DOB) > day(GETDATE()) then 1 else 0 end
		select @tempdate = DATEADD(MONTH, @months, @tempdate)

		select @days = DATEDIFF(DAY, @tempdate, GETDATE())

	declare @Age nvarchar(50)
		set @Age = cast(@years as nvarchar(4)) + ' Years ' + cast(@months as nvarchar(2)) + ' Months ' + cast(@days as nvarchar(2)) + ' Days old'
	return @Age
end

--saame vaadata kasutajate vanust
select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from EmployeesWithDates

-- kui kasutame seda funktsiooni, siis saame teada tänase päeva vahet stringis välja toodga
select dbo.fnComputeAge('11/20/2011')

--nr peale DOB muutujat näitab, et mismoodi kuvada DOB-d
select Id, Name, DateOfBirth, convert(nvarchar, DateOfBirth, 126) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id] from EmployeesWithDates

select cast(GETDATE() as date) --tänane kp
select convert(date, GETDATE()) --tänane kp

---matemaatilised funktsioonid

select ABS(-101.5) --absoluutväärtus
select ceiling(15.2) --ümardab üles
select ceiling(-15.2) --ümardab positiivsema arvu suunas
select floor(15.2) --ümardab alla poole
select floor(-15.2) --ümardab negatiivsema poole
select power(2, 4) --astendab 2, 4-ga 2x2x2x2
select square(9) --9 ruudus
select sqrt(81) --ruutjuur

select rand() --annab suvalise nr
select(floor(rand() * 100))

--iga kord näitab 10 suvalist nr-t
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
	print floor(rand() * 1000)
	set @counter = @counter + 1
end

select round(850.556, 2) --ümardab teise komakoha järgse numbrini
select round(850.556, 2, 1) --ümardab alla poole
select round(850.556, 0) --ümardab täisarvuni
select round(850.556,-2) --ümardab kaks kohta enne koma ehk tulemus 900

create function dbo.CalculateAge(@DOB date)
returns int
as begin
	declare @Age int

	set @Age = datediff(year, @DOB, GETDATE()) - 
		case
			when (month(@DOB) > MONTH(GETDATE())) or
				 (month(@DOB) > MONTH(GETDATE()) and day(@DOB) > day(GETDATE()))
			then 1
			else 0
			end
		return @Age
end

exec CalculateAge '10/08/2022'

--arvutab välja kui vana on isik ja võtab arvesse kuud ja päevad
--antud juhul näitab kõike, kes on üle 36a vanad
select Id, Name, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 36

alter table EmployeesWithDates
add DepartmentId int
alter table EmployeesWithDates
add Gender nvarchar(10)

--scalar funktsioon annab mingis vahemikus olevaid andmeid, aga
--inline table values ei kasuta begin ja end funktsioone
--scalar annab väärtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

--kõik female töötajad
select * from fn_EmployeesByGender('Female')

--kuidas saaks samat päringut täpsustada
select * from fn_EmployeesByGender('Female')
where Name = 'Pam'

--kahest erinevast tabelist andmete võtmine ja koos kuvamine
--esimene on funktsioon ja teine tabel
select Name, Gender, DepartmentName
from fn_EmployeesByGender('Male') E
join Department D on D.Id = E.DepartmentId