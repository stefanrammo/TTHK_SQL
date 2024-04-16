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

--v��rv�tme �henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisetad uue rea andmeid ja ei ole sisestanud GenderId-d,
--siis see automaatselt sisestatakse sellele reale v��rtusega 3 (unknown)
alter table Person
add constraint DF_persons_GenderId
default 3 for GenderId

--sisestame andmed default v��rtusega GenderId's
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

--k�ik kes elavad Gotham linnas
select * from Person where City = 'Gotham'
--k�ik kes ei ela Gothamis
select * from Person where City != 'Gotham'
--k�ik kes ei ela Gothamis
select * from Person where City <> 'Gotham'
--k�ik kes ei ela Gothamis
select * from Person where not City = 'Gotham'

--n�itab teatud vanusega inimesi
select * from Person where Age = 120 or Age = 35 or Age = 19
--n�itab teatud vanusega inimesi
select * from Person where Age in (120, 35, 19)

--n�itab teatud vanuse vahemikus inimesi (kaasa arvatud)
select * from Person where Age between 18 and 31

--wildcard ehk n�itab k�ik g-t�hega algavad linnad
select * from Person where City like 'g%'
--k�ik emailid kus on @ m�rk sees
select * from Person where Email like '%@%'

--n�itab emaile kus ei ole @ sees
select * from Person where Email not like '%@%'

--n�itab kellel on emailis ees ja peale @ m�rki ainult �ks t�ht
select * from Person where Email like '_@_.com'

--n�itab 3 m�rki enne ja peale @ emailis
update Person
set Email = 'bat@bat.com'
where Id = 3
select * from Person where Email like '___@___.com'

--k�ik kellel nimes ei ole esimene t�ht w, a, c
select * from Person where Name like '[^WAC]%'

--kes elavad Gothamis ja New Yorkis
select * from Person where City = 'Gotham' or City = 'New York'

--k�ik kes elavad v�lja toodud linnades ja on vanemad kui 29
select * from Person where City = 'Gotham' or City = 'New York' and Age > 29

--kuvab t�hestikulises j�rjekorras inimesi ja v�tab aluseks nime
select * from Person order by Name
--kuvab vastupidi
select * from Person order by Name DESC

--v�tab kolm esimest rida
select top 3 * from Person

--v�tab kolm esimest rida, veergudega Age ja Name
select top 3 Age, Name from Person

--n�ita esimene 50% tabelist
select top 50 percent * from Person

--j�rjesta vanuse j�rgi isikud
select * from Person order by cast(Age as int)

--k�ikide isikute koondvanus
select sum(cast(Age as int)) from Person

--kuvab k�ige nooremat
select min(cast(Age as int)) from Person
--kuvab k�ige vanemat
select max(cast(Age as int)) from Person

--n�eme konkreetsetes linnades olevate isikute koondvanust
select City, sum(cast(Age as int)) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmet��pi ja selle pikkust
ALTER TABLE Person ALTER COLUMN Age int

--kuvab esimeses reas vlja toodud j�rjestuses ja muudab Age-i TotalAge-ks
--j�rjestab City-s olevate nimede j�rgi ja siis GenderId j�rgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

insert into Person values
(11, 'Robin', 'robin@r.com', 1, 29, 'Gotham')

--n�itab ridade arvu tabelis
select count(*) from Person
select * from Person

--n�itab tulemust, et mitu inimest on GenderId v��rtusega 1 konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total Person(s)]
from Person
where GenderId = '1'
group by GenderId, City

--n�itab �ra inimeste koondvanuse kui on suurem kui 41 ja kui palju igas linnas, eristab soo j�rgi
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

--arvutab k�ikide palgad kokku
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
--m��rab linna
update Employees
set City = 'London'
where Id = 8

--n�itab kogu palkasi linna ja soo p�hjal
select City, Gender, sum(cast(Salary as int)) as TotalSalary from Employees
group by City, Gender
--sama p�ring nagu eelmine, aga linnad on t�hestikulises j�rjestuses
select City, Gender, sum(cast(Salary as int)) as TotalSalary from Employees
group by City, Gender
order by City

--loeb �ra ridade arvu Employees tabelis
select count(*) from Employees

--mitu t��tajat on soo ja linna kaupa
select count(Id) as [Total Employee(s)], Gender, City 
from Employees
group by Gender, City

