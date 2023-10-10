USE classicmodels;

/*1.	Which customers are in the Southern Hemisphere?*/
SELECT contactfirstname, customerlocation
FROM customers
WHERE ST_Y(customerlocation)<0;

/*2. Which US customers are south west of the New York office?*/
SELECT  customername, customerlocation, o.city
FROM customers c JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o USING(officecode)
WHERE ST_Y(customerlocation) < ST_Y(officelocation) AND st_x(customerlocation) < st_x(officelocation)
AND o.city='NYC';

SELECT St_y(customerlocation) AS Y, st_x(customerlocation) AS X
FROM customers;

/* 3. ¿Qué clientes están más cerca de la oficina de Tokio (es decir, más cerca de Tokio que de cualquier otra oficina)?*/
SELECT customername, customerlocation, officelocation
FROM customers c JOIN employees e ON c.salesRepEmployeeNumber= e.employeeNumber
JOIN offices o USING(officecode)
WHERE c.country='Japan' and o.city='Tokyo'
GROUP BY 1,2,3
ORDER BY  st_distance(c.customerlocation, o.officelocation) ASC
LIMIT 1;



/* 4. ¿Qué cliente francés está más lejos de la oficina de París?*/
SELECT customername, o.city, o.officelocation
FROM customers c JOIN employees e ON c.salesRepEmployeeNumber=e.employeenumber
JOIN offices o USING(officecode)
WHERE c.country='France' AND o.city='Paris'
ORDER BY st_distance(c.customerlocation, O.OFFICELOCATION) desc;


/* 5. ¿Quién es el cliente más al norte?*/
SELECT customername, city, country
FROM customers 
ORDER BY ST_Y(customerlocation)
LIMIT 1; 


/*¿Cuál es la distancia entre las oficinas de París y Boston?*/
SELECT ofc.officecode , ofcc.officecode, st_distance(ofc.officelocation, ofcc.officelocation) AS distancia
FROM offices ofc JOIN offices ofcc ON ofc.officecode=ofcc.officecode
WHERE ofc.city='Paris' AND ofcc.city='Boston';

SELECT firstname, lastname, customernumber
FROM employees e left JOIN customers c ON e.employeeNumber= c.salesRepEmployeeNumber
WHERE c.customernumber IS NULL;

SELECT productcode, count(ordernumber) AS inOrders
FROM orderdetails
GROUP BY 1
HAVING inOrders>1;












 
