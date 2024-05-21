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
Id nvarchar(2) not null primary key,
Name nvarchar(20),
DateOfBirth datetime,
Gender nvarchar(10),
DepartmentId int
)

select * from EmployeesWithDates

insert into EmployeesWithDates values
(1, 'Sam', '1980-12-30 00:00:00.000', 'Male', 1), 
(2, 'Pam', '1982-09-01 12:01:36.260', 'Female', 2), 
(3, 'John', '1985-08-22 12:03:30.370', 'Male', 1), 
(4, 'Sara', '1979-11-29 12:59:30.670', 'Female', 3), 
(5, 'Todd', '1978-11-29 12:59:30.670', 'Male', 1)

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

--multi-table statement

--inline funktsioon
create function fn_GetEmployees()
returns table as
return (select Id, Name, cast(DateOfBirth as date)
		as DOB
		from EmployeesWithDates)

--kutsume välja funktsiooni
select * from fn_GetEmployees()

--multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
create function fn_MS_GetEmployees()
returns @Table Table (Id int, Name nvarchar(20), DOB date)
as begin
	insert into @Table
	select Id, Name, cast(DateOfBirth as date) from EmployeesWithDates
	return
end

select * from fn_MS_GetEmployees()

---inline tabeli funktsioonid on paremini töötamas kuna käsitletakse vaatena e. view
---multi puhul on pm tegemist store proceduriga ja kulutab ressurssi rohkem

update fn_GetEmployees() set Name = 'Sam1' where Id = 1 --saab muuta andmeid
select * from fn_MS_GetEmployees()
update fn_MS_GetEmployees() set Name = 'Sam2' where Id = 1 --ei saa muuta andmeid multistate puhul

--deterministic
select count(*) from EmployeesWithDates
select SQUARE(3) --kõik tehtemärgid on deterministlikud funktsioonid, sinna kuuluvad veel sum, avg ja square
--non-deterministic
select GETDATE()
select CURRENT_TIMESTAMP
select RAND() --see funktsioon saab olla mõlemas kategoorias, kõik oleneb sellest, kas sulgudes on 1 v ei ole

create function fn_GetNameById(@Id int)
returns nvarchar(30)
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

select dbo.fn_GetNameById(4)

drop table EmployeesWithDates

select * from EmployeesWithDates

create function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

sp_helptext fn_GetEmployeeNameById

--peale seda ei näe funktsiooni sisu
alter function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
with encryption
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

--muudame ülevalpool olevat funktsiooni, kindlasti tabeli ette panna dbo.TabeliNimi
alter function dbo.fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
with schemabinding
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

---temporary tables
---#-märgi ette panemisel saame aru, et tegemist on temp tabeliga
---seda tabelit saab ainult selles päringus avada
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails

select Name from sysobjects
where Name like '#PersonDetails%'

--kustutame temp tabeli
drop table #PersonDetails

create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--globaalse temp tabeli tegemine
create table ##PersonDetails(Id int, Name nvarchar(20))

---index
create table EmployeeWithSalary
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10)
)

insert into EmployeeWithSalary values (1, 'Sam', 2500, 'Male')
insert into EmployeeWithSalary values (2, 'Pam', 6500, 'Female')
insert into EmployeeWithSalary values (3, 'John', 4500, 'Male')
insert into EmployeeWithSalary values (4, 'Sara', 5500, 'Female')
insert into EmployeeWithSalary values (5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary

select * from EmployeeWithSalary
where Salary > 5000 and Salary < 7000

--loome indeksi, mis asetab palga kahanevasse järjestusse
create index IX_Employee_Salary
on EmployeeWithSalary (Salary desc)

--tahan vaadata indexi tulemust
select * from EmployeeWithSalary with(Index(IX_Employee_Salary))

drop index dbo.EmployeeWithSalary.IX_Employee_Salary

--saame teada, et mis on selle tabeli primaarvõti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

--saame vaadata tabelit koos selle sisuga alates väga detailsest infost
select
	TableName = t.name,
	IndexName = ind.name,
	IndexId = ind.index_id,
	ColumnId = ic.index_column_id,
	ColumnName = col.name,
	ind.*,
	ic.*,
	col.*
from
	sys.indexes ind
inner join
	sys.index_columns ic on ind.object_id = ic.object_id and ind.index_id = ic.index_id
inner join
	sys.columns col on ic.object_id = col.object_id and ic.column_id = col.column_id
inner join
	sys.tables t on ind.object_id = t.object_id
where
	ind.is_primary_key = 0
	and ind.is_unique = 0
	and ind.is_unique_constraint = 0
	and t.is_ms_shipped = 0
order by
	t.name, ind.name, ind.index_id, ic.is_included_column, ic.key_ordinal

create table EmployeeCity
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10),
City nvarchar(50)
)

insert into EmployeeCity values (3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values (1, 'Sam', 2500, 'Female', 'London')
insert into EmployeeCity values (4, 'Sara', 1500, 'Female', 'Tokyo')
insert into EmployeeCity values (5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values (2, 'Pam', 6000, 'Female', 'Sydney')

select * from EmployeeCity

--klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis
--ja seda saab klastrite puhul olla ainult üks

create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)

--annab veateate, et tabelis saab olla ainult üks klastris olev indeks
--kui soovid uut indeksit luua siis kustuta olemasolev

--saame luua ainult ühe klastris oleva indeksi tabeli peale
--klastris olev ideks on analoogne telefoni suunakoodile
select * from EmployeeCity
go
create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)
go
select * from EmployeeCity

---- indeksi tüübid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Veergude indeksid
--10. Välja arvatud veergudega indeksid

-- klastris olev indeks määrab ära tabelis oleva füüsilise järjestuse 
-- ja selle tulemusel saab tabelis olla ainult üks klastris olev indeks

drop table EmployeeWithSalary

create table EmployeeCity
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10),
City nvarchar(50)
)

insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Female', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6000, 'Female', 'Sydney')

