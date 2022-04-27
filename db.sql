CREATE DATABASE ingenieria;
USE ingenieria;

CREATE USER 'lcars'@'localhost' IDENTIFIED BY 'NCC1701D';
ALTER USER 'lcars'@'localhost' IDENTIFIED WITH mysql_native_password BY 'NCC1701D';
GRANT ALL PRIVILEGES ON ingenieria . * TO 'lcars'@'localhost';



CREATE TABLE alumnos ( legajo VARCHAR(10), apellido VARCHAR(20), nombres VARCHAR(20));
CREATE TABLE modulos ( cod_modulo VARCHAR(8), nom_modulo VARCHAR(20));
CREATE TABLE notas ( legajo VARCHAR(10), cod_modulo VARCHAR(8), nota FLOAT);
INSERT INTO alumnos VALUES ('20060101','Piccard','Jean Luc');
INSERT INTO alumnos VALUES ('20060102','Riker','William');
INSERT INTO alumnos VALUES ('20060103','LaForge','Geordi');
INSERT INTO alumnos VALUES ('20060104','Crusher','Beverly');
INSERT INTO alumnos VALUES ('20060105','Janeway','Katherine');
INSERT INTO modulos VALUES ('CM0001', 'Computacion Aplicada');
INSERT INTO modulos VALUES ('CM0002', 'Programación 2');
INSERT INTO modulos VALUES ('CM0003', 'Sistemas Operativos');
INSERT INTO modulos VALUES ('CM0004', 'Matemática Discreta');
INSERT INTO notas VALUES ('20060101', 'CM0001', 8);
INSERT INTO notas VALUES ('20060101', 'CM0002', 6.5);
INSERT INTO notas VALUES ('20060101', 'CM0003', 5);
INSERT INTO notas VALUES ('20060102', 'CM0001', 7.5);
INSERT INTO notas VALUES ('20060102', 'CM0003', 4.5);
INSERT INTO notas VALUES ('20060102', 'CM0004', 7);
INSERT INTO notas VALUES ('20060103', 'CM0001', 6);
INSERT INTO notas VALUES ('20060103', 'CM0002', 7.5);
INSERT INTO notas VALUES ('20060103', 'CM0004', 6);
INSERT INTO notas VALUES ('20060104', 'CM0001', 5.5);
INSERT INTO notas VALUES ('20060104', 'CM0002', 4);
INSERT INTO notas VALUES ('20060104', 'CM0003', 4.5);
INSERT INTO notas VALUES ('20060105', 'CM0001', 5.5);
INSERT INTO notas VALUES ('20060105', 'CM0002', 5);
INSERT INTO notas VALUES ('20060105', 'CM0004', 6.5);