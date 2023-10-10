/*+++++++++++++++++++++++++Con operadores básicos de comparación+++++++++++++++++++++++++++++++++*/

/* 1.	Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).*/
use tienda;
select *
from producto
where id_fabricante in (
	select id
    from fabricante
    where nombre='Lenovo');
    
/* 2.	Devuelve todos los datos de los productos que tienen el mismo precio
 que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN)*/
 select * 
 from producto 
 where precio = (select max(precio)
	from producto
    where id_fabricante=(
    select id
    from fabricante
    where fabricante.nombre='Lenovo'));
    
/* 3.	Lista el nombre del producto más caro del fabricante Lenovo.*/
select *
from producto p join fabricante f on p.id_fabricante = f.id
where f.nombre ='Lenovo' 
and precio = ( select max(precio)	
	from producto join fabricante
    on producto.id_fabricante= fabricante.id
    where fabricante.nombre='Lenovo');
    
/*4.	Lista el nombre del producto más barato del fabricante Hewlett-Packard.*/
select *
from producto p join fabricante f on p.id_fabricante=f.id
where f.nombre= 'Hewlett-Packard'
and precio = (select min(precio)
	from producto pr join fabricante fab
    on pr.id_fabricante=fab.id
    where fab.nombre='Hewlett-Packard');

/* 5.	Devuelve todos los productos de la base de datos que tienen
 un precio mayor o igual al producto más caro del fabricante Lenovo.*/
 select * 
 from producto 
 where precio >= ( select max(precio)
	from producto 
    where id_fabricante=(
		select id 
        from fabricante
        where nombre='Lenovo'));
        
/*6.	Lista todos los productos del fabricante Asus que tienen un precio
 superior al precio medio de todos sus productos.*/
 select *
 from producto join fabricante on producto.id_fabricante=fabricante.id
 where fabricante.nombre='Asus' and precio> ( select avg(precio)
	from producto 
    where producto.id_fabricante= fabricante.id);
    
    
/*+++++++++++++++++++++++++++++++Subconsultas con ALL y ANY++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/* 8.	Devuelve el producto más caro que existe en la tabla producto sin hacer uso de MAX, ORDER BY ni LIMIT*/
select * 
from producto 
where precio >= all ( select p.precio
					from producto p);
                    
/* 9.	Devuelve el producto más barato que existe en la tabla producto sin hacer uso de MIN, ORDER BY ni LIMIT*/
select *
from producto 
where precio <= all (select p.precio
					from producto p);
                    
/* 10.	Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando ALL o ANY)*/
select * 
from fabricante
where id = any ( select id_fabricante
					from producto);
                    
/* 11.	Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando ALL o ANY)*/
select *
from fabricante
where id <> all ( select id_fabricante
					from producto);
                    
                    
/* +++++++++++++++++++++++++++++++++++++++++ Subconsultas con IN y NOT IN +++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*12.	Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).*/
select * 
from fabricante
where id in (select id_fabricante
				from producto);
                
/* 13.	Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN)*/
select *
from fabricante
where id not in (select id_fabricante
					from producto);
                    

/*+++++++++++++++++++++++++++++++ Subconsultas con EXISTS y NOT EXISTS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*14.	Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando EXISTS o NOT EXISTS)*/
select *
from fabricante f
where exists (select id_fabricante
				from producto
                where id_fabricante= f.id);
                
/* 15.	Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando EXISTS o NOT EXISTS).*/
select *
from fabricante f
where not exists (select id_fabricante
				from producto
                where id_fabricante= f.id);


/*+++++++++++++++++++++++++++++++++++++++++ Subconsultas correlacionadas ++++++++++++++++++++++++++++++++++++++++++++++++*/

/*16.	Lista el nombre de cada fabricante con el nombre y el precio de su producto más caro.*/
select f.id, f.nombre, p.nombre, precio
from fabricante f join producto p
on f.id=p.id_fabricante
where p.precio =(select max(precio)
					from producto
                    where id_fabricante = f.id);
                    
