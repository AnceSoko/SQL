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



+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/* 1. Ejercicio Crear función Suma*/
delimiter $$
create function suma(num1 int, num2 int)
returns int
begin
declare suma int;
set suma = num1 + num2;
return suma;
end $$

/*2. Ejercicio Crear Función Compara enteros*/
delimiter $$
create function comparaEnteros(num1 int, num2 int)
returns varchar(35)
begin
declare resultado varchar(35);
IF num1>num2 THEN SET  Resultado = CONCAT( num1, ' es mayor que', num2);
    ELSEIF num1=num2 THEN SET Resultado = CONCAT( num1, 'es igual que ', num2);
    ELSE SET Resultado = CONCAT( num1, 'es menor que', num2);
    END IF;
RETURN Resultado;
END $$


/*3. Ejercicio Crear Función Compara string: recibe dos cadenas de caracteres y devuelve 0 
-- si la longitud de las cadenas es igual,
--  1 si la longitud de la primera cadena es mayor que la longitud de la segunda y 2 en otro caso)*/
delimiter $$
create function comparaString(text1 varchar(100), text2 varchar(100))
returns INT
begin
declare resultado int;
IF Text1=Text2 THEN
	SET Resultado = 0;
		ELSEIF Text1>Text2 THEN
			SET Resultado = 1;
    ELSE SET Resultado = 2;        
END IF;
RETURN Resultado;
END $$


/* 4. Ejercicio Crear Procedimiento, que recibiendo 2 números enteros,
 si ambos son iguales muestre un mensaje por pantalla "son iguales"
-- y en otro caso muestre el mensaje "son distintos" --> NOTA, como hemos aprendido a reutilizar codigo 
-- y ya tenemos un procedimiento o función que compara dos números enteros, utilizar en este nuevo procedimiento
-- la función que ya hemos implementado antes para optimizar codigo.*/
delimiter $$
create function Iguales_o_no (num1 int, num2 int)
returns varchar(50)
begin 
DECLARE Resultado VARCHAR(45);
DECLARE Comparacion INT;

IF ComparaEnteros2(num1, num2) = 0 THEN
	SET Resultado = 'son iguales';
ELSE 
	SET Resultado = 'son distintos';
END IF;
RETURN Resultado;
END $$


/*5. Ahora crear el PROGRAMA DatosDivision, (procedimiento o funcion segun tu decidas...),
--   que recibiendo como parámetro dos numeros enteros, devuelva el RESULTADO de la division 
-- (suele utilizarse tipo de datos float), y el RESTO de la división.*/
delimiter $$
create procedure programaDD (num1 INT, num2 INT, OUT Result FLOAT, OUT Resto INT)
BEGIN

SET Result = num1 / num2;
SET Resto = MOD(num1,num2);


END $$

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

use classicmodels;


set sql_safe_updates = 0;
set autocommit= 0;

update products
set productscale = case productscale
when '1:12' then '2:50'
when '1:10' then '9:50'
else 'Otros'
end;


rollback;
 
delimiter $$
create function calculaBenificio(costeproducto float, descuento float) 
returns decimal (9,2)
begin
	declare benificio decimal(9,2);
    set benificio = costeproducto - descuento;
    return benificio;
end$$


/*funcion precio de cada producto por cantidad de orden*/
delimiter $$
create function calcularPrecioTotal (precioUnidad float, cantidad int)
returns float
begin
declare precioCantidad float;
set precioCantidad = quantityordered * priceeach;
return precioCantidad;
end $$

SET GLOBAL log_bin_trust_function_creators = 1;

delimiter $$
create function segundaDireccion (nombre varchar(50), apellido varchar(50), direccion varchar(100))
returns varchar(150)
	begin
		if direccion is null then
			return 'no tiene segunda direccion';
		else
			return concat(nombre, ' ' , apellido, ' ', direccion, '- direccion completa');
	END IF;
    end $$
    
    
/* funcion primera letra mayuscula de un campo*/
delimiter $$
create function letraMayuscula (textoInput varchar(100))
returns varchar(100)
	begin
    declare textoOutput varchar(100);
    set textoOutput =concat(upper(substring(textoInput, 1, 1)), lower(substring(textoInput,2)));
    return textoOutput;
    end $$
    
delimiter $$
create function letraMayuscula2 (textoInput varchar(100))
returns varchar(1)
    begin
		declare letra varchar(1);
		set letra = upper(left(textoInput,1));
		return letra;
    end $$
    
/* funcion para calcular intervalo de fechas para el select : requireddate y shippeddate*/
delimiter $$
create function intervaloFechas(shipped date, required date)
returns int
	begin
		declare intervalFechas int;
        set intervalfechas = required - shipped;
        return intervalFechas;
	end $$



