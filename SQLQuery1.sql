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