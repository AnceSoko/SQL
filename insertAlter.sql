USE clase;
@@@author Ance;

 CREATE TABLE IF NOT EXISTS pais(
 idPais INT AUTO_INCREMENT PRIMARY KEY,
 nombrePais VARCHAR(20) NOT NULL,
 capital VARCHAR(20) NULL, 
 tipo ENUM('desarrollada','emergente','subdesarrollada'),
 formaGobierno SET('monarquia','republica','unipardista','daictadura'),
 miembroEU BOOL
 );
 set sql_safe_updates = 0;

 UPDATE pais SET formaGobierno = REPLACE(formaGobierno, 'daictadura', 'dictadura')
 WHERE find_in_set('daictadura', formaGobierno)>0;
 
INSERT INTO pais(nombrePais, capital, tipo, formaGobierno, miembroEU) VALUES('Letonia','Riga','desarrollada','republica',true);
INSERT INTO pais(nombrePais, capital, tipo, formaGobierno, miembroEU) VALUES('España','Madrid','desarrollada','republica',true);
INSERT INTO pais(nombrePais, capital, tipo, formaGobierno, miembroEU) VALUES('Suecia','Estocolmo','desarrollada','republica',true);
INSERT INTO pais(nombrePais, capital, tipo, formaGobierno, miembroEU) VALUES('Corea del Norte', 'Pyongyang', 'emergente', 'daictadura', false);

 CREATE TABLE IF NOT EXISTS presidentes(
 idPresidente INT auto_increment PRIMARY KEY,
 nombrePresidente VARCHAR(30) NOT NULL,
 apellidoPresidente VARCHAR(30),
 edad INT  UNSIGNED CHECK(edad>=18 AND edad<=110),
 estadoLaboral VARCHAR(20) DEFAULT 'Ejercitando',
 creado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 foto BLOB,
 pais INT,
 FOREIGN KEY(pais) REFERENCES pais(idPais)
 ON DELETE CASCADE
 ON UPDATE CASCADE
 );

ALTER TABLE presidentes MODIFY COLUMN idPresidente INT AUTO_INCREMENT;

INSERT INTO presidentes (nombrePresidente, apellidoPresidente, edad, pais) VALUES('Egils', 'Levits', 67, 1);
INSERT INTO presidentes (nombrePresidente, apellidoPresidente, edad, pais) VALUES('Pedro', 'Sanchez', 51, 2);
INSERT INTO presidentes (nombrePresidente, apellidoPresidente, edad, pais) VALUES('Carl XVI', 'Gustaf', 77, 3);
