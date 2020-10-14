-- query #1: Display the cities that makes the most different kinds of products.
select city
from products 
group by city having count(name) >= all
	(select count(name)
	 from products
	 group by city);
				
-- query #2: Display the names of products whose priceUSD is at or above the average priceUSD, in reverse-alphabetical order.
select name
from products
group by name, priceUSD
having priceUSD>= 
				(select avg(priceUSD)
					from products)
order by name desc;

-- query #3: Display the customer last name, product id ordered, and the totalUSD for all orders made in March, sorted by totalUSD from high to low.
select p.lastName, o.prodId, o.totalUSD
from people p inner join customers c on p.pid = c.pid
			   inner join orders o on o.custid = c.pid
where dateOrdered > '2020-02-28'
and dateOrdered < '2020-04-01'
order by o.totalUSD DESC;

-- query #4: Display the last name of all customers (in reverse alphabetical order) and their total ordered, and nothing more. (Hint: Use coalesce to avoid showing NULLs.)
select distinct p.lastName, sum(coalesce(o.totalUSD, 0.00))
from People p inner join customers c on p.pid = c.pid
			   left outer join orders o on c.pid = o.custid
group by p.lastName
order by p.lastName DESC;

-- query #5: Display the names of all customers who bought products from agents based in Teaneck along with the names of the products they ordered, and the names of the agents who sold it to them.
select p1.lastName as customer, pr.name, p2.lastName as agent
from people p1 inner join customers c on p1.pid = c.pid
			   inner join orders o on o.custId = p1.pid
			   inner join products pr on pr.prodId = o.prodId
			   inner join people p2 on o.agentId = p2.pid
where p2.pid in (select pid
					from people
					where homeCity = 'Teaneck');

-- query #6: Write a query to check the accuracy of the totalUSD column in the Orders table. This means calculating Orders.totalUSD from data in other tables and comparing those values to the values in Orders.totalUSD. Display all rows in Orders where Orders.totalUSD is incorrect, if any. If there are any incorrect values, explain why they are wrong.
select *
from (select o.*, o.quantityOrdered * pr.priceusd  * (1 - (c.discountPct / 100)) as trueUSD
			  from orders o
			  inner join products pr on o.prodId = pr.prodId
			  inner join customers c on o.custId = c.pid) as temptable
where totalUSD!= round(trueUSD, 2);

-- query #7: Display the first and last name of all customers who are also agents.
select firstName, lastName
from people
where pid in (select pid
			 	from customers)
and
pid in (select pid
			 	from agents);
				

-- query #8: Create a VIEW of all Customer and People data called PeopleCustomers. Then another VIEW of all Agent and People data called PeopleAgents. Then "select *" from each of them in turn to test.
drop view PeopleCustomers;
create view PeopleCustomers as
select p.pid, p.prefix, p.firstName, p.lastName, p.suffix, p.homeCity, p.DOB, c.paymentTerms, c.discountPct
from people p full outer join customers c on c.pid=p.pid;

drop view PeopleAgents;
create view PeopleAgents as
select p.pid, p.prefix, p.firstName, p.lastName, p.suffix, p.homeCity, p.DOB, a.paymentTerms, a.commissionPct
from people p full outer join agents a on a.pid=p.pid;

select * from PeopleCustomers;
select * from PeopleAgents;

-- query #9: Display the first and last name of all customers who are also agents, this time using the views you created.
select pc.firstname, pc.lastname
from peoplecustomers pc inner join peopleagents pa on pc.pid = pa.pid
where pc.paymentterms is not null
and pa.paymentterms is not null;


-- query #10: Compare your SQL in #7 (no views) and #9 (using views). The output is the same. How does that work? What is the database server doing internally when it processes the #9 query?
-- Since a view is just a virtual table but only exists as a query instead of a memory like a base table, query #9 is just internally using the previously made views from the system catalog. A view is just representing a subset of data in a created table.
-- Views are just relations that are defined by computation and relational algebra. Although these relations are not stored, they are constructed when needed through queries.

--query #11: [Bonus] What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give example queries in SQL to demonstrate. (Feel free to use the CAP database to make your points here.)
-- In a right outer join (ex R right outer join S) it is like an outer join but the dangling tuples to the right of the join (s) are padded with null and added to the result.
-- In a left outer join (ex R left outer join S) it is also like an outer join but the dangling tuples to the left of the join (r) are padded with null and added to the result.