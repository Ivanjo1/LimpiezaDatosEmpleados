
CREATE DATABASE PortfolioProject_2;

USE PortfolioProject_2;

-- Limpieza de datos 
-- Importar archivo csv para la limpieza

-- Crear un procedimiento
DELIMITER //
CREATE PROCEDURE limp()
BEGIN 
  SELECT *
  FROM limpieza;
END //
DELIMITER ;

CALL limp();

-- cambiar el nombre de columnas con errores

ALTER  TABLE limpieza CHANGE COLUMN `ï»¿Id?empleado` id_emp VARCHAR (20) NULL ;
ALTER  TABLE limpieza CHANGE COLUMN `gÃ©nero` género VARCHAR (20) NULL ;

-- identificar si existen datos duplicados

SELECT id_emp, COUNT(*) AS cantidad_duplicados
FROM limpieza
GROUP BY id_emp
HAVING count(*) > 1;

-- contar el numero de duplicados

SELECT COUNT(*) AS cantidad_duplicados
FROM (
SELECT id_emp, COUNT(*) AS cantidad_duplicados
FROM limpieza
GROUP BY id_emp
HAVING count(*) > 1
) AS subquery;

RENAME TABLE limpieza TO duplicados;

-- crear tabla temporal sin duplicados

CREATE TEMPORARY TABLE nueva_limpieza AS 
SELECT DISTINCT *
FROM duplicados;

SELECT COUNT(*) AS conteo 
FROM duplicados;

SELECT COUNT(*) AS conteo 
FROM nueva_limpieza;

-- establecer la tabla temporal como la nueva tabla

CREATE TABLE limpieza AS SELECT * FROM
    nueva_limpieza;

DROP TABLE duplicados;

SET sql_safe_updates = 0;

-- cambiar otras columnas 

ALTER TABLE limpieza CHANGE COLUMN Apellido Last_name VARCHAR (50) NULL;
ALTER TABLE limpieza CHANGE COLUMN star_date Start_name VARCHAR (50) NULL;

DESCRIBE limpieza;

-- buscar nombres con espacios en blanco y eliminarlos

SELECT Name, TRIM(Name) as trim_name
FROM limpieza
WHERE length(Name) - length(trim(Name)) > 0;

-- actualizar la tabla
UPDATE limpieza
SET Name = trim(Name)
WHERE length(Name) - length(trim(Name)) > 0;

-- buscar apellidos dcon espacios en blanco y eliminarlos

SELECT Last_name, TRIM(Last_name) as trim_name
FROM limpieza
WHERE length(Last_name) - length(trim(Last_name)) > 0;

-- actualizar la tabla
UPDATE limpieza
SET Last_name = trim(Last_name)
WHERE length(Last_name) - length(trim(Last_name)) > 0;

-- cambiar otra columna

ALTER  TABLE limpieza CHANGE COLUMN `género` gender VARCHAR (20) NULL ;

-- establcer el genero en ingles ya que se encuentra en español los datos

SELECT 
    gender,
    CASE
        WHEN gender = 'hombre' THEN 'male'
        WHEN gender = 'mujer' THEN 'female'
        ELSE 'other'
    END AS gender1
FROM
    limpieza;

-- actualizar la tabla
UPDATE limpieza 
SET 
    gender = CASE
        WHEN gender = 'hombre' THEN 'male'
        WHEN gender = 'mujer' THEN 'female'
        ELSE 'other'
    END;

CALL limp;

-- cambiar otra columna

ALTER TABLE limpieza MODIFY COLUMN type TEXT;

-- cambiar los elemntos en la columna type

SELECT 
    type,
    CASE
        WHEN type = 1 THEN 'Remote'
        WHEN type = 1 THEN 'Hybrid'
        ELSE 'Other'
    END AS ejemplo
FROM
    limpieza;

-- actualizar la tabla
UPDATE limpieza 
SET 
    type = CASE
        WHEN type = 1 THEN 'Remote'
        WHEN type = 1 THEN 'Hybrid'
        ELSE 'Other'
    END;

-- elimar elementos extras en la columna salary

SELECT 
    salary,
    CAST(TRIM(REPLACE(REPLACE(salary, '$', ''),
                ',',
                ''))
        AS DECIMAL (15 , 2 )) AS salary1
FROM
    limpieza;

-- actualizar la tabla
UPDATE limpieza 
SET 
    salary = CAST(TRIM(REPLACE(REPLACE(salary, '$', ''),',',''))
        AS DECIMAL (15 , 2 ));

ALTER TABLE limpieza 
MODIFY COLUMN salary int null;

-- cambiar el formato de la fehca en la columna birth_date

SELECT 
    birth_date,
    CASE
        WHEN birth_date like '%/%' then date_format(str_to_date(birth_date, '%m/%d/%Y' ), '%Y-%m-%d')
        ELSE null
    END AS new_birth_date
FROM limpieza;

-- actualizar la tabla
UPDATE limpieza 
SET birth_date = CASE
        WHEN birth_date like '%/%' then date_format (str_to_date(birth_date, '%m/%d/%Y' ), '%Y-%m-%d')
        ELSE null
END;
    
ALTER TABLE limpieza 
MODIFY COLUMN birth_date date;

ALTER TABLE limpieza CHANGE COLUMN Start_name start_date VARCHAR (50) NULL;

-- cambiar el formato de la fehca en la columna start_name

SELECT 
    start_date,
    CASE
        WHEN start_date like '%/%' then date_format(str_to_date(start_date, '%m/%d/%Y' ), '%Y-%m-%d')
        ELSE null
    END AS new_start_date
FROM limpieza;

-- actualizar la tabla
UPDATE limpieza 
SET start_date = CASE
        WHEN start_date like '%/%' then date_format (str_to_date(start_date, '%m/%d/%Y' ), '%Y-%m-%d')
        ELSE null
END;

-- alterar el formato en la columna finish_date

-- convertir a objeto de fecha
SELECT finish_date, str_to_date(finish_date, '%Y-%m-%d %H:%i:%s') AS fecha 
FROM limpieza;

-- darle el formato deseado
SELECT finish_date, date_format(str_to_date(finish_date, '%Y-%m-%d %H:%i:%s'), '%Y-%m-%d') AS fecha
FROM limpieza;
 
-- actualizar la tabla
UPDATE limpieza
	SET finish_date = str_to_date(finish_date, '%Y-%m-%d %H:%i:%s UTC') 
	WHERE finish_date <> '';

UPDATE limpieza 
SET 
    finish_date = DATE_FORMAT(STR_TO_DATE(finish_date, '%Y-%m-%d %H:%i:%s'),'%Y-%m-%d')
WHERE
    finish_date <> '';


