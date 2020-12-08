--database final project Madeline Atwood
create table if not exists People(
	pid			int not null,
	firstName	text not null,
	lastName	text not null,
	DOB			date not null,
	primary key(pid)
);

insert into people (pid, firstName, lastName, DOB) values
	(001, 'Alan', 'Labouseur', '1968-07-12'),
	(002, 'Darren', 'Willis', '1990-07-14'),
	(003, 'Lucy', 'Ribbon', '1964-03-12'),
	(004, 'Eric', 'Fernandez', '1972-05-05'),
	(005, 'Anna', 'Star', '1959-12-25'),
	(006, 'Erica', 'Ruiz', '1965-11-13'),
	(007, 'Mason', 'Bennet', '1952-08-28'),
	(008, 'Olivia', 'Kerner', '2006-05-17'),
	(009, 'Emma', 'Lutz', '2004-01-12'),
	(010, 'Ava', 'Samson', '2003-02-14'),
	(011, 'Sophia', 'Hetat', '2005-12-11'),
	(012, 'Isabella', 'Avery', '2006-10-01'),
	(013, 'Charlotte', 'Fernandez', '2004-03-19'),
	(014, 'Amelia', 'Shephard', '2003-05-22'),
	(015, 'Harper', 'Louise', '2005-08-28'),
	(016, 'Scarlett', 'Vega', '2006-04-06'),
	(017, 'Chloe', 'White', '2003-09-11');
	
create table if not exists gymnasts(
	pid			int not null,
	level		text not null
);

insert into gymnasts(pid, level) values
	(008, 'gold'),
	(009, 'gold'),
	(010, 'gold'),
	(011, 'gold'),
	(012, 'gold'),
	(013, 'gold'),
	(014, 'gold'),
	(015, 'gold'),
	(016, 'gold'),
	(017, 'gold');
	
create table if not exists coaches(
	pid				int not null,
	CPRcertified	boolean default 'no'
);

insert into coaches(pid, CPRcertified) values
	(002, 'yes'),
	(003, 'no'),
	(004, 'yes');
	
create table if not exists judges(
	pid				int not null,
	eventJudge		text not null,
	CPRcertified	boolean default 'no',
	hourlyPayUSD	decimal(5,2)
);

insert into judges(pid, eventJudge, CPRcertified, hourlyPayUSD) values
	(001, 'vault', 'yes', 22.50),
	(005, 'bars', 'yes', 20.90),
	(006, 'beam', 'yes', 25.40),
	(007, 'floor', 'yes', 28.00);
	
create table if not exists team(
	gymnastId		int not null,
	teamId			int not null
);

insert into team(gymnastId, teamId) values
	((008, 116),
	(009, 116),
	(010, 116),
	(011, 112),
	(012, 112),
	(013, 112),
	(014, 112),
	(015, 112),
	(016, 100),
	(017, 100));
	
create table if not exists teams(
	tid			int not null,
	name		text not null,
	coachId		int not null,
	addressId	int not null
);

insert into teams(tid, name, coachId, addressId) values
	(100, 'North Stars', 002, 13),
	(112, 'NYC Elite', 003, 16),
	(116, 'AGA Academy', 004, 12);
	
create table if not exists address(
	addressId		int not null,
	street			text,
	zip				text,
	city			text,
	state			text,
	country			text
);

insert into address (addressId, street, zip, city, state, country) values
	(13, '91 Fulton St', '07005', 'Boonton', 'NJ', 'USA'),
	(16, '44 Worth St', '10013', 'New York', 'NY', 'USA'),
	(12, '212 Oakly Ave', '10282', 'New York', 'NY', 'USA');
	
	
create table if not exists scores(
	gymnastId		int not null,
	event			text not null,
	judgeId			int not null,
	score			float not null,
	scoreId			int not null
);

insert into scores (gymnastId, event, judgeId, score, scoreId) values
	(012, 'Beam', 001, 9.25, 001),
	(011, 'Bars', 005, 9.6, 002),
	(017, 'Floor', 006, 8.7, 003),
	(008, 'Vault', 007, 9.1, 004),
	(015, 'Bars', 005, 9.425, 005),
	(010, 'Bars', 005, 9.35, 006),
	(009, 'Beam', 001, 7.85, 007),
	(013, 'Beam', 001, 8.45, 008),
	(012, 'Floor', 006, 9.4, 009),
	(011, 'Vault', 007, 9.5, 010);
	
