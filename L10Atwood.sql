-- Madeline Atwood Lab 10- Stored Procedures

-- Procedure #1: func1on PreReqsFor(courseNum) - Returns the immediate prerequisites for the passed-in course number
create or replace function PreReqsFor(int, REFCURSOR) returns refcursor as 
$$
declare
   course int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
      select distinct Prerequisites.prereqnum, Courses.name
      from   Prerequisites, Courses
       where  Prerequisites.coursenum = course
	   and Prerequisites.prereqnum = Courses.num;
   return resultset;
end;
$$ 
language plpgsql;

select PreReqsFor(499, 'results');
Fetch all from results;

-- Procedure #2: func1on IsPreReqFor(courseNum) - Returns the courses for which the passed-in course number is an immediate pre-requisite
create or replace function IsPreReqFor(int, REFCURSOR) returns refcursor as 
$$
declare
   course int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for 
      select Prerequisites.coursenum, Courses.name
      from   Prerequisites, Courses
       where Prerequisites.prereqnum = course
	   and Prerequisites.coursenum = Courses.num;
   return resultset;
end;
$$ 
language plpgsql;

select IsPreReqFor(120, 'results');
Fetch all from results;