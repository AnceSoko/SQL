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



 