--kuvab ainult k�ik naised linnade kaupa
select count(Id) as [Total Employee(s)], Gender, City 
from Employees
where Gender = 'female'
group by Gender, City

--kuvab ainult k�ik mehed linnade kaupa ja kasutame having
select count(Id) as [Total Employee(s)], Gender, City 
from Employees
group by City, Gender
having Gender = 'male'

--n�idis kus ei t��ta where
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
--kuvab neid, kellel on DepartmentName all olemas v��rtus
select Name, Gender, Salary, Department.DepartmentName --loetavuse m�ttes kasutan Department.DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
--kuidas saada k�ik andmed Employees't k�tte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department --v�ib kasutada ka LEFT OUTER JOIN
on Employees.DepartmentId = Department.Id

---right join
---kuidas saada DepartmentName alla uus nimetus
select Name, Gender, Salary, DepartmentName
from Employees
right join Department --v�ib kasutada ka RIGHT OUTER JOIN
on Employees.DepartmentId = Department.Id

--kuidas saada k�ikide tabelite v��rtused �hte p�ringusse
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id

--cross join v�tab kaks allpool olevat tabelit kokku ja korrutab need omavahel l�bi
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department

--p�ringu sisu
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
--m�lema tabeli mitte-kattuvate v��rtustega read kuvab v�lja
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

--kasutame Employees tabeli asemel l�hendit E ja Department asemel D
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

--kui Expression on �ige, siis paneb v��rtuse, 
--mida soovid v�i m�ne teise v��rtuse
case when Expression then '' else '' end

---
alter table Employees
add ManagerId int

--neil, kellel ei ole �lemust, siis paneb No manager teksti
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--teeme p�ringu kus kasutame case-i
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

--n�idis nime updateimiseks
update Employees
where FirstName = NULL, MiddleName = NULL, LastName = NULL
where Id = NULL

--igast reast v�tab esimesena t�idetud lahtri ja kuvab ainult seda
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

--ksautame union all, mis n�itab k�iki ridu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate v��rtustega read pannakse �hte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--kuidas sorteerida nime j�rgi
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers
order by Name

---stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--n��d saab kasutada selle nimelist sp-d
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

--kui n��d allolevat k�sklust k�ima panna, siis n�uab Gender parameetrit
exec spGetEmployeesByGenderAndDepartment
--�ige variant
exec spGetEmployeesByGenderAndDepartment 'male', 1

--nii saab parameetrite j�rjestusest m��da minna
exec spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'male'

---saab sp sisu vaadata result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta sp-d ja v�ti peale panna, et keegi teine peale teie ei saaks muuta
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

--annab tulemuse kus loendab �ra n�uetele vastavad read
--prindib ka tulemuse kirja teel
declare @TotalCount int
exec spGetEmployeeCountByGender 'male', @TotalCount out
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@TotalCount is not null'
print @TotalCount
go --tee �levalpool �ra ja siis mine edasi
select * from Employees

--n�itab �ra, et mitu rida vastab n�uetele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Female'
print @TotalCount

--sp/store procedure sisu vaatamine
sp_help spGetEmployeeCountByGender

--tabeli info
sp_help Employees

--kui soovide sp teksti n�ha
sp_helptext spGetEmployeeCountByGender

--vaatame millest s�ltub sp
sp_depends spGetEmployeeCountByGender
--vaatame tabeli s�ltuvust
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

--mis id all on keegi nime j�rgi
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
--pole outputi seega ei t��ta
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name = ' + @EmployeeName

---sisse ehitatud string funktsioonid

--see konverteerib ASCII t�he v��rtuse numbriks
select ASCII('a')
--kuvab A-t�hte
select char(65)

--prindime v�lja kogu t�hestiku
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
	select char (@Start)
	set @Start = @Start + 1
end


--eemaldame t�hjad kohad sulgudes
select ltrim('                   Hello')

--t�hikute eemaldamine veerust
select ltrim(FirstName) as FirstName, MiddleName, LastName from Employees

select * from Employees

--paremalt poolt t�hjad stringid l�ikab �ra
select rtrim('              Hello                 ')
select rtrim(FirstName) as FirstName, MiddleName, LastName from Employees

