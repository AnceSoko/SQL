use classicmodels;

select quantityordered,
case
when quantityordered <50 then 'poco stock'
when quantityordered >=90 then 'mucho stock'
else 'indefinido'
end as unidadesalmacen
from orderdetails;


select customernumber,
case 
when 1 and status ='shipped' then '1 enviados'
when 2 and status ='on hold' then '2 enviados'
when 3 and status ='cancelled' then '3 cancelados'
else 'mas de 3' 
end as 'cantidadyestadopedidos'
from orders
group by customernumber;


select productcode, buyprice,
if (buyprice<50, 'producto barato', 'producto caro')
as 'precios'
from products;

select productcode, buyprice,
case 
	when buyprice<50 then 'muy baratos'
    when buyprice>= 50 and buyprice<=70 then 'baratos'
    when buyprice>= 70 and buyprice<=90 then 'caros'
    else 'muy caros'
    end as 'precioproducto'
from products;

select customernumber, sum(amount) as total,
case 
when sum(amount)<=25000 then 'mal cliente'
when sum(amount) BETWEEN 25000 and 40000 then 'cliente normal'
when sum(amount) between 40000 and 50000 then 'buen cliente'
else 'premium'
end as 'tipocliente'
from payments
group by 1;

/* 1. Pedidos que cuyo estado sea shipped aparezcan enviados, y el resto que no estén enviados aparezacan EN TRANSITO. (if)*/
select ordernumber,
if (status= 'shipped', 'enviado', 'en tránsito')
as estadopedido
from orders;

/* 2. Pedidos shipped-enviados, on hold en espera,cancelled cancelados, in progress en proceso CASE*/
select ordernumber, status,
case
when status = 'shipped' then 'enviados'
when status = 'on hold' then 'en espera'
when status = 'cancelled' then 'cancelados'
when status = 'in progress' then 'en proceso'
else 'sin procesar' 
end as estadopedido
from orders;

/* 3. Aquellos clientes cuyo nombre termina en Y que aparezca FINALIZAN con Y IF*/
select customername,
if (right(customername,1)= 'y', 'finalizan con y', 'no finalizan con y') 'nombres y'
from customers;

/* 4. Clientes cuyo promedio de pedidos(amount) por clientes sea mayor que 1000 y aparezca PROMEDIOELEVADO y sino PROMEDIOBAJO IF*/
select customernumber, avg(amount) as medio, 
if (avg(amount)>1000, 'promedio elevado' ,'promedio bajo')
as promedio
from payments
group by 1;

/* 5. CON CASE menor que 1000 PROMEDIOBAJO, entre 1000 y 5000 PROMEDIOMEDIO, entre 5000 y 10000 PROMEDIOALTO
el resto PROMEDIOELEVADO*/
select customernumber, avg(amount) as medio,
case
when avg(amount)< 1000 then 'promedio bajo'
when avg(amount) between 1000 and 5000 then 'promedio medio'
when avg(amount) between 5000 and 10000 then 'promedio alto'
else 'promedio exajerado'
end as 'tipospremedio'
from payments
group by 1;


select customernumber, country, creditlimit
from customers
order by case country
when 'usa' then creditlimit end desc,
case when country ='France' then creditlimit
end;

/* organizar los vendedores dependiendo si son guapos o no, order them by codpostal, si es guapo order codpostal desc, si no es guapo 
order codpostal asc*/
use verduleros;
select nombrevendedor, guapos, codpostal
from vendedores
order by case guapos
when '1' then codpostal end desc,
case when guapos='0' then codpostal
end;



