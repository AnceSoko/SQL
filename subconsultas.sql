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
    

    

 
 
 
 
 
 
 
 
 
 
 


