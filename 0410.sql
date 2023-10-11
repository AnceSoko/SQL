/*+++++++++++++++++++++++++++++++++++++++ EJEMPLO EXAMEN PRÁCTICO +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/* 1.	Crea un procedimiento almacenado en el que solo se visualicen los productos con una cantidad de stock inferior a 140*/
use jardineria;

delimiter //
create procedure menos140 ()
begin
	select * from producto
    where cantidad_en_stock < 140;
end //

call menos140();



/* 2.	Crea un procedimiento que permita añadir y/o modificar el número de línea de los detalles de pedidos*/

delimiter //
create procedure anadirMod (
	in lineanumero smallint,
    in actual smallint)
begin 
	update detalle_pedido
    set numero_linea = lineanumero
    where numero_linea = actual;
end //

call anadirMod(3, 9);

set sql_safe_updates =0;


/* 3.	Crea un procedimiento que nos muestre el nombre y apellido juntos de los empleados, 
si el código jefe es 5 o menos debemos ver el texto JEFES_ANTIGUOS mientras que
 si es mayor de 5 aparezca JEFES_NUEVOS*/
 
 delimiter //
create procedure jefes()
begin
    select concat_ws(' ' ,nombre, apellido1, apellido2) as nombre_completo, codigo_jefe,
           case
               when codigo_jefe <= 5 then 'JEFES_ANTIGUOS'
               else 'JEFES_NUEVOS'
           end as jefes
    from empleado;
end //
delimiter ;
 
call jefes();
 

/* 4.	Crea un procedimiento de nombre credito_getMax() que guarde en variables
 locales los datos (codigocliente y limite_credito) del cliente con mayor límite de credito.
 Después debe mostrar en una única fila de nombre 'datos_credito' los datos del cliente encontrado*/
 delimiter //
 create procedure credito_getMax()
begin
	declare codigo int;
    declare credito decimal;
    
    select codigo_cliente, limite_credito
    into codigo, credito
    from cliente
    order by limite_credito desc
    limit 1;
    
    select codigo as codigo_cliente, credito as limite_credito;
end //
delimiter ;

call credito_getMax();

/* 5.	Crea un procedimiento que actualice el precio_venta de los productos ya que doblaremos 
el precio (hazlo con commit y rollback para no cambiar tu tabla)*/

delimiter //
create procedure doblePrecio()
begin
	update producto
	set precio_venta = precio_venta*2;
end //
    
start transaction;
call doblePrecio();
rollback;


/*+++++++++++++++++++++++++++++++++++++ TRIGGERS +++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*6.	Crea un trigger que no me permita introducir la gama carnes o pescados con una cantidad
 de stock mayor a 400 y aparezca el siguiente mensaje: Estas gamas y cantidades no pueden introducirse*/
 delimiter //
 create trigger gamaNueva
 before insert on producto
 for each row
 begin
	if (new.gama ='Carnes' or new.gama ='Pescados' and new.cantidad_en_stock > 400) then
		signal sqlstate '45000' set message_text = 'Estas gamas y cantidades no pueden introducirse';
	end if;
end //
delimiter ;

drop trigger gamaNueva;
insert into producto(codigo_producto, nombre, gama, cantidad_en_stock, precio_venta) values('AS-23', 'Chuleta', 'Carnes',  450, 34.34);
SET FOREIGN_KEY_CHECKS=0;


/* 7.	Cuando insertemos un nuevo cliente tendremos un trigger que registrará el usuario la fecha
 de inserción, la acción realizada, y un concat con nombre,
 apellido1 y apellido2 y guardaremos los nuevos datos*/
create table clientesTrigger(
	usuario varchar(30),
    fecha_insercion date,
    accion varchar(30),
    nuevosdatos varchar(255));
    
delimiter //
create trigger nuevoCliente
after insert on cliente
for each row
begin
	insert into clientestrigger (usuario, fecha_insercion, accion, nuevosdatos)
    values (user(), now(), 'insertar', new.nombre_cliente);