--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt upper ja lower-ga saan muuta m�rkide suurust
--reverse funktsioon p��rab k�ik �mber
select REVERSE(UPPER(ltrim(FirstName))) as FirstName, MiddleName, lower(LastName),
rtrim(ltrim(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--n�eb mitu t�the on s�nal ja loeb t�hikud sisse
select FirstName, len(FirstName) as [Total Characters] from Employees
--n�eb mitu t�hte on s�nal ja ei ole t�hikuid
select trim(FirstName), len(trim(FirstName)) as [Total Characters] from Employees

--left, right, substring
--vasakult poolt neli esimest t�hte
select left('ABCDEF', 4)
--paremalt neli
select right('ABCDEF', 4)
--esimene nr peale koma kohta n�itab, et mitmendast alustab ja siis teine, mitu nr kaasa arvatud esimesega peale seda kuvab
select substring('pam@bbb.com', 1, 3)

--kuvab @-t�he m�rgi asetust
select CHARINDEX('@', 'sara@aaa.com')

--@-m�rgist kuvab kolm t�hem�rki. Viimase nr saab m��rata pikkust
select substring('pam@bbb.com', charindex('@', 'pam@bbb.com') +  2, len('pam@bbb.com') - CHARINDEX('@', 'pam@bbb.com'))

--saame teada domeeni nimed emailidest
select substring(Email, charindex('@', Email) + 1, len(Email) - CHARINDEX('@', Email)) as EmailDomain from Person

alter table Employees
add Email nvarchar(20)

select * from Employees
update Employees set Email = 'tom@tom.com' where Id = 1

--lisame *-m�rgi alates teatud kohast
select FirstName, LastName, 
	SUBSTRING(Email, 1, 2) + replicate('*', 5) + ---peale teist t�hem�rki paneb viis t�rni
	SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - charindex('@', Email) + 1) as Email
from Employees

select replicate('asd', 3)

--kuidas sisestada t�hikut kahe nime vahele
select SPACE(5)

--t�hikute arv kahe nime vahel
select FirstName + space(3) + LastName as FullName from Employees

--patindex
--sama mis charindex aga d�naamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@pam.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@pam.com', Email) > 0

--- k�ik .com-d asendatakse .net-ga
select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail from Employees 

--soovin asendada peale esimest m�rki kolm t�hte viie t�rniga
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

--aja p�ring
select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP'
select SYSDATETIME(), 'SYSDATETIME' --t�psem
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' --aja tsooniga UTC
select GETUTCDATE(), 'GETUTCDATE' --UTC aeg

select ISDATE('asd') --tagastab 0 kuna string pole kp
select ISDATE(getdate()) --tagastab 1 kuna on kp
select ISDATE('2024-04-02 09:33:43.586') --tagastab 1 max 3 komakohaga
select DAY(GETDATE()) --annab t�nase kp numbri
select DAY('2024-04-15') --annab stringis oleva kp ja j�rjestus peab olema �ige
select DAY('04/15/2024')
select MONTH(GETDATE()) --annab kuu numbri
select YEAR(GETDATE()) --annab aasta numbri

select DATENAME(day, '2024-04-02 09:33:43.586') --annab stringis oleva p�eva numbri
select DATENAME(weekday, '2024-04-12 09:33:43.586') --annab stringis oleva n�dala p�eva
select DATENAME(MONTH, '2024-04-02 09:33:43.586') --annab stringis oleva kuu s�nana

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

--kuidas v�tta �hest veerust andmeid ja selle abil luua uusi andmeid
select Name, DateOfBirth, DATENAME(WEEKDAY, DateOfBirth) as [Day], --vaatab DoB veerust p�eva ja kuvab p�eva nimetuse s�nana
	   Month(DateOfBirth) as MonthNumber, --vaatab DoB veerust kp ja kuvab kuu numbri
	   DateName(MONTH, DateOfBirth) as [MonthName], --vaatab DoB veerust kuud ja kuvab s�nana
	   YEAR(DateOfBirth) as [Year] --v�tab DoB veerust aasta
from EmployeesWithDates

select DATENAME(WEEKDAY, '1998-07-21') --minu s�nni n�dala p�ev

select DATEPART(WEEKDAY, '2024-04-02 09:33:43.586') --kuvab 3 kuna USA n�dal algab p�hap�evaga
select DATEPART(MONTH, '2024-04-02 09:33:43.586') --kuvab kuu nr
select DATEADD(DAY, 20, '2024-04-02 09:33:43.586') --liidab p�evale antud numbri
select DATEADD(DAY, -20, '2024-04-02 09:33:43.586') --lahutab p�evale antud numbri
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

-- kui kasutame seda funktsiooni, siis saame teada t�nase p�eva vahet stringis v�lja toodga
select dbo.fnComputeAge('11/20/2011')

--nr peale DOB muutujat n�itab, et mismoodi kuvada DOB-d
select Id, Name, DateOfBirth, convert(nvarchar, DateOfBirth, 126) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id] from EmployeesWithDates

