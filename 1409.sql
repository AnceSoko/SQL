delimiter //
create function obtenerNombreEmpleado (id int)
returns varchar(255)
begin
	declare employeeName varchar(255);
    select firstName into employeeName 
    from employees
    where employeeNumber = id;
    return employeeName;
end // 


/*1 .  Crea una función llamada PEDIDOSCLIENTES con los clientes que hayan hecho más
 de un pedido que aparezca VARIOS Y LOS QUE SOLO HAYAN HECHO 1 O NINGUNO APAREZCA POCOS*/
 use classicmodels;
 
 delimiter //
 create function pedidosCliente (id varchar(50))
 returns int
 begin
	declare total int;
    set total = (select count(*) from orders where customernumber = id);
    return total;
end //


delimiter //
 create function pedidosCliente (id varchar(50))
 returns varchar(50)
 begin
	declare total varchar(50);
    set total = (select count(*) from orders where customernumber = id);
		if total<1 then return 'pocos pedidos';
		else return 'muchos pedidos';
		return total;
		end if;
end //

select distinct customernumber, pedidosCliente(customernumber) from orders;


delimiter //
 create function pedidosCliente2 (id varchar(50))
 returns varchar(50)
 begin
	declare total varchar(50);
    select count(*) into total from orders where customernumber = id;
		if total<1 then return 'pocos pedidos';
		else return 'muchos pedidos';
		end if;
end //

select distinct customernumber, pedidosCliente2(customernumber) from orders;

/* 2. */
select customernumber, avg(amount) as promedio,
if (avg(amount)>2000, 'mucho gasto', 'poco gasto') as catGasto
from payments
group by 1;

/* 3. */
delimiter //
create function paises (countryname varchar(30))
returns varchar(30)
	begin
		declare cantidadOficina int;
        set cantidadOficina = (select count(*) from offices where country = countryname);
        
        if cantidadOficina > 1 then return 'varias oficinas';
        else return 'una oficina';
        end if;
        
	end //
    
    select officecode, country, paises(officecode), count(*) from offices group by country;

SET sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


/* 4. */
delimiter //
create function clientes2(pedido varchar(50))
returns varchar(50)
	begin	
		declare cantidad int;
        set cantidad = (select count(*) from payments where customernumber = pedido);
        
        if cantidad> 1 then return 'varias facturas';
        else return 'pocas facturas';
        end if;
	end //
    
select distinct customernumber, count(*), clientes2(customernumber) from payments group by customernumber;


/* 5. */ 
delimiter //
create function pedidos (estado varchar(60))
returns varchar(60)
	begin
		case when estado = 'shipped' then return 'enviado';
        when estado = 'on hold' then return 'en espera';
        when estado = 'cancelled' then return 'cancelado';
        when estado = 'in process' then return 'en proceso';
        when estado ='disputed' then return 'disputado';
        else return 'resueltos';
        end case;
	end//
    
select  ordernumber, status, pedidos(ordernumber)from orders;

/* 6 .*/


/* .Crea una función en la que los clientes viven en ciudades sin STATE,
 en la tabla aparece NULL, por lo que aparezca SIN ESTADO y el resto con ESTADO*/
 delimiter //
 create function customerState(nombre varchar(50))
 returns varchar(30)
	begin
		if nombre is null then return 'sin estado';
        else return 'con estado';
        end if;
	end //
    
select customername, state, customerState(state) from customers;




