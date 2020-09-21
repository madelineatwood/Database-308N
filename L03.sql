-- query #1
select *
from people
where pid in (select pid from customers);
-- query #2
select *
from people
where pid in (select pid from agents);
-- query #3
select *
from people
where pid in (select pid from agents)
and pid in (select pid from customers);
-- query #4
select *
from people
where pid not in (select pid from agents)
and pid not in (select pid from customers);
-- query #5
select custId
from orders
where prodId = 'p01'
or prodId = 'p07';
-- query #6
select distinct custId
from orders
where custId in (select custId from orders where prodId = 'p01')
= custId in (select custId from orders where prodId = 'p07')
order by custId desc;
-- query #7
select distinct firstName, lastName
from people
where pid in (select agentId from orders where prodId = 'p05')
or pid in (select agentId from orders where prodId = 'p07')
order by lastName desc;
-- query #8
select homeCity, DOB
from people
where pid in (select agentId from orders where custId = 001)
order by homeCity asc;
-- query #9
select prodId
from orders
where agentId in 
(select agentId from orders where (custId in (select pid from people where homeCity = 'Toronto')))
order by prodId desc;
-- query #10
select lastName, homeCity
from people
where pid in 
(select custId from orders where (agentId in (select pid from people where homeCity = 'Teaneck')))
or pid in (select custId from orders where (agentId in (select pid from people where homeCity = 'Santa Monica')));