select * from EmployeeCity

--klastris olevad indeksid dikteerivad s'ilitatud andmete j'rjestuse tabelis
-- ja seda saab klastrite puhul olla ainult [ks

create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)

-- annab veateate, et tabelis saab olla ainult [ks klastris olev indeks
-- kui soovid, uut indeksit luua, siis kustuta olemasolev

--- saame luua ainult ühe klastris oleva indeksi tabeli peale
--- klastris olev indeks on analoogne telefoni suunakoodile
select * from EmployeeCity
go
create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)
go
select * from EmployeeCity
-- kui teed select päringu sellele tabelile, siis peaksid nägema andmeid, mis on järjestatud selliselt:
-- Esimeseks võetakse aluseks Gender veerg kahanevas järjestuses ja siis Salary veerg tõusvas järjestuses

--- erinevused kahe indeksi vahel
--- 1. ainult üks klastris olev indeks saab olla tabeli peale, 
--- mitte-klastris olevaid indekseid saab olla mitu
--- 2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi viitama tabelile
--- Juhul, kui selekteeritud veerg ei ole olemas indeksis
--- 3. Klastris olev indeks määratleb ära tabeli ridade slavestusjärjestuse
--- ja ei nõua kettal lisa ruumi. Samas mitte klastris olevad indeksid on 
--- salvestatud tabelist eraldi ja nõuab lisa ruumi

