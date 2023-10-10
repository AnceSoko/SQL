/*+++++++21.06.23+++++++++

DOS TABLAS RELACIONADAS
PRIMARY KEY 1
CAMPO DE NUMERACION 1
CAMPO DE SET 1
BOOL 1
SI NO META NADA SIEMRPRE SALGA NULL 1 2
VALOR POR DEFECTO 2
UN TIPO DE DATO SIN SIGNED 2
LA FECHA Y HORA ACTUAL 2
LA TABLA QUE LLEVA FK ON DELETE CASCADE ON UPDATE CASCADE
TRES REGISTROS COMPLETOS EN CADA TABLA
 archivo de un imagen
 UN CAMPO DE CHECK 2
 */
 
 USE clase;
 
 CREATE TABLE IF NOT EXISTS pais(
 idPais INT AUTO_INCREMENT PRIMARY KEY,
 nombrePais VARCHAR(20) NOT NULL,
 capital VARCHAR(20) NULL, 
 tipo ENUM('desarrollada','emergente','subdesarrollada'),
 formaGobierno SET('monarquia','republica','unipardista','daictadura'),
 miembroEU BOOL
 );
 
 CREATE TABLE IF NOT EXISTS presidentes(
 idPresidente INT UNSIGNED PRIMARY KEY,
 nombrePresidente VARCHAR(30) NOT NULL,
 apellidoPresidente VARCHAR(30),
 edad INT CHECK(edad>=18 AND edad<=110),
 estadoLaboral VARCHAR(20) DEFAULT 'Ejercitando',
 creado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 foto BLOB,
 pais INT,
 FOREIGN KEY(pais) REFERENCES pais(idPais)
 ON DELETE CASCADE
 ON UPDATE CASCADE
 );
 
 
 
 