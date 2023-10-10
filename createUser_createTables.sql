CREATE USER 'Ance'@'%' IDENTIFIED BY '1606as'; /*how to create an user, % means that it can be accessed from any computer*/
select *from vuelo;

USE vuelos;

CREATE TABLE IF NOT EXISTS vuelo(
numero INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
aeroInic VARCHAR(50),
aeroFin VARCHAR(50),
diaSal DATE,
diaLleg DATE,
horaSal TIME,
horaLleg TIME,
avion VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS disponibilidad(
idDispon INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
clase ENUM('1','2'),
plazas INT CHECK(plazas>1 AND plazas<325),
maxPlazas INT,
precio INT CHECK(precio>50 AND precio<200),
numVuelo INT,
FOREIGN KEY(numVuelo) REFERENCES vuelo(numero)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS usuario(
dni VARCHAR(10) NOT NULL PRIMARY KEY,
nombre VARCHAR(20),
apellido1 VARCHAR(20),
apellido2 VARCHAR(20) NULL,
direccion VARCHAR(50),
nacionalidad VARCHAR(20) DEFAULT('espanola')
);

CREATE TABLE IF NOT EXISTS trayecto(
numero INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
dni VARCHAR(10),
FOREIGN KEY(dni) REFERENCES usuario(dni)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS legs(
clase ENUM('1','2') PRIMARY KEY,
numTray INT,
numVuelo INT,
FOREIGN KEY(numTray) REFERENCES trayecto(numero),
FOREIGN KEY(numVuelo) REFERENCES vuelo(numero)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

INSERT INTO usuario(dni, nombre, apellido1, apellido2, direccion) VALUES('71455263A', 'Teresa', 'Yarte', 'Aguado', 'Calle Goya');

INSERT INTO usuario(dni, nombre, apellido1, direccion, nacionalidad) VALUES('95632365H', 'Maria', 'Fernandez', 'Calle Murillo', 'mejicana');

ALTER TABLE vuelo RENAME COLUMN avion TO aviones; /*change name of column*/

ALTER TABLE legs RENAME TO distancia; /*change name of a table*/

ALTER TABLE trayecto ADD distancia INT(5); /*add a new column in a table*/

ALTER TABLE vuelo MODIFY COLUMN aviones VARCHAR(5) AFTER aeroFin;/*change the order of columns in table*/

ALTER TABLE usuario DROP COLUMN direccion;/*erase a column in a table*/

UPDATE usuario SET apellido2='Fleishman', nacionalidad='suiza' WHERE nombre='Maria';/*change surname and nationality*/

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE vuelo RENAME COLUMN horaSal TO horaSalida;



select current_timestamp(); /*returns current time*/

select now(); /*hour and date*/

USE vuelos;
CREATE TABLE IF NOT EXISTS fechas(
nombre VARCHAR(20),
apellido VARCHAR(20),
fecha TIMESTAMP DEFAULT current_timestamp
);

INSERT INTO fechas(nombre, apellido) VALUES('Ance','Sokolovska'); /*it will automatically show the column Fechas with the time when the register was created*/

CREATE TABLE booleanos( /*TO RETURN TRUE OR FALSE OR 1 AND 0*/
id INT PRIMARY KEY,
nombre VARCHAR(20),
casado BOOL
);

CREATE TABLE IF NOT EXISTS fotos(
ID INT AUTO_INCREMENT PRIMARY KEY,
image BLOB /*data type for photo*/
);

INSERT INTO fotos(image) VALUES(load_file('C:\\airplane1.jpg'));