/* 17.	Devuelve un listado de todos los productos que tienen un precio mayor o igual
 a la media de todos los productos de su mismo fabricante*/
 select * 
 from producto p
 where precio>= (select avg(precio)
					from producto
                    where id_fabricante= p.id_fabricante);
                    
/* 18.	Lista el nombre del producto más caro del fabricante Lenovo*/
select p.nombre, precio
from producto p
where p.id_fabricante = (select id 
							from fabricante
                            where nombre='Lenovo')
and precio = (select max(precio)
					from producto
                    where id_fabricante =( select id
											from fabricante
                                            where nombre ='Lenovo'));

/*+++++++++++++++++++++++++++++++++++++++++++++ Subconsultas (En la cláusula HAVING) +++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/* 19.	Devuelve un listado con todos los nombres de los fabricantes que tienen el mismo número de productos que el fabricante Lenovo.*/
select f.nombre, count(*) 
from producto p, fabricante f
where p.id_fabricante = f.id
group by f.nombre 
having count(*) = (select count(*)
					from producto 
                    where id_fabricante=(select id 
								from fabricante
								where nombre='Lenovo'));
                                
                                


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
use classicmodels;

/* 1. Listar los nombres de los clientes que tienen asignado el representante
Willian Paterson(suponiendo que no pueden haber representantes con el mismo nombre)*/
select customername
from customers
where salesRepEmployeeNumber IN (
	select employeenumber
    from employees 
    where firstname='Julie'
    and lastname='Firrelli');
    
    
/* 2. Listar los empleados (employeenumber, firstname, y officecode) 
que trabajan con oficinas con addressline2 con un postalcode mayor de 10000*/
select employeenumber, firstname, lastname 
from employees
where officecode in(
	select officeCode
    from offices
    where addressline2 is not null
    and postalcode>10000);

select employeenumber, firstname, lastname 
from employees
 where exists(
	select addressline2 
    from offices
    where offices.officeCode=employees.officeCode
    and addressLine2 is not null
    and postalcode>10000);
    
/* 3. Listar los empleados que no trabajan en oficinas donde trabaje el empleado 1056*/
select firstname, lastname
from employees
where exists(
	select officeCode
    from offices
    where offices.officeCode=employees.officeCode
    and employeeNumber != 1056);
    
/* 4. Listar los productos (productcode, productname y productline) que no tengan un priceeach mayor de 50*/
select productcode, productname, productline
from products
where not exists(
	select ordernumber
    from orderdetails od
    where products.productCode=od.productCode
    and priceeach>50);
    
select productcode, productname, productline
from products
where productcode not in(
	select productcode
    from orderdetails
    where priceEach>50);
    
/* 5. Listar los clientes asignados a Julie Firrelli(1188) que  han remitido un pedido superior a 3000(amount)*/
select *
from customers
where customerNumber in (
	select customernumber
    from payments
    where amount>3000
    and salesRepEmployeeNumber='1188');

select *
from customers
where exists (
	select checknumber
    from payments 
    where customers.customerNumber=payments.customerNumber
    and amount>3000
    and salesRepEmployeeNumber='1188');
    
/* 6. Utilizando las tablas Empleados y Clientes quiero obtener a todos
 los representantes de ventas que representan a clientes de Australia*/
 select *
 from customers
 where exists (
	select employeenumber
    from employees
    where customers.salesRepEmployeeNumber=employees.employeeNumber
    and country='Australia');
    
    
/* 7. Quiero obtener todos los datos de los productos que menos coste tienen*/
select * 
from products 
where buyprice =(
	select min(buyprice)
    from products);

    
/* 8. Quiero obtener todos los pedidos que tienen un amount igual o inferior al amount promedio*/
select * 
from payments
where amount <=(
	select avg(amount)
    from payments);
    
/* 9. Quiero obtener todos los datos de los productos cuyo priceeach es 
el doble que el priceeach de todos los productos de Planes*/
select * from products
where productCode = any(
	select productcode 
    from orderdetails 
    where priceeach<(2*(priceeach))
    and productline='Planes');
    

                        