end //
delimiter ;

insert into cliente(codigo_cliente, nombre_cliente, telefono, fax, linea_direccion1, ciudad, codigo_empleado_rep_ventas)
 values(39, 'Elizabeth Moreno', '456357', '34354545', 'Linea ciudad 18', 'Majadahonda', 5);
 
 
/* 8.	Crea un trigger en el que se cuenten los clientes (contadorClientes)*/
delimiter //
create trigger contadorCliente
after insert on cliente
for each row
begin
	insert into clientestrigger (fecha_insercion,cantidad_clientes)
    values(NOW(),(select count(*) from cliente));
    
   -- update cantidad_clientes = cantidad_clientes + new.clantidad_cliente
end //
delimiter ;
  
drop trigger contadorCliente;
insert into cliente(codigo_cliente, nombre_cliente, telefono, fax, linea_direccion1, ciudad, codigo_empleado_rep_ventas)
 values(51, 'Salchicha', '43356357', '234354545', 'Linea ciudad 20', 'Majadahonda', 5); 
 
insert into cliente(codigo_cliente, nombre_cliente, telefono, fax, linea_direccion1, ciudad, codigo_empleado_rep_ventas)
 values(41, 'Maria Pesada', '78356357', '2398754545', 'Linea ciudad 21', 'Majadahonda', 4);    
 
 insert into cliente(codigo_cliente, nombre_cliente, telefono, fax, linea_direccion1, ciudad, codigo_empleado_rep_ventas)
 values(42, 'Samuel Pescado', '7854556357', '2398754545', 'Linea ciudad 21', 'Majadahonda', 4);
    
    
/* 9.	Haz que si se intenta dar de alta un nuevo artista y se envía un nif_jefe que no exista, se cambie su valor por null.*/
use circo;

delimiter //
create trigger jefeNoExiste
before insert on artistas
for each row
begin
	if(new.nif_jefe <> nif_jefe) then 
    insert into artistas (nif, apellidos, nombre, nif_jefe) values(new.nif, new.apellidos, new.nombre, 'Null');
    else insert into artistas(nif, apellidos, nombre, nif_jefe) values(new.nif, new.apellidos, new.nombre, new.nif_jefe);
    end if;
end //
delimiter ;

drop trigger jefeNoExiste;
insert into artistas(nif, apellidos, nombre, nif_jefe) values('123A', 'Soko','Ancelotti', '123456');

set FOREIGN_KEY_CHECKS=0;


/* 10.	Haz todo lo necesario para que el campo ganancias de la tabla ATRACCIONES se actualice cuando se añadan,
 borren o modifiquen datos en la tabla ATRACCION_DIA.
Si al añadir una celebración nueva (ATRACCION_DIA) la fecha_inicio en ATRACCIONES es NULL, 
se debe de actualizar con la fecha actual. */
delimiter //
create trigger atraccionesMortales
after insert on atraccion_dia
for each row
begin
	update atracciones
    set ganancias = ganancias + new.ganancias
    where nombre = new.nombre_atraccion;
end //
delimiter ;

drop trigger atraccionesMortales;

insert into atraccion_dia values('El gran carnívoro', '2023-10-05', 84, 100);
/*43112.00*/
delimiter //
create trigger atraccionesMortales2
after update on atraccion_dia
for each row
begin
	if old.ganancias <> new.ganancias then 
	update atracciones
    set ganancias = ganancias - old.ganancias + new.ganancias
    where nombre = new.nombre_atraccion;
    end if;
end //
delimiter ;

drop trigger atraccionesMortales2;
update atraccion_dia set ganancias =200 where ganancias =100;
/*43212.00*/
set sql_safe_updates=0;


delimiter //
create trigger atraccionesMortales3
after delete on atraccion_dia
for each row
begin
	update atracciones
    set ganancias = ganancias - old.ganancias
    where nombre = old.nombre_atraccion;
end //
delimiter ;

delete from atraccion_dia where ganancias= 200;














