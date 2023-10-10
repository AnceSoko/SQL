delimiter //
CREATE PROCEDURE consultaClientes ()
BEGIN
	select customerName, city, state, postalCode, country
	from customers
	order by customerName;
END //

delimiter ;

call consultaClientes();

delimiter //
create procedure getemployeeByID (in id int)
begin
	select * from employees where employeenumber = id;
end //

delimiter ;

call getEmployeeByID(1056);

delimiter //
CREATE PROCEDURE consultaClientesUSA ()
BEGIN
	select customerName, city, state, postalCode, country
	from customers
    where country = 'USA'
	order by customerName;
END //

delimiter ;

call consultaClientesUSA();

delimiter //
create procedure insertarDatos(
    in customerNumber int,   -- Replace with the actual data types and column names
    in checkNumber varchar(50),
    in paymentDate date,
    in amount decimal(10,2)
)
begin
    insert into payments (customerNumber, checkNumber, paymentDate, amount)  -- Replace with your actual column names
    VALUES (customerNumber, checkNumber, paymentDate, amount);
END //
DELIMITER ;

call insertarDatos(497, 'AS456790', '2023-09-22', 123.45);

SET FOREIGN_KEY_CHECKS=0;


delimiter //
create procedure nuevoVendedor(
	in nombre varchar(50),
    in nif varchar(9)
    )
begin
	insert into vendedores (NombreVendedor, NIF)
    values (nombre, nif);
end //

delimiter ;

call nuevoVendedor('Emilio', '34859634A');
call nuevoVendedor('Ance','23874930E');

delimiter //
create procedure actualiza(
	in idVendedor int,
    in direccion varchar(50),
    in poblacion varchar(50)
    )
begin
	update vendedores set idVendedor = idVendedor, direccion = direccion, poblacion = poblacion
    where nombreVendedor = 'Carmen';
end //

call actualiza(15, 'Calle dieciocho', 'El Escorial');

SET SQL_SAFE_UPDATES=0;

delimiter ;

delimiter //
create procedure actualizaConID(
	in idVend int,
    in direccion varchar(50),
    in poblacion varchar(50)
    )
begin
	update vendedores set idVendedor = idVendedor, direccion = direccion, poblacion = poblacion
    where idVendedor = idVend;
end //

insert into vendedores values(17, 'Laura', '2023-01-12', '48392049P', '1992-07-15', 'Calle Monte', 'Riga', '3876', '458392000', 'soltera', 1, 31);

call actualizaConID (17, 'Calle nulo', 'Madrid');


delimiter //
create procedure stockProducto (
		in codigo varchar(15),
begin
	declare statusStock varchar(50);
    
    select quantityinstock into statusStock
    from products
    where productCode = codigo;
    
	if statusStock>0 
    then select concat('producto', productCode, ' está en el stock') as resultado;
    else select concat('producto', productCode, ' no está en el stock') as resultado;
    end if;
end //



delimiter //
create procedure nuevosproductos(
		in productname varchar(50),
        in productline varchar(50),
        in buyprice decimal(10,2),
        in quantityinstock smallint
        )
begin 
	if productline = 'nuevo' then
    insert into products values (productname, buyprice, quantityinstock);
    else if productline = 'editar' then
    update products set productname = productname, buyprice = buyprice, quantityinstock = quantityinstock
    where productcode = productcode;
    end if;
    end if;
end //

start transaction;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
END;
call nuevosproductos('xxx','nuevo', 12.23, 2);
rollback;






/*1.CREA UN PROCE ALMACENADO PARA INSERTAR UN NUEVO PRODUCTO, PRECIO Y CANTIDAD EN PRODDUCTOS*/
delimiter //
create procedure nuevoProducto (
        in nombre varchar(50),
        in precio double,
        in cant varchar(255)
        )
begin 
 insert into productos (nomProducto, precio, cantidad)
 values (nombre, precio, cant);
end //

call nuevoProducto('Higos', 12.99, '143');


/* 2.CREA UN PROCEDIMIENTO PARA VISUALIZAR TODOS LOS VENDEDORES POR POBLACION USANDO UN COUNT*/
delimiter //
create procedure poblacion ()
	select count(*), poblacion
    from vendedores
    group by poblacion;
end //

call poblacion();


/*3.CREA UN PROC ALMA QUE ACTUALICE LOS DATOS DE LA TABLA PRODUCTOS DONDE EL NOMBRE DE PRODUCTO SEA LECHUGAS
Y MODIFICA TODA LA INFORMACION DEL PRODUCTO*/
delimiter //
create procedure actualizaLechugas (
	in id int,
    in grupo int,
    in precio double,
    in cant varchar(255),
    in tot float,
    in iva float
    )
begin 
	update productos set idProducto = id, idgrupo = grupo, precio = precio, cantidad = cant,
		total = tot, iva = iva
	where nomProducto = 'Lechugas';
end //

call actualizaLechugas(16, 6, 3.56, 467, 123.67, 0.12 );

SET SQL_SAFE_UPDATES=0;



/* 4.CREA UN PROCED PARA INSERTAR DATOS EN LOS KILOS DE LOS PRODUCTOS*/
delimiter //
create procedure nuevosKilos (
		in kg double)
begin
	insert into ventas (Kilos)
	values (kg);
end //

call nuevosKilos(12);


/* 5. EN LA TABLA GRUPOS CREA UN PROCED DE INSERTAR DATOS EN ID Y FRUTAS, PARA IR CREANDO NUEVAS CATEGORIAS*/
delimiter //
create procedure nuevosGrupos (
	in id int,
    in frutitas varchar(50)
    )
begin
	insert into grupos (idGrupo, frutas)
    values (id, frutitas);
end //

call nuevosGrupos(4, 'Con hueso');


