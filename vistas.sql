USE classicmodels;

CREATE VIEW TelefonoCliente AS SELECT phone, customerName FROM customers;

/*crear una vista en la que el buyprice sea menor que 50*/
CREATE VIEW buyPriceMenor50 AS SELECT productName, buyPrice FROM products WHERE buyPrice<50;
DROP VIEW buyPriceMenor50;
CREATE VIEW buyPriceMenor50 AS SELECT * FROM products WHERE buyPrice<50 ORDER BY buyPrice asc;

/*crear una vista llamada contactocliente donde aparezca nombre cliente, telefono unido en 1 unica columna*/
CREATE VIEW contactoCliente AS SELECT CONCAT(customerName, phone) AS 'Nombre + Telefono' FROM customers;
DROP VIEW contactoCliente;

CREATE VIEW contactoCliente AS SELECT CONCAT_ws(' ',customerName, phone) AS 'Nombre + Telefono' FROM customers;

/*crear vista actualizacion de buyprice de los que cuesten 50 o mas a 100*/
UPDATE buyPriceMenor50 SET productName='Teresa' WHERE buyPrice<30;

SET SQL_SAFE_UPDATES=0;

drop view aumentoPrecio;
CREATE VIEW aumentoPrecio AS SELECT ordernumber, productCode, quantityordered, priceEach, orderlinenumber FROM orderdetails;

INSERT  INTO aumentoPrecio(ordernumber,productCode,QUANTITYORDERED, priceEach, orderlinenumber) VALUES (15945,'EZS-5748',1, 120.34,3);

select productName FROM products WHERE productCode='S24_2840';

/*Crea una vista llamada PRODUCTOSMASCAROS en la que se vean solo los 5 primeros, con su productline, productname y buyprice*/
CREATE VIEW productosMasCaros AS SELECT productLine, productname, buyprice FROM products ORDER BY buyPrice ASC LIMIT 5;
