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
                                
                                


                        













