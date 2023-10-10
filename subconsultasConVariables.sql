/* 1. Asignaturas que no tienen asignado ningún profesor*/
use universidad;
select * 
from asignatura a
where id_profesor not in (select id_profesor
							from profesor p 
                            where p.id_profesor = a.id_profesor);

/* 4. Devuelve un listado con los profesores que tienen un departamento asociado y que no imparten ninguna asignatura*/
select *
from profesor
where profesor.id_profesor not in (
    select distinct asignatura.id_profesor
    from asignatura
);

select * 
from persona p join profesor pro on p.id = pro.id_profesor
where tipo = 'profesor'
and  pro.id_profesor not in (
    select distinct asignatura.id_profesor
    from asignatura
);


/*8. Crea una función en la que los grados cuyo id del 1 al 6 aparezca INGENIERIAS, el 7 Tecnología, 8 Ambiente y 9 y 10 Ciencias.*/
delimiter //
create function tipoGrado(id int)
returns varchar(30)
	begin	
    declare tipo varchar(30);
		case 
			when id between 1 and 6 
            then return 'INGENIERIAS';
            when id = 7 
            then return 'TECNOLOGIA';
            when id = 8
            then return 'AMBIENTE';
            else return 'CIENCIAS';
		end case;
	end //
    
select id, nombre, tipoGrado(id) from grado;
            
delimiter ; 
		
/* 2. Nombre y apellido de los empleados cuya comisión es menor que la de Juan Gómez*/
use ventas;
select nombre, apellido1, comisión
from comercial
where comisión < (select comisión
					from comercial
                    where nombre = 'Juan'
                    and apellido1 = 'Gómez');


/* 3. Devuelve la fecha y la cantidad del pedido de menor valor realizado por el cliente Pepe Ruiz Santana*/
select fecha, total, id_cliente
from pedido
where total = (
    select MIN(total)
    from pedido
    where id_cliente = (
        select id
        from cliente
        where nombre = 'Pepe'
        and apellido1 ='Ruiz'
    )
);


/* 10. Usando la variable IF crea una consulta en la que veamos aquellos empleados 
cuya categoría es mayor de 100 y viven en Almería y veamos: ANDALUCIA ALTO*/
select *,
if (categoría>100 and ciudad = 'Almería', 'ANDALUCIA ALTO', '') as consulta
from comercial c join pedido p 
on c.id = p.id_comercial join cliente cl
on p.id_cliente = cl.id
where categoría > 100
and ciudad ='Almería' ;
 



/* 5. Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada*/
use empleados;
select nombre, presupuesto
from departamento
where presupuesto>= all(select presupuesto from departamento);


/* 9. En la tabla departamentos tenemos el presupuesto y los gastos. 
Calcula el beneficio que saca cada departamento a través de una función. */
delimiter //
create function benificio(id int)
returns int
	begin
		declare calculo int;
        set calculo = presupuesto - gastos;
        return calculo;
	end //

select  id, nombre, benificio(id) from departamento;



/* 6. Crea una función en la que se contabilicen todos los pedidos con más unidades de 67 en cantidad.
 Los que tienen + de 67 unidades que aparezca Unidades_elevadas y por debajo de 67 Unidades_bajas.*/
use jardineria;
delimiter //
create function cantidadUnidades(codigo int)
returns varchar(30)
	begin
		declare total varchar(30);
        set total = (select count(*) from detalle_pedido where codigo_pedido=codigo);
        if total>= 67 then return 'Unidades elevadas';
        else return 'Unidades bajas';
        end if;
	end //
    
select codigo_pedido, count(*), cantidadUnidades(codigo_pedido) from detalle_pedido group by 1;


/* 7. Crea una función en la que vea el intervalo de días que pasan desde que se ha realizado un pedido hasta que se ha entregado.*/
delimiter //
create function intervalo(pedido int)
returns int
	begin
		declare tiempo int;
        set tiempo = fecha_entrega - fecha_pedido;
        return tiempo;
	end //
    
 





