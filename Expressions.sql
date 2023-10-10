USE classicmodels;

/*1.	Prepare a list of offices sorted by country, state, city.*/
SELECT officecode, country, state, city
FROM offices
ORDER BY 2,3,4; 

/*2.	How many employees are there in the company?*/
SELECT count(employeenumber)AS COUNT FROM employees;

/*3.	What is the total of payments received?*/
SELECT concat('$ ', sum(amount)) AS TOTAL FROM payments;

/*4.	List the product lines that contain 'Cars'*/
SELECT productline FROM productlines WHERE productline LIKE '%cars%';

/*5.	Report total payments for October 28, 2004*/
SELECT * FROM payments WHERE paymentDate='2004-10-28';

/*6.	Report those payments greater than $100,000*/
SELECT * FROM payments WHERE amount>100.000;

/*7.	List the products in each product line.*/
SELECT productname, productline FROM products
ORDER BY 2;

/*8.	How many products in each product line?*/
SELECT count(*), productline FROM products
GROUP BY 2;

/*9.	What is the minimum payment received*/
SELECT min(amount) as min FROM payments; 

SELECT * FROM payments ORDER BY amount ASC LIMIT 1;

/*10.	List all payments greater than twice the average payment*/
SELECT AVG(amount) avarage FROM payments;

SELECT * FROM payments WHERE amount> (SELECT 2*avg(amount) FROM payments);


/*11.	What is the average percentage markup of the MSRP on buyPrice? */
SELECT avg((msrp - buyprice) / buyprice*100) avarage FROM products;


/*12. How many distinct products does ClassicModels sell?*/
SELECT DISTINCT count(productcode) as cantidad FROM products;


/*13.	Report the name and city of customers who don't have sales representatives?*/
SELECT customername, city, salesrepemployeenumber FROM customers 
WHERE salesrepemployeenumber IS NULL;


/*14.	What are the names of executives with VP or Manager in their title? Use the CONCAT function
 to combine the employee's first name and last name into a single field for reporting.*/
 SELECT CONCAT_WS(' ' , firstname, lastname) AS names, jobtitle FROM employees WHERE jobtitle LIKE '%VP%' OR jobtitle like'%Manager%';
 
 
 /*15.	Which orders have a value greater than $5,000?*/
 SELECT  distinct ordernumber,  sum(quantityordered* priceeach) AS total FROM orderdetails
 GROUP BY ordernumber
 HAVING total>5000;
 
 
 /*++++++++++++++++++++++++++++++++++++++++++++ONE TO MANY RELATIONSHIP+++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /*1.	Report the account representative for each customer.*/
 SELECT customername, salesrepemployeenumber FROM customers
 order BY 1;
 
 SELECT customername, concat_ws(' ', contactfirstname, contactlastname) AS representative FROM customers
 WHERE salesrepemployeenumber IS NOT NULL
 ORDER BY customername;
 
 
 /*2.	Report total payments for Atelier graphique*/
 SELECT customername, sum(amount) AS total
 FROM customers c JOIN payments USING(customernumber)
 WHERE customername='Atelier graphique'
 GROUP BY 1;

/*3. Reporte los pagos totales por fecha*/
SELECT paymentdate, sum(amount)  as total
FROM payments
GROUP BY paymentdate
ORDER BY 1 asc;

/*4.	Report the products that have not been sold*/
SELECT productname, ordernumber 
FROM products
LEFT JOIN orderdetails USING (productcode)
WHERE ordernumber IS NULL;

/*5.	List the amount paid by each customer*/
SELECT customername, sum(amount) AS total
FROM customers JOIN payments USING (customernumber)
GROUP BY customername
ORDER BY 1 ASC;

/*6.	How many orders have been placed by Herkku Gifts?*/
SELECT customername, count(ordernumber) AS total
FROM customers JOIN orders USING(customernumber)
WHERE customername='Herkku Gifts'
GROUP BY customernumber;

/*7.	Who are the employees in Boston*/
SELECT employeenumber, firstname, lastname, city
FROM employees JOIN offices USING (officecode)
WHERE city='Boston';

/*8.	Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first*/
SELECT customername, amount 
FROM customers JOIN payments USING (customernumber)
WHERE amount>100.000
ORDER BY 1;

/*9. List the value of 'On Hold' orders.*/
SELECT count(ordernumber) AS totals, status FROM orders WHERE STATUS='On Hold';


