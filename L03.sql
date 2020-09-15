select ordernum, totalUSD
from orders;

select lastname, homeCity
from people
where prefix='Dr.';

select prodId, name, priceUSD
from products
where qtyOnHand >1007;

select firstName, homeCity 
from people 
where '1949-12-31' < DOB 
and DOB < '1960-1-1';

select prefix, lastName
from people
where prefix !='Mr.';

select *
from products
where city != 'Dallas'
and city != 'Duluth'
and priceUSD >= 3;

select *
from orders
where dateOrdered > '2020-02-28'
and dateOrdered < '2020-04-01';

select *
from orders
where dateOrdered >= '2020-02-01'
and dateOrdered < '2020-03-01'
and totalUSD >= 20000;

select *
from orders
where custId = 007;

select *
from orders
where custId = 005;