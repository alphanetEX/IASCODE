CREATE DATABASE feriados;
use feriados;

GRANT ALL PRIVILEGES ON feriados . * TO 'lcars'@'localhost';

CREATE TABLE tipo_feriado(
    tipo VARCHAR(45) NOT NULL UNIQUE, 
    id_tferiado SERIAL NOT NULL, 
    CONSTRAINT tipoferiado_pk PRIMARY KEY (id_tferiado)
);

CREATE TABLE feriados(
    fecha DATE NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    id_tferiado INT NOT NULL, 
    id_feriado SERIAL NOT NULL,
    CONSTRAINT feriado_pk PRIMARY KEY (id_feriado)
);

INSERT  INTO tipo_feriado(tipo) VALUES 
('Feriados inamovibles')
,('Feriados trasladables')
,('Días no laborables')
,('Turísticos');

INSERT INTO feriados (fecha, titulo, id_tferiado) VALUES
('2022/01/01', 'Año Nuevo', 1), 
('2022/02/28', 'carnaval', 1),
('2022/03/01', 'carnaval b', 1), 
('2022/03/24', 'dia nacion de la memoria por la verdad y justicia', 1),
('2022/04/24', 'Dia del veterano Día del Veterano y de los Caídos en la Guerra de Malvinas', 1), 
('2022/04/14', 'Jueves Santo',3),
('2022/04/15', 'Viernes santo', 1),
('2022/04/16', 'Primeros dos días de la Pascua Judía',3),
('2022/04/17', 'Primeros dos días de la Pascua Judía (b)',3),
('2022/04/22', 'Últimos dos días de la Pascua Judía ',3),
('2022/04/23', 'Últimos dos días de la Pascua Judía (b)',3),
('2022/04/24', 'Día de acción por la tolerancia y el respeto entre los pueblos (a)',3),
('2022/05/1', 'Día del Trabajador',1),
('2022/05/2', 'Fiesta de la Ruptura del Ayuno del Sagrado Mes de Ramadán (Id al-Fitr) (c)',1),
('2022/05/2', 'Censo nacional 2022',1),
('2022/05/25','Día de la Revolución de Mayo',1),
('2022/06/17','Paso a la Inmortalidad del Gral. Don Martín Miguel de Güemes',2), 
('2022/06/20','Paso a la Inmortalidad del Gral. Manuel Belgrano',1),
('2022/07/09','Día de la Independencia',1),
('2022/07/30','Año Nuevo Islámico',1),
('2022/08/15','Paso a la Inmortalidad del Gral. José de San Martín (17/8)', 2),
('2022/08/15','Paso a la Inmortalidad del Gral. José de San Martín (17/8)', 2),
('2022/09/26','Año Nuevo Judío (b)', 3),
('2022/09/27','Año Nuevo Judío (b)', 3),
('2022/10/05','Día del Perdón (b)', 3),
('2022/10/07','Feriado con fines turísticos', 4),
('2022/10/10','Día del Respeto a la Diversidad Cultural (12/10)', 2),
('2022/11/20','Día de la Soberanía Nacional', 2),
('2022/11/21','Feriado con fines turísticos', 4),
('2022/12/08','Inmaculada Concepción de María', 1),
('2022/12/09','Feriado con fines turísticos', 4),
('2022/12/25','Navidad', 1);