/*10.	Report the number of orders 'On Hold' for each customer*/
SELECT customername, COUNT(ordernumber) AS cantidad, status
FROM customers JOIN orders USING (customernumber)
WHERE status='On hold'
GROUP BY 1;


/*+++++++++++++++++++++++++++++++++++++++++++++++++++MANY TO MANY RELATIONSHIP+++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*1.	List products sold by order date*/
SELECT orderdate , productname
FROM orderdetails JOIN products USING(productcode)
JOIN orders USING(ordernumber)
ORDER BY 1;

/*2.	List all the orders for the 1940 Ford Pickup Truck*/
SELECT productname, ordernumber
FROM products JOIN orderdetails USING(productcode)
WHERE productname='1940 Ford Pickup Truck';

/*3.	List the names of customers and the corresponding order numbers where a particular order 
from that customer has a value greater than $25,000?*/
SELECT customername, ordernumber, sum(quantityordered* priceeach) AS suma
FROM customers JOIN orders USING(customernumber)
JOIN orderdetails USING(ordernumber)
GROUP BY 1,2
HAVING suma>25000;

/*4.	Are there any products that appear on all orders?*/
SELECT p.productname 
FROM products p
WHERE NOT EXISTS( 
	SELECT ordernumber  
    FROM orders o
    WHERE NOT EXISTS(
		SELECT od.productcode
        FROM orderdetails od
        WHERE od.ordernumber = o.ordernumber
        AND od.productcode= p.productcode));
        
/*5.	List those orders containing items sold at less than the MSRP*/
SELECT ordernumber, productname, buyprice, MSRP
FROM products JOIN orderdetails USING(productcode)
WHERE buyprice<MSRP
ORDER BY 1;

/*6.	Reports those products that have been sold with a markup of 100% or more (i.e., the priceEach is at least twice the buy Price)*/
SELECT ordernumber, productname, priceeach, (priceeach - buyprice) AS markup, buyprice
FROM orderdetails od JOIN products p USING(productcode)
WHERE od.priceeach >= 2 * p.buyprice;

/*7.	List the products ordered on a Monday.*/
SELECT productname, orderdate, dayname(orderdate) AS dia
FROM products JOIN orderdetails USING(productcode)
JOIN orders USING(ordernumber)
HAVING dia='Monday';

/*8.	What is the quantity on hand for products listed on 'On Hold' orders?*/
SELECT ordernumber,COUNT(productcode) AS cantidadProductos, status
FROM orderdetails od JOIN orders USING(ordernumber)
WHERE status='On Hold'
GROUP BY 1;


/*+++++++++++++++++++++++++++++++++++++++++++++REGULAR EXPRESSIONS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*1.	Find products containing the name 'Ford'*/
SELECT productname FROM products 
WHERE productname LIKE '%Ford%';

/*2.	List products ending in 'ship'*/
SELECT productname FROM products 
WHERE productname LIKE '%Ship'; 

/*3.	Report the number of customers in Denmark, Norway , and Sweden*/
SELECT  country, count(customernumber) AS cantidad
FROM customers WHERE country IN('Denmark', 'Norway', 'Sweden')
GROUP BY 1;

/*4.	What are the products with a product code in the range S700_1000 to S700_1499?*/
SELECT productname, productcode 
FROM products
WHERE productcode BETWEEN 'S700_1000' AND 'S700_1499';

/*5.	Which customers have a digit in their name?*/
SELECT customername FROM customers
WHERE customername REGEXP('[0-9]');

/*6.	List the names of employees called Dianne or Diane*/
SELECT * FROM employees
WHERE firstname IN('Dianne','Diane');

/*7.	List the products containing ship or boat in their product name*/
SELECT productname FROM products
WHERE PRODUCTNAME like '%ship' OR productname LIKE '%boat%';

/*8.	List the products with a product code beginning with S700.*/
SELECT productcode, productname
FROM products
WHERE productcode LIKE 'S700%';

/*9.	List the names of employees called Larry or Barry */
SELECT * FROM employees
WHERE firstname IN('Larry','Barry');

/*10.	List the names of employees with non-alphabetic characters in their names*/
SELECT firstname, lastname 
FROM employees
WHERE firstname REGEXP('[^[A-Za-z]]') OR lastname REGEXP('[^[A-Za-z]]');

/*List the vendors whose name ends in Diecast*/
SELECT * 
FROM products
WHERE productvendor LIKE '%Diecast';


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++GENERAL QUERIES+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*1.	Who is at the top of the organization (i.e., reports to no one)*/
SELECT firstname, lastname 
FROM employees
WHERE reportsto IS NULL;

