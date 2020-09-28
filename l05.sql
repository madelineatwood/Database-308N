-- query #1: Show all the People data (and only people data) for people who are customers. Use joins this time; no subqueries.
select *
from people p inner join customers c on p.pid = c.pid;

-- query #2: Show all the People data (and only the people data) for people who are agents. Use joins this time; no subqueries.
select *
from people p inner join agents a on p.pid = a.pid;

-- query #3: Show all People and Agent data for people who are both customers and agents. Use joins this time; no subqueries.
select *
from people p inner join agents a on p.pid = a.pid
			   inner join customers c on a.pid = c.pid;

-- query #4: Show the first name of customers who have never placed an order. Use subqueries.
select firstName
from people
where pid not in (select CustId from orders)
and pid in (select pid from customers)
and pid not in (select pid from agents);

-- query #5: Show the first name of customers who have never placed an order. Use one inner and one outer join. 
select firstName
from people p inner join customers c on p.pid = c.pid
			left outer join orders o on o.custid = c.pid
where o.custid is null;

-- query #6: Show the id and commission percent of Agents who booked an order for the Customer whose id is 008, sorted by commission percent from low to high. Use joins; no subqueries.
select distinct pid, commissionpct
from agents a inner join orders o on a.pid = o.agentId
where o.custId = 008
order by commissionpct ASC;

-- query #7: Show the last name, home city, and commission percent of Agents who booked an order for the customer whose id is 001, sorted by commission percent from high to low. Use joins.
select distinct lastName, homeCity, commissionpct 
from people p inner join agents a on p.pid = a.pid
			   inner join orders o on a.pid = o.agentId
where o.custId = 001
order by commissionpct DESC;

-- query #8: Show the last name and home city of customers who live in the city that makes the fewest different kinds of products. (Hint: Use count and group by on the Products table. You may need limit as well.)
select lastName, homeCity
from people
where homeCity in (select city
				  from products
				  group by products.city
				  order by count(name) ASC
				  limit 1);
				  
-- query #9: Show the name and id of all Products ordered through any Agent who booked at least one order for a Customer in Chicago, sorted by product name from A to Z. You can use joins or subqueries. Better yet, do it both ways and impress me.
-- using subqueries
select name, prodId
from products
where prodId in (select distinct prodId
					from orders
					where agentId in 
				 			(select distinct agentId
							from orders
							where custId in 
							 		(select pid 
									 from people 
									 where homeCity = 'Chicago')))
order by name ASC;

-- using joins 
select distinct pr.name, pr.prodId
from products pr inner join orders o1 on pr.prodid = o1.prodid
				  inner join orders o2 on o1.agentid = o2.agentid
				  inner join people p on p.pid = o2.custid
where p.homeCity = 'Chicago'				  
order by name ASC;

-- query #10- Show the first and last name of customers and agents living in the same city, along with the name of their shared city. (Living in a city with yourself does not count, so exclude those from your results.)
select firstName, lastName, homeCity
from people
where pid in (select pid from customers where homeCity in 
			  			(select homeCity
							from people
							group by people.homeCity
							having count(homeCity)!=1))
or pid in (select pid from agents where homeCity in 
			  			(select homeCity 
							from people
							group by people.homeCity
							having count(homeCity)!=1));