select cast(GETDATE() as date) --t�nane kp
select convert(date, GETDATE()) --t�nane kp

---matemaatilised funktsioonid

select ABS(-101.5) --absoluutv��rtus
select ceiling(15.2) --�mardab �les
select ceiling(-15.2) --�mardab positiivsema arvu suunas
select floor(15.2) --�mardab alla poole
select floor(-15.2) --�mardab negatiivsema poole
select power(2, 4) --astendab 2, 4-ga 2x2x2x2
select square(9) --9 ruudus
select sqrt(81) --ruutjuur

select rand() --annab suvalise nr
select(floor(rand() * 100))

--iga kord n�itab 10 suvalist nr-t
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
	print floor(rand() * 1000)
	set @counter = @counter + 1
end

select round(850.556, 2) --�mardab teise komakoha j�rgse numbrini
select round(850.556, 2, 1) --�mardab alla poole
select round(850.556, 0) --�mardab t�isarvuni
select round(850.556,-2) --�mardab kaks kohta enne koma ehk tulemus 900

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

--arvutab v�lja kui vana on isik ja v�tab arvesse kuud ja p�evad
--antud juhul n�itab k�ike, kes on �le 36a vanad
select Id, Name, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 36

alter table EmployeesWithDates
add DepartmentId int
alter table EmployeesWithDates
add Gender nvarchar(10)

--scalar funktsioon annab mingis vahemikus olevaid andmeid, aga
--inline table values ei kasuta begin ja end funktsioone
--scalar annab v��rtused ja inline annab tabeli
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

--k�ik female t��tajad
select * from fn_EmployeesByGender('Female')

--kuidas saaks samat p�ringut t�psustada
select * from fn_EmployeesByGender('Female')
where Name = 'Pam'

--kahest erinevast tabelist andmete v�tmine ja koos kuvamine
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

--kutsume v�lja funktsiooni
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

---inline tabeli funktsioonid on paremini t��tamas kuna k�sitletakse vaatena e. view
---multi puhul on pm tegemist store proceduriga ja kulutab ressurssi rohkem

update fn_GetEmployees() set Name = 'Sam1' where Id = 1 --saab muuta andmeid
select * from fn_MS_GetEmployees()
update fn_MS_GetEmployees() set Name = 'Sam2' where Id = 1 --ei saa muuta andmeid multistate puhul

--deterministic
select count(*) from EmployeesWithDates
select SQUARE(3) --k�ik tehtem�rgid on deterministlikud funktsioonid, sinna kuuluvad veel sum, avg ja square
--non-deterministic
select GETDATE()
select CURRENT_TIMESTAMP
select RAND() --see funktsioon saab olla m�lemas kategoorias, k�ik oleneb sellest, kas sulgudes on 1 v ei ole

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

--peale seda ei n�e funktsiooni sisu
alter function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
with encryption
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

--muudame �levalpool olevat funktsiooni, kindlasti tabeli ette panna dbo.TabeliNimi
alter function dbo.fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
with schemabinding
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

---temporary tables
---#-m�rgi ette panemisel saame aru, et tegemist on temp tabeliga
---seda tabelit saab ainult selles p�ringus avada
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

--loome indeksi, mis asetab palga kahanevasse j�rjestusse
create index IX_Employee_Salary
on EmployeeWithSalary (Salary desc)

--tahan vaadata indexi tulemust
select * from EmployeeWithSalary with(Index(IX_Employee_Salary))

drop index dbo.EmployeeWithSalary.IX_Employee_Salary

--saame teada, et mis on selle tabeli primaarv�ti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

--saame vaadata tabelit koos selle sisuga alates v�ga detailsest infost
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

--klastris olevad indeksid dikteerivad s�ilitatud andmete j�rjestuse tabelis
--ja seda saab klastrite puhul olla ainult �ks

create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)

