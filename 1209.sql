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
    



    



