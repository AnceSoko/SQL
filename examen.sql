/* EXAMEN ANCE SOKOLOVSKA 06.10.2023. */

/*1.Crea un trigger en el que al introducir el nombre de &#39;Nogal o Enciana y el proveedor Yarte
Proveedores te salga el siguiente mensaje de error: Estos arboles no pueden catalogarse dentro de
la BD*/
use jardineria;

delimiter //
create trigger noSePuede
before insert on producto
for each row
begin 
	if (new.nombre ='Nogal' or new.nombre = 'Enciana' and new.proveedor = 'Yarte Proveedores') then
		signal sqlstate '45000' set message_text = 'Estos arboles no pueden catalogarse dentro de
		la BD';
	end if;
end //
delimiter ;

insert into producto values('123asd', 'Nogal', 'Frutales', '123-34', 'Yarte Proveedores', 'vamos a ver', 23, 12.34, 15.34);



/* 2. Crea un trigger en el que cada vez que se añada una oficina nueva se contabilicen en un nuevo
campo llamado TOTALOFICINAS(crea otra tabla en la que añadas tipo y TOTAL, cuando añadas una
ofi se sume y cuando borres otra se reste)*/
create table totalOficinas(
	tipo varchar(30),
    total int);

delimiter //
create trigger nuevaOficinaMas
after insert on oficina
for each row
begin
	insert into totaloficinas(tipo, total)
    values ('insertar', (select count(*) from oficina));
end //
delimiter ;

insert into oficina values(123, 'Madird', 'España', 'Madrid', '20221','1234', 'Calle Goya', 'Calle Velazquez');

delimiter //
create trigger nuevaOficinaMenos
after delete on oficina
for each row
begin
	insert into totaloficinas(tipo, total)
    values ('borrar', (select count(*) from oficina));
end //
delimiter ;

delete from oficina where codigo_oficina = '123';

set sql_safe_updates=0;



/* 3. Crea un trigger para que cuando insertemos una nueva oficina tendremos un trigger que registrará
el usuario, la fecha de inserción y la acción realizada. Para realizar el trigger usaremos un concat
con el código y el nombre de la ciudad) y guardaremos los nuevos datos
SEN27-INFORME DE PRUEBA PRÁCTICA*/
create  table registrosNuevos(
	usuario varchar(30),
    fecha date,
    accion varchar(30));
    
delimiter //
create trigger RegistroNuevo
after insert on oficina
for each row
begin
	insert into registrosnuevos(usuario, fecha, accion, datos)
    values (user(), now(), concat_ws(' ', new.codigo_oficina, new.ciudad));
end //
delimiter ;

insert into oficina(codigo_oficina, ciudad, pais, codigo_postal, telefono, linea_direccion1)
 values('345', 'Bilbao', 'España', '234', '34565787', 'Calle Noseque' );
 
 
 /*++++++++++++++++++++++++++++++++++++++ PROCEDIMIENTOS ++++++++++++++++++++++++++++++++++++++++++++++++*/
 
/* 4. CREA UN PROCEDIMIENTO QUE ACTUALICE TODOS LOS CAMPOS DE DIRECCION2 Y DONDE ESTÉ VACÍO SE INTRODUZCA ‘NO HAY
SEGUDNA DIRECCIÓN*/

delimiter  //
create procedure actualizarDireccion2()
begin
    update cliente
    set linea_direccion2 = 'NO HAY'
    where linea_direccion2 is null;
end //
delimiter ;

call actualizarDireccion2();


/*5.  CREA UN PROCEDIMIENTO EN DETALLE_PEDIDO EN EL QUE SI INTRODUCES UN PRODUCTO CON UNA CANTIDAD MENOR DE 50
APAREZCA ‘POCOS PRODUCTOS’ Y SI APARECEN + DE 50 PRODUCTOS APAREZCA ‘MUCHOS PRODUCTOS’*/

delimiter //
create procedure cantidadPro(
	in Producto varchar(255),
	in Cantidad int)
begin
    if Cantidad < 50 then
        select 'POCOS PRODUCTOS' as Resultado;
    else
        select 'MUCHOS PRODUCTOS' as Resultado;
    end if;
end //
delimiter ;

call cantidadPro('pan', 65);

/* 6. Crea un procedimiento de visualización en el que solo se vean los pagos realizados con Paypal cuyo total sea
superior a 5000.00*/

delimiter //
create procedure paypal()
begin
    select *
    from  pago
    where forma_pago = 'PayPal' and Total > 5000.00;
end //
delimiter ;

call paypal();