--annab veateate, et tabelis saab olla ainult �ks klastris olev indeks
--kui soovid uut indeksit luua siis kustuta olemasolev

--saame luua ainult �he klastris oleva indeksi tabeli peale
--klastris olev ideks on analoogne telefoni suunakoodile
select * from EmployeeCity
go
create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)
go
select * from EmployeeCity

---- indeksi t��bid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. T�istekst
--7. Ruumiline
--8. Veerus�ilitav
--9. Veergude indeksid
--10. V�lja arvatud veergudega indeksid

-- klastris olev indeks m��rab �ra tabelis oleva f��silise j�rjestuse 
-- ja selle tulemusel saab tabelis olla ainult �ks klastris olev indeks

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

--- saame luua ainult �he klastris oleva indeksi tabeli peale
--- klastris olev indeks on analoogne telefoni suunakoodile
select * from EmployeeCity
go
create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)
go
select * from EmployeeCity
-- kui teed select p�ringu sellele tabelile, siis peaksid n�gema andmeid, mis on j�rjestatud selliselt:
-- Esimeseks v�etakse aluseks Gender veerg kahanevas j�rjestuses ja siis Salary veerg t�usvas j�rjestuses

--- erinevused kahe indeksi vahel
--- 1. ainult �ks klastris olev indeks saab olla tabeli peale, 
--- mitte-klastris olevaid indekseid saab olla mitu
--- 2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi viitama tabelile
--- Juhul, kui selekteeritud veerg ei ole olemas indeksis
--- 3. Klastris olev indeks m��ratleb �ra tabeli ridade slavestusj�rjestuse
--- ja ei n�ua kettal lisa ruumi. Samas mitte klastris olevad indeksid on 
--- salvestatud tabelist eraldi ja n�uab lisa ruumi

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
--- et SQL server kasutab UNIQUE indeksit j�ustamaks v��rtuste unikaalsust ja primaarv�tit
--- koodiga Unikaalseid Indekseid ei saa kustutada, aga k�sitsi saab

insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

--- unikaalset indeksid kasutatakse kindlustamaks v��rtuste unikaalsust (sh primaarv�tme oma)

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
--ei luba tabelisse v��rtusega uut Londonit
insert into EmployeeFirstName values(3, 'John', 'Menco', 2500, 'Male', 'London')

--saab vaadata indeksite nimekirja
exec sp_helpconstraint EmployeeFirstName

-------------tekst vaja kopeerida githubist rida 1300-1307
--koodin�ide:
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

insert into EmployeeFirstName values(3, 'John', 'Menco', 5500, 'Male', 'London')
insert into EmployeeFirstName values(4, 'John', 'Menco', 6500, 'Male', 'London1')
insert into EmployeeFirstName values(4, 'John', 'Menco', 7500, 'Male', 'London1')
--enne ignore k�sku oleks k�ik kolm tagasi l�katud, aga
--n��d l�ks keskmine rida l�bi kuna linna nimi oli unikaalne

select * from EmployeeFirstName

---view

--view i=on salvestatud SQL-i p�ring. Saab k�sitleda ka virtuaalse tabelina
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

--view p�ringu esile kutsumine
select * from vEmployeesByDepartment

------------kopeeri 1341-1347 githubist

--teeme view, kus n�eb ainult IT-t��tajaid
create view vEmployeesByDepartmentIT
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
where DepartmentName = 'IT'
--�levalpool olevat p�ringut saab liigutada reataseme turvalisuse alla
--tahan ainult n�idata IT osakonna t��tajaid

select * from vEmployeesByDepartmentIT

--veeru taseme turvalisus
--peale selecti m��ratled veergude n�itamise �ra
create view vEmployeesInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeesInDepartmentSalaryNoShow

--saab kasutada esitlemaks koondandmeid ja �ksikasjalikke andmeid
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
--kas l�bi view saab uuendada andmeid

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

--peale iga t��taja sisestamist tahame teada saada t��taja Id-d, p�eva ning aega
--(millal sisestati). K�ik andmed l�hevad EmployeeAudit tabelisse.

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

	--muutuja kuhu l�heb l�pptekst
	declare @AuditString nvarchar(1000)

	--laeb k�ik uuendatud andmed temp tabeli alla
	select * into #TempTable
	from inserted

	--k�ib l�bi k�ik andmed tabelis
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


end