create table if not exists awards(
	gymnastId		int not null,
	scoreId			int not null,
	place			int not null,
	medalColor		text
);

insert into awards (gymnastId, scoreId, place, medalColor) values
	(012, 001, 1, 'gold'),
	(011, 005, 1, 'gold'),
	(017, 006, 5, 'bronze'),
	(008, 007, 2, 'silver'),
	(015, 005, 2, 'silver'),
	(010, 005, 3, 'bronze'),
	(009, 001, 9, 'bronze'),
	(013, 001, 5, 'bronze'),
	(012, 006, 3, 'bronze'),
	(011, 007, 1, 'gold');
	
create table if not exists placings(
	teamId			int not null,
	AAScore			float not null,
	AAPlace			int not null
);

insert into placings (teamId, AAScore, AAPlace) values
	(100, 35.25, 2),
	(111, 36.5, 1),
	(116, 34, 3);
	
create view AboveAverageScores as 
select p.firstName, p.lastName, ts.name, s.event, s.score
from people p left outer join team t on p.pid=t.gymnastId
	inner join scores s on t.gymnastId=s.gymnastId
	inner join teams ts on ts.tid=t.teamId
group by ts.name, s.score, p.firstName, p.lastName, s.event
having s.score>=
	(select avg(score)
	from scores);

select * from AboveAverageScores;

create view eventWinners as
select distinct s.event, s.score, p.firstName, p.lastName
from people p inner join awards a on p.pid=a.gymnastId
	inner join scores s on s.gymnastId=p.pid
where place=1;

select * from eventWinners;

select distinct p.firstName, p.lastName, (sum(coalesce(s.score))/count(s.score)) as averagescores
from people p inner join scores s on p.pid=s.judgeid
group by p.firstName, p.lastName
order by averagescores DESC
limit 1;

select distinct p.firstName, p.lastName, (sum(coalesce(s.score))/count(s.score)) as averagescores
from people p inner join scores s on p.pid=s.judgeid
group by p.firstName, p.lastName
order by averagescores ASC
limit 1;

select *
from people
where lastName in (select lastName
					from people p
					group by lastName
					having count(lastName) >1);
					
create or replace function average_judge_scores(int, REFCURSOR) returns refcursor as
$$
declare
judgeNum	int := $1;
results		REFCURSOR := $2;
begin
open results for 
select distinct p.firstName, p.lastName, (sum(coalesce(s.score))/count(s.score)) as averagescores
from people p inner join scores s on p.pid=s.judgeid
where p.pid = judgenum
group by p.firstName, p.lastName;
return results;
end;
$$
language plpgsql;

select average_judge_scores(6, 'results');
fetch all from results;

create or replace function search_people_name(text, text, REFCURSOR) returns refcursor as 
$$
declare 
firstSearch text 	:= $1;
lastSearch	text	:= $2;
results REFCURSOR	:= $3;
begin
open results for
select *
from people
where firstName like firstSearch
and lastName like lastSearch;
return results;
end;
$$
language plpgsql;

select search_people_name('A%', '%', 'results');
fetch all from results;

create or replace function maxCompetitors()
returns trigger as
$$
begin
if (select count(pid)
	from gymnasts) >10
then
delete from gymnasts where pid=NEW.pid;
end if;
return new;
end;
$$
language plpgsql;

create trigger maxCompetitors
after insert on gymnasts
for each row
execute procedure maxCompetitors();
	
insert into gymnasts
values (18, 'gold');

select * from gymnasts;

create role admin;
create role gymHost;
	
grant select, insert, update, delete on people to admin;
grant select, insert, update, delete on gymnasts to admin;
grant select, insert, update, delete on coaches to admin;
grant select, insert, update, delete on judges to admin;
grant select, insert, update, delete on teams to admin;
grant select, insert, update, delete on address to admin;
grant select, insert, update, delete on placings to admin;
grant select, insert, update, delete on team to admin;
grant select, insert, update, delete on awards to admin;
grant select, insert, update, delete on scores to admin;
	
grant select, insert, update, delete on judges to gymHost;
grant select, insert, update, delete on awards to gymHost;
grant select, insert, update, delete on scores to gymHost;
	
revoke all on all tables in schema public from gymHost;
		