create table EmployeeFirstName
(
	Id int,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

drop table EmployeeFirstName

exec sp_helpindex EmployeeFirstName

insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

drop index EmployeeFirstName.PK__Employee__3214EC07E148CFF5
--kui k'ivitad [levalpool oleva koodi, siis tuleb veateade
--- et SQL server kasutab UNIQUE indeksit jõustamaks väärtuste unikaalsust ja primaarvõtit
--- koodiga Unikaalseid Indekseid ei saa kustutada, aga käsitsi saab

insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

--- unikaalset indeksid kasutatakse kindlustamaks väärtuste unikaalsust (sh primaarvõtme oma)

create unique nonclustered index UIX_Employee_Firstname_Lastname
on EmployeeFirstName(FirstName, LastName)
--alguses annab veateate, et Mike Sandoz on kaks korda
--ei saa lisada mitte-klastris olevat indeksit kui ei ole unikaalseid andmeid
--kustutame tabeli ja sisestame andmed uuesti

truncate table EmployeeFirstName

insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(2, 'John', 'Menco', 2500, 'Male', 'London')

--lisame uue unikaalse piirangu
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstName_City
unique nonclustered(City)
--ei luba tabelisse väärtusega uut Londonit
insert into EmployeeFirstName values(3, 'John', 'Menco', 2500, 'Male', 'London')

--saab vaadata indeksite nimekirja
exec sp_helpconstraint EmployeeFirstName

-------------tekst vaja kopeerida githubist rida 1300-1307
--koodinäide:
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

insert into EmployeeFirstName values(3, 'John', 'Menco', 5500, 'Male', 'London')
insert into EmployeeFirstName values(4, 'John', 'Menco', 6500, 'Male', 'London1')
insert into EmployeeFirstName values(4, 'John', 'Menco', 7500, 'Male', 'London1')
--enne ignore käsku oleks kõik kolm tagasi lükatud, aga
--nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne

select * from EmployeeFirstName

---view

--view i=on salvestatud SQL-i päring. Saab käsitleda ka virtuaalse tabelina
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--teeme view
create view vEmployeesByDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--view päringu esile kutsumine
select * from vEmployeesByDepartment

------------kopeeri 1341-1347 githubist

--teeme view, kus näeb ainult IT-töötajaid
create view vEmployeesByDepartmentIT
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
where DepartmentName = 'IT'
--ülevalpool olevat päringut saab liigutada reataseme turvalisuse alla
--tahan ainult näidata IT osakonna töötajaid

select * from vEmployeesByDepartmentIT

--veeru taseme turvalisus
--peale selecti määratled veergude näitamise ära
create view vEmployeesInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeesInDepartmentSalaryNoShow

--saab kasutada esitlemaks koondandmeid ja üksikasjalikke andmeid
--view, mis tagastab summeeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, count(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

--kui soovide vaadata view sisu
sp_helptext vEmployeesCountByDepartment
--muutmine
alter view vEmployeesCountByDepartment
--kustutamine
drop view vEmployeesCountByDepartment

--view uuendused
--kas läbi view saab uuendada andmeid

---teeme andmete uuenduse, aga enne teeme view
create view vEmployeesDataExceptSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees

update vEmployeesDataExceptSalary
set [FirstName] = 'Tom' where Id = 2

--kustutame ja sisestame andmeid
delete from vEmployeesDataExceptSalary where Id = 2
insert into vEmployeesDataExceptSalary (Id, Gender, DepartmentID, FirstName)
values(2, 'Female', 2, 'Pam')

---indekseeritud view
--MS SQL-s on indekseeritud view nime all ja 
--Oracle-s materjaliseeritud view

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

insert into Product values
(1, 'Books', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10)

create table ProductSales
(
Id int,
QuantitySold int
)

insert into ProductSales values
(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3,12),
(4, 13),
(1, 11),
(2, 12),
(1, 14)

--loome view, mis annab meile veerud TotalSales ja TotalTransaction
create view vTotalSalesByProduct
with schemabinding
as
select Name, 
sum(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
COUNT_BIG(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name
------------------kopeerida 1458-1466


select * from vTotalSalesByProduct

--view piirangud
create view vEmployeeDetails
@Gender nvarchar(20)
as
select Id, FirstName, Gender, DepartmentId
from Employees
where Gender = @Gender
--viewsse ei saa kaasa panna parameetreid e antud juhul Gender

create function fnEmployeeDetails(@Gender nvarchar(20))
returns table
as return
(select Id, FirstName, Gender, DepartmentId
from dbo.Employees where Gender = @Gender)

--funktsiooni esile kutsumine koos parameetriga
select * from fnEmployeeDetails('male')

--order by kasutamine view-s
create view vEmployeeDetailsSorted
as
select Id, FirstName, Gender, DepartmentId
from Employees
order by Id
--order by-d ei saa kasutada 

--temp tabeli kasutamine
create table ##TestTempTable(Id int, FirstName nvarchar(20), Gender nvarchar(10))

insert into ##TestTempTable values
(101, 'Martin', 'Male'),
(102, 'Joe', 'Male'),
(103, 'Pam', 'Female'),
(104, 'James', 'Male')

create view vOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable
--temp tabelit ei saa kasutada view-s

---triggerid

------------------kopeerida 1515-1528

--loome uue tabeli
create table EmployeeAudit
(
Id int identity(1, 1) primary key,
AuditData nvarchar(1000)
)

--peale iga töötaja sisestamist tahame teada saada töötaja Id-d, päeva ning aega
--(millal sisestati). Kõik andmed lähevad EmployeeAudit tabelisse.

create trigger trEmployeeForInsert
on Employees
for insert 
as begin
declare @Id int
select @Id = Id from inserted
insert into EmployeeAudit
values ('New employee with id = ' + cast(@Id as nvarchar(5)) + ' is added at '
+ cast(getdate() as nvarchar(20)))
end

insert into Employees values 
(11, 'Bob', 'Blob', 'Bomb', 'Male', 3000, 1, 3, 'bob@bob.com')

select * from EmployeeAudit

--delete trigger
create trigger trEmployeeForDelete
on Employees
for delete
as begin
	declare @Id int
	select @Id = Id from deleted

	insert into EmployeeAudit
	values('An existing employee with Id = ' + cast(@Id as nvarchar(5)) + 
	' is deleted at ' + cast(getdate() as nvarchar(20)))
end

delete from Employees where Id = 11

select * from EmployeeAudit


--update trigger
create trigger trEmployeeForUpdate
on Employees
for update
as begin
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldManagerId int, @NewManagerId int
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldMiddleName nvarchar(20), @NewMiddleName nvarchar(20)
	declare @OldLastName nvarchar(20), @NewLastName nvarchar(20)
	declare @OldEmail nvarchar(20), @NewEmail nvarchar(20)

	--muutuja kuhu läheb lõpptekst
	declare @AuditString nvarchar(1000)

	--laeb kõik uuendatud andmed temp tabeli alla
	select * into #TempTable
	from inserted

	--käib läbi kõik andmed tabelis
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
		--selekteerib esimese rea andmed temp tabelist
		select top 1 @Id = Id, @NewGender = Gender, 
		@NewSalary = Salary, @NewDepartmentId = DepartmentId, 
		@NewManagerId = ManagerId, @NewFirstName = FirstName,
		@NewMiddleName = MiddleName, @NewLastName = LastName,
		@NewEmail = Email
		from #TempTable
		--võtab vanad andmed kustutatud tabelist
		select @OldGender = Gender,
		@OldSalary = Salary, @OldDepartmentId = DepartmentId,
		@OldManagerId = ManagerId, @OldFirstName = FirstName,
		@OldMiddleName = MiddleName, @OldLastName = LastName,
		@OldEmail = Email
		from deleted where Id = @Id

		--loob auditi stringi dünaamiliselt
		set @AuditString = 'Employee with Id = ' + cast(@Id as nvarchar(4)) + ' changed '
		if(@OldGender <> @NewGender)
			set @AuditString = @AuditString + ' Gender from ' + @OldGender + ' to ' + @NewGender
		if(@OldSalary <> @NewSalary)
			set @AuditString = @AuditString + ' Salary from ' + cast(@OldSalary as nvarchar(20)) + ' to ' + cast(@NewSalary as nvarchar(20))
		if(@OldDepartmentId <> @NewDepartmentId)
			set @AuditString = @AuditString + ' Department Id from ' + cast(@OldDepartmentId as nvarchar(20)) + 
			' to ' + cast(@NewDepartmentId as nvarchar(20))
		if(@OldManagerId <> @NewManagerId)
			set @AuditString = @AuditString + ' Manager Id from ' + 
			cast(@OldManagerId as nvarchar(20)) + ' to ' + cast(@NewManagerId as nvarchar(20))
		if(@OldFirstName <> @NewFirstName)
			set @AuditString = @AuditString + ' First Name from ' + @OldFirstName + ' to ' + @NewFirstName
		if(@OldMiddleName <> @NewMiddleName)
			set @AuditString = @AuditString + ' Middle Name from ' + @OldMiddleName + ' to ' + @NewMiddleName
		if(@OldLastName <> @NewLastName)
			set @AuditString = @AuditString + ' Last Name from ' + @OldLastName + ' to ' + @NewLastName
		if(@OldEmail <> @NewEmail)
			set @AuditString = @AuditString + ' Email from ' + @OldEmail + ' to ' + @NewEmail

		insert into dbo.EmployeeAudit values (@AuditString)
		--kustutab temp tabel-st rea, et saaksime liikuda uue rea juurde
		delete from #TempTable where Id = @Id
	end
end

update Employees set 
FirstName = 'test123', 
Salary = 4000, 
MiddleName = 'test456',
Email = 'test@test.com'
where Id = 10

select * from Employees
select * from EmployeeAudit

---instead of trigger

create table Employee
(
Id int primary key,
Name nvarchar(30),
Gender nvarchar(10),
DepartmentId int
)

create table Departments
(
Id int primary key,
DepartmentName nvarchar(20)
)

insert into Employee values (1, 'John', 'Male', 3), 
(2, 'Mike', 'Male', 2), 
(3, 'Pam', 'Female', 1), 
(4, 'Todd', 'Male', 4), 
(5, 'Sara', 'Female', 1), 
(6, 'Ben', 'Male', 3)

insert into Departments values 
(1, 'IT'),
(2, 'Payroll'),
(3, 'HR'),
(4, 'Other Department')

---
create view vEmployeeDetails
as
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Departments
on Employee.DepartmentId = Departments.Id

insert into vEmployeeDetails values (7, 'Valarie', 'Female', 'IT')
--tuleb veateade
--nüüd vaatame kuidas saab instead of triggeriga seda probleemi lahendada

--muudab igat isendit kus DeptId on sama
create trigger tr_vEmployeeDetails_InsteadOfInsert
on vEmployeeDetails
instead of insert 
as begin
	declare @DeptId int

	select @DeptId = dbo.Departments.Id
	from Departments
	join inserted
	on inserted.DepartmentName = Departments.DepartmentName

	if(@DeptId is null)
		begin
		raiserror('Invalid department name. Statement terminated', 16, 1)
		return
	end

	insert into dbo.Employee(Id, Name, Gender, DepartmentId)
	select Id, Name, Gender, @DeptId
	from inserted
end

---raiserror funktsioon
--selle eesmärk on tuua väja veateada kui DepartmentName veerus ei ole väärtust
--ja ei klapi uue sisestatud väärtusega

--Esimene on parameeter  veateate sisust. Teine on veataseme nr (nr 16 tähendab üldiseid vigu).
--Kolmas on olek

update vEmployeeDetails
set Name = 'Johnny', DepartmentName = 'IT'
where Id = 1
--ei saa uuendada andmeid kuna mitu tabelit on sellest mõjutatud
update vEmployeeDetails
set DepartmentName = 'HR'
where Id = 3

select * from vEmployeeDetails


create trigger tr_vEmployeeDetails_InsteadOfUpdate
on vEmployeeDetails
instead of update
as begin
	
	if(update(Id))
	begin
		raiserror('Id cannot be changed', 16, 1)
		return
	end

	if(update(DepartmentName))
	begin
		declare @DeptId int
		select @DeptId = Departments.Id
		from Departments
		join inserted
		on inserted.DepartmentName = Departments.DepartmentName

		if(@DeptId is null)
		begin
			raiserror('Id cannot be changed', 16, 1)
			return
		end

		update Employee set DepartmentId = @DeptId
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end

	if(update(Gender))
	begin
		update Employee set Gender = inserted.Gender
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end

	if(update(Name))
	begin
		update Employee set Name = inserted.Name
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end
end

--nüüd muudab ainult Employees tabelis olevaid andmeid.			
update Employee set Name = 'John123', Gender = 'Male', DepartmentId = 3
where Id = 1

select * from vEmployeeDetails

---delete trigger
create view vEmployeeCount
as
select DepartmentId, DepartmentName, count(*) as TotalEmployees
from Employee
join Departments
on Employee.DepartmentId = Departments.Id
group by DepartmentName, DepartmentId

select * from vEmployeeCount
--näitab ära osakonnad, kus on töötajaid 2 tk või rohkem
select DepartmentName, TotalEmployees from vEmployeeCount
where TotalEmployees >= 2

select DepartmentName, DepartmentId, count(*) as TotalEmployees
into #TempEmployeeCount
from Employee
join Departments
on Employee.DepartmentId = Departments.Id
group by DepartmentName, DepartmentId

select * from #TempEmployeeCount

alter view vEmployeeDetails
as
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Departments
on Employee.DepartmentId = Departments.Id

delete from vEmployeeDetails where Id = 2
--ei tööta kuna mitut tabelit vaja muuta

create trigger tr_vEmployeeDetails_InsteadOfDelete
on vEmployeeDetails
instead of delete
as begin
	delete Employee
	from Employee
	join deleted
	on Employee.Id = deleted.Id
end

--nüüd käivitub järgnev kood
delete from vEmployeeDetails where Id = 2


---päritud tabelid ja CTE
--CTE tähendab common table expression

select * from Employee

truncate table Employee

insert into Employee values
(1, 'John', 'Male', 3),
(2, 'Mike', 'Male', 2)

--CTE
with EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as
	(
	select DepartmentName, DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId
	)
select DepartmentName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 1
--CTEd võivad sarnaneda temp tabeliga
--sarnane päritud tabelile ja ei ole salvestatud objektina
--ning kestab päringu ulatuses

--päritud tabel
select DepartmentName, TotalEmployees
from
(
select DepartmentName, DepartmentId, count(*) as TotalEmployees
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId
)
as EmployeeCount
where TotalEmployees >= 1

--mitu CTEd järjest
with EmployeeCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
(
	select DepartmentName, count(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	where DepartmentName in('Payroll', 'IT')
	group by DepartmentName
),
--peale koma panemist saad uue CTE juurde kirjutada
EmployeeCountBy_HR_Admin_Dept(DepartmentName, Total)
as
(
	select DepartmentName, count(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName
)
--kui on kaks CTEd siis unioni abil ühendab päringu
select * from EmployeeCountBy_Payroll_IT_Dept
union
select * from EmployeeCountBy_HR_Admin_Dept

---
with EmployeeCount(DepartmentId, TotalEmployees)
as
	(
	select DepartmentId, count(*) as TotalEmployees
	from Employee
	group by DepartmentId
	)
--peale CTEd peab kohe tulema käsklus SELECT, INSERT, UPDATE või DELETE
--kui proovid midagi muud, siis tuleb veateade
select * from EmployeeCount


--uuendamine CTEs

with Employee_Name_Gender
as
(
	select Id, Name, Gender from Employee
)
update Employee_Name_Gender set Gender = 'Female' where Id = 1

select * from Employee

--kasutame joini CTE tegemisel
with EmployeeByDepartment
as
(
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Department.Id = Employee.DepartmentId
)
select * from EmployeeByDepartment

--kasutame joini ja muudame ühes tabelis andmeid
with EmployeeByDepartmentUpdate
as
(
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Department.Id = Employee.DepartmentId
)
update EmployeeByDepartmentUpdate set Gender = 'Male' where Id = 1

--kasutame joini ja muudame mõlemas tabelis andmeid
with EmployeeByDepartmentUpdateBothTables
as
(
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Department.Id = Employee.DepartmentId
)
update EmployeeByDepartmentUpdateBothTables set Gender = 'Male', DepartmentName = 'IT' where Id = 1
--ei luba mitut tabelit muuta korraga

---------------------------------------kopeerida 1985-1993

truncate table Employee

---------------------------------------kopeerida 1997-2005 ja runnida


insert into Employee values (1, 'Tom', 2)
insert into Employee values (2, 'Josh', null)
insert into Employee values (3, 'Mike', 2)
insert into Employee values (4, 'John', 3)
insert into Employee values (5, 'Pam', 1)
insert into Employee values (6, 'Mary', 3)
insert into Employee values (7, 'James', 1)
insert into Employee values (8, 'Sam', 5)
insert into Employee values (9, 'Simon', 1)

--self joiniga saab sama tulemuse, mis CTEga
--ja kuvada NULL veeru asemel Super Boss
select Emp.Name as [Employee Name],
ISNULL(Manager.Name, 'Super Boss') as [Manager Name]
from dbo.Employee Emp
left join Employee Manager
on Emp.DepartmentId = Manager.Id

--teeme samatulemusliku päringu
with EmployeesCTE(Id, Name, DepartmentId, [Level])
as
(
	select Employee.Id, Name, DepartmentId, 1
	from Employee
	where DepartmentId is null

	union all

	select Employee.Id, Employee.Name, 
	Employee.DepartmentId, EmployeesCTE.[Level] + 1
	from Employee
	join EmployeesCTE
	on Employee.DepartmentId = EmployeesCTE.Id
)
select EmpCTE.Name as Employee, isnull(MgrCTE.Name, 'SuperBoss') as Manager,
EmpCTE.[Level]
from EmployeesCTE EmpCTE
left join EmployeesCTE MgrCTE
on EmpCTE.DepartmentId = MgrCTE.Id

create table ProductSales
(
	SalesAgent nvarchar(50),
	SalesCountry nvarchar(50),
	SalesAmout int
)

insert into ProductSales values
('Tom', 'UK', 200),
('John', 'US', 180),
('John', 'UK', 260),
('David', 'India', 450),
('Tom', 'India', 350),
('David', 'US', 200),
('Tom', 'US', 130),
('John', 'India', 540),
('John', 'UK', 120),
('David', 'UK', 220),
('John', 'UK', 420),
('David', 'US', 320),
('Tom', 'US', 340),
('Tom', 'UK', 660),
('John', 'India', 430),
('David', 'India', 230),
('David', 'India', 280),
('Tom', 'UK', 480),
('John', 'US', 360),
('David', 'UK', 140)

select SalesCountry, SalesAgent, SUM(SalesAmount) as Total
from ProductSales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

--pivot näide
select SalesAgent, India, US, UK
from ProductSales
pivot
(
	sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTable

--päring muudab unikaalsete veergude väärtust(India, US ja UK) SalesCountry veerus
--omaette veergudeks koos veergude SalesAmount liitmisega

create table ProductSalesWithId
(
	Id int primary key,
	SalesAgent nvarchar(50),
	SalesCountry nvarchar(50),
	SalesAmount int
)

insert into ProductSalesWithId values
(1, 'Tom', 'UK', 200),
(2, 'John', 'US', 180),
(3, 'John', 'UK', 260),
(4, 'David', 'India', 450),
(5, 'Tom', 'India', 350),
(6, 'David', 'US', 200),
(7, 'Tom', 'US', 130),
(8, 'John', 'India', 540),
(9, 'John', 'UK', 120),
(10, 'David', 'UK', 220),
(11, 'John', 'UK', 420),
(12, 'David', 'US', 320),
(13, 'Tom', 'US', 340),
(14, 'Tom', 'UK', 660),
(15, 'John', 'India', 430),
(16, 'David', 'India', 230),
(17, 'David', 'India', 280),
(18, 'Tom', 'UK', 480),
(19, 'John', 'US', 360),
(20, 'David', 'UK', 140)

select SalesAgent, India, US, UK
from ProductSalesWithId
pivot
(
	sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTable
--põhjuseks on Id veeru olemasolu ProductSalesWithId tabelis, mida
--võetakse arvesse pööramise ja grupeerimise järgi

select SalesAgent, India, US, UK
from
(
	select SalesAgent, SalesCountry, SalesAmount from ProductSalesWithId
)
as SourceTable
pivot
(
	sum(SalesAmount) for SalesCountry in (India, US, UK)
)
as PivotTable
--see päring liidab jälle kõik kokku nimede kohta aga Id-ga tabelis


--teha üks UNPIVOT tabeliga ProductSalesWithId
--ChatGPT versioon
SELECT Id,
       UnpivotedColumn AS SalesType,
       UnpivotedValue AS SalesValue
FROM 
   (SELECT Id, SalesAgent, SalesCountry, CAST(SalesAmount AS nvarchar(50)) AS SalesAmount
    FROM ProductSalesWithId) AS SourceTable
UNPIVOT
   (UnpivotedValue FOR UnpivotedColumn IN 
      (SalesAgent, SalesCountry, SalesAmount)
) AS UnpivotedTable;


--õpetaja versioon
select Id, FromAgentOrCountry, CountryOrAgent
from
(
	select Id, SalesAgent, SalesCountry, SalesAmount
	from ProductSalesWithId
)
as SourceTable
unpivot
(
	CountryOrAgent for FromAgentOrCountry in (SalesAgent, SalesCountry)
)
as PivotTable

---transactions
--transaction jälgib järgmisi samme:
--1. selle algus
--2. käivitab andmebaasi käske
--3. kontrollib vigu. Kui on viga, siis taastab algse oleku

create table MailingAddress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(50),
	StreetAddress nvarchar(50),
	City nvarchar(20),
	PostalCode nvarchar(20)
)

insert into MailingAddress values
(1, 101, '#10', 'King Street', 'London', 'CR27DW')

create table PhysicalAddress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(50),
	StreetAddress nvarchar(50),
	City nvarchar(20),
	PostalCode nvarchar(20)
)

insert into PhysicalAddress values
(1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

---
create proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end
exec spUpdateAddress

--muudame sp-d nimega spUpdateAddress
alter proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON12'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDONLONDONLONDONLONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end
exec spUpdateAddress
go
select * from MailingAddress
select * from PhysicalAddress
--kui teine uuendus ei lähe läbi siis esimene ei lähe ka läbi (liiga pikk >20)
--kõik uuendused peavad läbi minema

--transaction ACID test
-------------------------kopeerida 2237-2262

---subqueries
create table Product
(
	Id int identity primary key,
	Name nvarchar(50),
	Description nvarchar(250)
)

create table ProductSales
(
	Id int primary key identity,
	ProductId int foreign key references Product(Id),
	UnitPrice int,
	QuantitySold int
)

insert into Product values
('TV', '52 inch black color OLED TV'),
('Laptop', 'Very thin black color laptop'),
('Desktop', 'HP high performance desktop')

insert into ProductSales values
(3, 450, 5),
(2, 250, 7),
(3, 450, 4),
(3, 450, 9)

select * from Product
select * from ProductSales

--kirjutame päringu, mis annab infot müümata toodetest
select Id, Name, Description
from Product
where Id not in (select distinct ProductId from ProductSales)

--enamus juhtudel saab subqueryt asendada JOIN-ga
--teeme sama päringu JOIN-ga
select Product.Id, Name, Description
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null

--teeme subquery, kus kasutame select-i. Kirjutame päringu,
--kus saame teada Name ja TotalQuantity veeru andmed
select Name,
(select sum(QuantitySold) from ProductSales where ProductId = Product.Id)
as [Total Quantity]
from Product
order by Name

--sama tulemus JOINga
select Name, sum(QuantitySold) as TotalQuantity
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
group by Name
order by Name

--subqueryt saab subquery sisse panna
--subquerid on alati sulgudes ja neid nimetatakse sisemiseteks päringuteks

----------------------------------rohkete andmetega testimise tabel
alter table ProductSales
drop constraint FK__ProductSa__Produ__29221CFB
truncate table ProductSales
go
truncate table Product
truncate table ProductSales

---sisestame näidisandmed Product tabelisse
declare @Id int
set @Id = 1
while(@Id <= 30000)
begin
	insert into Product values('Product - ' + cast(@Id as nvarchar(20)),
	'Product - ' + cast(@Id as nvarchar(20)) + ' Description')

	print @Id
	set @Id = @Id + 1
end

declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int
--ProductId
declare @LowerLimitForProductId int
declare @UpperLimitForProductId int

set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 100000000
--UnitPrice
declare @LowerLimitForUnitPrice int
declare @UpperLimitForUnitPrice int

set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 200
--QuantitySold
declare @LowerLimitForQuantitySold int
declare @UpperLimitForQuantitySold int

set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 100

declare @Counter int
set @Counter = 1

while(@Counter <= 450000)
begin
	select @RandomProductId = round(((@UpperLimitForProductId -
	@LowerLimitForProductId) * Rand() + @LowerLimitForProductId), 0)

	select @RandomUnitPrice = round(((@UpperLimitForUnitPrice -
	@LowerLimitForUnitPrice) * Rand() + @LowerLimitForUnitPrice), 0)

	select @RandomQuantitySold = round(((@UpperLimitForQuantitySold -
	@LowerLimitForQuantitySold) * Rand() + @LowerLimitForQuantitySold), 0)

	insert into ProductSales values 
	(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

	print @Counter
	set @Counter = @Counter + 1
end

select * from Product
select * from ProductSales
select count(*) from Product
select count(*) from ProductSales

--võrdleme subquery-t ja join-i
select Id, Name, Description
from Product
where Id in
(select Product.Id from ProductSales)
--päring tehti 1min ära

--teeme cache puhtaks, et uut päringut ei oleks kuskile vahemällu salvestatud
checkpoint; 
go
dbcc DROPCLEANBUFFERS; --puhastab päringu cache-i
go
dbcc FREEPROCCACHE; --puhastab täitva planeeritud cahce-i
go

--teeme sama tabeli peale inner join päringu
select distinct Product.Id, Name, Description
from Product
inner join ProductSales
on Product.Id = ProductSales.ProductId
--päring tehti 1 sek
--järeldus: join on kiirem kui subquery
--teeme cache puhtaks

select Id, Name, Description
from Product
where not exists(select * from ProductSales where ProductId = Product.Id)
--44sek
--teeme vahemälu puhtaks

--kasutame left join-i
select Product.Id, Name, Description from Product
left join ProductSales on
Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null
--41sek

---CURSOR
-----------------------kopeertida rida 2432-2434

select ProductId from ProductSales
update ProductSales set UnitPrice = 50 where ProductSales.ProductId = 67042748

-----------------------kopeertida rida 2438-2448

declare @ProductId int
--deklareerime cursori
declare ProductIdCursor cursor for
select ProductId from ProductSales
--open avaldusega täidab select avaldust
--ja sisestab tulemuse
open ProductIdCursor

fetch next from ProductIdCursor into @ProductId
--kui tulemuses on veel ridu, siis @@FETCH_STATUS on 0
while(@@FETCH_STATUS = 0)
begin
	declare @ProductName nvarchar(50)
	select @ProductName = Name from Product where Id = @ProductId

	if(@ProductName = 'Product - 53931046')
	begin
		update ProductSales set UnitPrice = 55 where ProductId = @ProductId
	end

	else if(@ProductName = 'Product - 54850217')
	begin
		update ProductSales set UnitPrice = 65 where ProductId = @ProductId
	end

	else if(@ProductName = 'Product - 64894975')
	begin
		update ProductSales set UnitPrice = 1000 where ProductId = @ProductId
	end

	fetch next from ProductIdCursor into @ProductId
end
--vabastab rea seadistuse e suleb cursor-i
close ProductIdCursor
--vabastab ressursid, mis on seotud cursor-iga
deallocate ProductIdCursor

---vaatame kas read on uuendatud
select Name, Unitprice from Product join
ProductSales on Product.Id = ProductSales.ProductId
where(Name = 'Product - 53931046' or Name = 'Product - 54850217' or Name = 'Product - 64894975')

--asendame cursor-id JOIN-ga
update ProductSales
set UnitPrice = 
	case
		when Name = 'Product - 1' then 155
		when Name = 'Product - 2' then 165
		when Name = 'Product - 3' then 1000
	end
from ProductSales
join Product
on Product.Id = ProductSales.ProductId
where Name = 'Product - 1' or Name = 'Product - 2' or Name like 'Product - 3'

select Name from Product

---tabelite info
--nimekiri tabelitest
select * from SYSOBJECTS where xtype = 'S'
select * from sys.tables
--nimekiri tabelitest ja view-st
select * from INFORMATION_SCHEMA.TABLES

--kui soovide erinevaid objektitüüpe vaadata, siis kasuta XTYPE süntaksit
select distinct XTYPE from sysobjects

----------------------kopeerida 2521-2527

--annab teada kas selle nimega tabel on juba olemas
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Employee')
begin
	create table Employee
	(
		Id int primary key,
		Name nvarchar(30),
		DepartmentId int
	)

	print 'Table created'
end
	else
begin
	print 'Table already exists'
end

--saab kasutada sisseehitatud funktsiooni: OBJECT_ID()
if OBJECT_ID('Employee') is null
begin
	print 'Table created'
end
else
begin
	print 'Table exists'
end

--tahame sama nimega tabelit ära kustutada ja siis uuesti luua
if OBJECT_ID('Employee') is not null
begin
	drop table Employee
end
create table Employee
(
	Id int primary key,
	Name nvarchar(30),
	ManagerId int
)

alter table Employee 
add Email nvarchar(50)

--kui uuesti käivitatakse veeru kontrollimist ja loomist
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where
COLUMN_NAME = 'Email' and TABLE_NAME = 'Employee' and TABLE_SCHEMA = 'dbo')
begin
	alter table Employee
	add Email nvarchar(50)
end
else
begin
	print 'Column already exists'
end

--kontrollime kas mingi nimega veerg on olemas
if COL_LENGTH('Employee', 'Email') is not null
begin
	print 'Column already exists'
end
else
begin
	print 'Column does not exist'
end

---MERGE
--tutvustati aastal 2008, mis lubab teha sisestamist, uuendamist ja kustutamist
--ei pea kasutama mitut käsku

--merge puhul peab alati olema vähemalt kaks tabelit:
--1. algallika tabel e source table
--2. sihtmärk tabel e target table

--ühendab sihttabeli lähtetabeliga ja kasutab mõlemas tabelis ühist veergu
--koodinäide:

--------------------kopeerida 2604-2612
create table StudentSource
(
Id int primary key,
Name nvarchar(20)
)
go
insert into StudentSource values
(1, 'Mike'),
(2, 'Sara')
go
create table StudentTarget
(
Id int primary key,
Name nvarchar(20)
)
insert into StudentTarget values
(1, 'Mike M'),
(3, 'John')
go
-------------------------------kopeerida 2634-2638
merge StudentTarget as T
using StudentSource as S
on T.Id = S.Id
when matched then
	update set T.Name = S.Name
when not matched by target then
	insert (Id, Name) values (S.Id, S.Name)
when not matched by source then
	delete;
go
select * from StudentSource
select * from StudentTarget

--tabelid sisust tühjaks
truncate table StudentTarget
truncate table StudentSource

insert into StudentSource values
(1, 'Mike'),
(2, 'Sara')

insert into StudentTarget values
(1, 'Mike M'),
(3, 'John')

merge StudentTarget as T
using StudentSource as S
on T.Id = S.Id
when matched then
	update set T.Name = S.Name
when not matched by target then
	insert (Id, Name) values (S.Id, S.Name);


---transactionid

------------------------kopeerida 2678-82

create table Account
(
Id int primary key,
AccountName nvarchar(25),
Balance int
)

insert into Account values
(1, 'Mark', 1000),
(2, 'Mary', 1000)

begin try
	begin transaction
		update Account set Balance = Balance - 100 where Id = 1
		update Account set Balance = Balance + 100 where Id = 2
	commit transaction
	print 'Transaction Committed'
end try
begin catch
	rollback tran
	print 'Transaction rolled back'
end catch
go
select * from Account

----------------------2709-2732

--dirty read näide
create table Inventory
(
Id int identity primary key,
Product nvarchar(100),
ItemsInStock int
)
go
insert into Inventory values
('iPhone', 10)
select * from Inventory

--esimene käsklus
--esimene transaction
begin tran
	update Inventory set ItemsInStock = 9 where Id = 1
	--kliendile tuleb arve
	waitfor delay '00:00:15'
	--ebapiisav saldojääk, teeb rollbacki
	rollback tran

--teine käsklus
--samal ajal tegin uue päringuga akna,
--kus kohe peale esimest käivitan teise
--teine transaction
set tran isolation level read uncommitted
select * from Inventory where Id = 1

--kolmas käsklus
--nüüd panen käima selle käskluse
select * from Inventory (nolock)
where Id = 1

select * from Inventory

--tran 1
set tran isolation level repeatable read

begin tran
declare @ItemsInStock int

select @ItemsInStock = ItemsInStock
from Inventory where Id = 1

waitfor delay '00:00:10'
set @ItemsInStock = @ItemsInStock - 1

update Inventory 
set ItemsInStock = @ItemsInStock where Id = 1

print @ItemsInStock
commit tran

--samal ajal panen tööle teisest päringust teise transactioni

set tran isolation level repeatable read
begin tran
declare @ItemsInStock int

select @ItemsInStock = ItemsInStock
from Inventory where Id = 1
waitfor delay '00:00:01'
set @ItemsInStock = @ItemsInStock - 2

update Inventory
set ItemsInStock = @ItemsInStock where Id = 1

print @ItemsInStock
commit tran

--non-repeatable näide

--------------------------2814-16

--esimene tran
--set tran isolation level repeatable read
begin tran
select ItemsInStock from Inventory where Id = 1
waitfor delay '00:00:10'
select ItemsInStock from Inventory
where Id = 1
commit tran

--nüüd käivitan teise tran teisel ekraanil
update Inventory set ItemsInStock = 10 where Id = 1

--phantom read
create table Employee
(
Id int primary key,
Name nvarchar(25)
)
go
insert into Employee values
(1, 'Mark'),
(3, 'Sara'),
(100, 'Mary')

select * from Employee
--tran 1
set tran isolation level serializable

begin tran
select * from Employee where Id between 1 and 3
waitfor delay '00:00:10'
select * from Employee where Id between 1 and 3
commit tran

--vastuseks tuleb: Mark ja Sara; Marcust ei näita aga peaks

----------------------------2864-69

---DEADLOCK
--kui andmebaasis tekib ummikseis
create table TableA
(
Id int identity primary key,
Name nvarchar(50)
)

insert into TableA values('Mark')
go
create table TableB
(
Id int identity primary key,
Name nvarchar(50)
)

insert into TableB values('Mary')

--tran 1
--samm nr 1
begin tran
update TableA set Name = 'Mark Transaction 1' where Id = 1

--samm nr 3
update TableB set Name = 'Mary Transaction 1' where Id = 1

commit tran
--teine server
--samm nr 2
begin tran
update TableA set Name = 'Mark Transaction 2' where Id = 1

--samm nr 4
update TableB set Name = 'Mary Transaction 2' where Id = 1
commit tran
truncate table TableB

select * from TableA
select * from TableB

-----------------------------------------2910-40
truncate table TableA
truncate table TableB

insert into TableA values
('Mark'),
('Ben'),
('Todd'),
('Pam'),
('Sara')

insert into TableB values
('Mary')

--tran 1
--samm 1
begin tran
update TableA set Name = Name + 
' Transaction 1' where Id in (1, 2, 3, 4, 5)

--samm 3
update TableB set Name = Name + 
' Transaction 1' where Id = 1

--samm 5
commit tran

--teine server
--samm 2
set deadlock_priority high
go
begin tran
update TableB set Name = Name + ' Transaction 1'

--samm 4
update TableA set Name = Name + ' Transaction 1' where Id
in (1, 2, 3, 4, 5)

--samm 6
commit tran
--teine server end

truncate table TableA
truncate table TableB

---
insert into TableA values ('Mark')
insert into TableB values ('Mary')

create proc spTransaction1
as begin
	begin tran
	update TableA set Name = 'Mark Transaction 1' where Id = 1
	waitfor delay '00:00:05'
	update TableB set Name = 'Mary Transaction 1' where Id = 1
	commit tran
end

create proc spTransaction2
as begin
	begin tran
	update TableB set Name = 'Mark Transaction 2' where Id = 1
	waitfor delay '00:00:05'
	update TableA set Name = 'Mary Transaction 2' where Id = 1
	commit tran
end

exec spTransaction1
exec spTransaction2

---errorlogi kuvamine
exec sp_readerrorlog

select OBJECT_NAME([object_id])
from sys.partitions
where hobt_id = 844424935768064

select * from sys.partitions

--deadlocki vea käsitlemine try ja catchiga
alter proc spTransaction1
as begin
	begin tran
	begin try
		update TableA set Name = 'Mark Transaction 1' where Id = 1
		waitfor delay '00:00:05'
		update TableB set Name = 'Mary Transaction 1' where Id = 1
		commit tran
		select 'Transaction Successful'
	end try
	begin catch
		--vaatab kas see error on deadlocki oma
		if(ERROR_NUMBER() = 1205)
		begin
			select 'Deadlock. Transaction failed. Please retry'
		end

		rollback
	end catch
end

exec spTransaction1
--teine server begin
alter proc spTransaction2
as begin
	begin tran
	begin try
		update TableB set Name = 'Mark Transaction 2' where Id = 1
		waitfor delay '00:00:05'
		update TableA set Name = 'Mary Transaction 2' where Id = 1
		commit tran
		select 'Transaction Successful'
	end try
	begin catch
		--vaatab kas see error on deadlocki oma
		if(ERROR_NUMBER() = 1205)
		begin
			select 'Deadlock. Transaction failed. Please retry'
		end

		rollback
	end catch
end

exec spTransaction2
--teine server end
exec sp_readerrorlog

begin tran
update TableA set Name = 'Mark Transaction 1' where Id = 1
--teise serverisse
select count(*) from TableA
delete from TableA where Id = 1
truncate table TableA
drop table TableA
--end teine server
commit tran

SELECT
    [s_tst].[session_id],
    [s_es].[login_name] AS [Login Name],
    DB_NAME (s_tdt.database_id) AS [Database],
    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
    [s_est].text AS [Last T-SQL Text],
    [s_eqp].[query_plan] AS [Last Plan]
FROM
    sys.dm_tran_database_transactions [s_tdt]
JOIN
    sys.dm_tran_session_transactions [s_tst]
ON
    [s_tst].[transaction_id] = [s_tdt].[transaction_id]
JOIN
    sys.[dm_exec_sessions] [s_es]
ON
    [s_es].[session_id] = [s_tst].[session_id]
JOIN
    sys.dm_exec_connections [s_ec]
ON
    [s_ec].[session_id] = [s_tst].[session_id]
LEFT OUTER JOIN
    sys.dm_exec_requests [s_er]
ON
    [s_er].[session_id] = [s_tst].[session_id]
CROSS APPLY
    sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
OUTER APPLY
    sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]
ORDER BY
    [Begin Time] ASC;
GO