/*2.	Who reports to William Patterson*/
SELECT em.firstname, em.lastname 
FROM employees em JOIN employees re ON em.reportsto = re.employeenumber
WHERE re.firstname='William' AND re.lastname='Patterson';

/*3.	List all the products purchased by Herkku Gifts*/
SELECT productname, customername
FROM customers JOIN orders USING(customernumber)
JOIN orderdetails USING(ordernumber)
JOIN products USING(productcode)
WHERE customername='Herkku Gifts';

/*4.	Compute the commission for each sales representative, assuming the commission is 5%
of the cost of an order. Sort by employee last name and first name*/
SELECT lastname, firstname, sum(((quantityordered*priceeach)*0.05)) AS sincomission
FROM employees E join customers c ON e.employeenumber=c.salesrepemployeenumber
JOIN orders USING(customernumber)
JOIN orderdetails USING(ordernumber)
GROUP BY 1,2
ORDER BY 2,1;

/*5.	What is the difference in days between the most recent and oldest order date in the Orders file?*/
SELECT max(orderdate) AS newest, min(orderdate) AS oldest, datediff(max(orderdate),min(orderdate)) AS diferencia
FROM orders; 

/*6.	Compute the average time between order date and ship date for each customer ordered by the largest di ference*/
SELECT  customername, shippeddate, orderdate, datediff(shippeddate, orderdate) AS DIFERENCIA
FROM customers c JOIN orders USING(customernumber)
ORDER BY diferencia DESC;

/*7.	What is the value of orders shipped in August 2004? ( Hint)*/
SELECT ordernumber, shippeddate, MONTHNAME(shippeddate) AS mes, YEAR(shippeddate) AS año, sum(amount) as total
FROM orders o JOIN customers c USING(customernumber)
JOIN payments USING(customernumber)
where YEAR(SHIPPEDDATE)=2004
GROUP BY 1
HAVING mes='August';


/*8.	Compute the total value ordered, total amount paid, and their difference for each customer
 for orders placed in 2004 and payments received in 2004 (Hint; Create views for the total paid and total ordered)*/
CREATE VIEW TotalOrdered2004 AS
SELECT customernumber, customername, sum(quantityordered*priceeach) AS totalOrdered
FROM orders o  JOIN orderdetails od USING(ordernumber)
JOIN customers USING(customernumber)
WHERE o.orderDate BETWEEN '2004-01-01' AND '2004-12-31'
GROUP BY 1;

CREATE VIEW TotalPaid2004 AS
SELECT customernumber, customername, sum(amount) AS totalPaid
FROM customers c JOIN payments p USING (customernumber)
WHERE paymentDate BETWEEN '2004-01-01' AND '2004-12-31'
GROUP BY 1;

SELECT c.customernumber, c.customername, 
COALESCE(totalOrdered, 0) AS totalOrdered,
COALESCE(totalPaid, 0) AS totalPaid,
COALESCE(totalOrdered, 0) - COALESCE(totalPaid, 0) AS difference
FROM customers c
LEFT JOIN totalordered2004 USING(customernumber)
LEFT JOIN totalpaid2004 USING(customernumber);
    

/*9.	List the employees who report to those employees who report to Diane Murphy. Use the CONCAT function
 to combine the employee's first name and last name into a single field for reporting.*/
SELECT DISTINCT concat_ws(' ' , emp.firstname, emp.lastname) AS reportingEmployee
FROM employees emp JOIN employees m1 ON emp.reportsto = m1.employeeNumber
JOIN employees m2 ON m1.employeenumber = m2.reportsto
JOIN employees diane ON m2.reportsTo = diane.employeenumber
WHERE concat_ws(' ' , diane.firstname, diane.lastname) = 'Diane Murphy'; 


/*10.	What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first)*/
CREATE VIEW totalInventoryValues AS
SELECT productcode, productname, sum(quantityinstock*buyprice) AS inventoryvalue
FROM products
GROUP BY 1;

SELECT p.productcode, p.productname, p.quantityinstock, p.buyprice, t.inventoryvalue
(p.quantityenstock*p.buyprice/t.inventoryvalue)*100 AS precentagevalue
FROM products p JOIN totalinventoryvalues t USING(productcode)
ORDER BY percentagevalue DESC;


 
 
 
 
 
 
 
 
 
 
 
 













