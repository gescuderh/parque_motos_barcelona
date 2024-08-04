# Creamos la base de datos
CREATE DATABASE motosbcn;

# Seleccionamos la base de datos a utilizar
USE motosbcn;

# Realizamos una primera consulta para ver los datos
SELECT * FROM antiguedadmotosbcn;

# Para realizar el análisis del dataset primero debemos limpiar el dataset o crear una tabla temporal con los registros correctos

# OPCIÓN 1: LIMPIEZA DEL DATASET
# Quitamos el safe mode
SET SQL_SAFE_UPDATES = 0;

# Queremos eliminar todas las filas que contengan "No consta" en alguno de sus campos y "99" en Codi_Districte
DELETE FROM antiguedadmotosbcn
WHERE Antiguitat = "No consta";

DELETE FROM antiguedadmotosbcn
WHERE Codi_Districte = 99;

# Dataset limpio
SELECT * FROM antiguedadmotosbcn;

# OPCIÓN 2: CREAMOS UNA TABLA TEMPORAL
CREATE TEMPORARY TABLE antiguedadmotosbcn_valid AS
SELECT *
FROM antiguedadmotosbcn
WHERE Antiguitat != "No consta" OR Codi_Districte != 99;

# Dataset limpio en tabla temporal
SELECT * FROM antiguedadmotosbcn_valid;

# Activamos el safe mode
SET SQL_SAFE_UPDATES = 1;

# ANÁLISIS (Respondiendo a las preguntas planteadas) ¡¡TRABAJAREMOS CON LA TABLA TEMPORAL!!
# Cuantos distritos hay en Barcelona
SELECT COUNT(distinct(Codi_Districte)) as "Número de distritos de Barcelona"
FROM antiguedadmotosbcn_valid;

# Listado de distritos de Barcelona
SELECT distinct(Nom_Districte) as "Distritos de Barcelona"
FROM antiguedadmotosbcn_valid;

# Cuántos barrios hay en Barcelona
SELECT COUNT(distinct(Codi_Barri)) as "Número de barrios de Barcelona"
FROM antiguedadmotosbcn_valid;

# Listado de barrios de Barcelona
SELECT distinct(Nom_Barri) as "Barrios de Barcelona"
FROM antiguedadmotosbcn_valid;

# Cuál es el distrito de Barcelona con más barrios
SELECT Nom_Districte as "Distrito", COUNT(distinct(Codi_Barri)) as "Número de barrios"
FROM antiguedadmotosbcn_valid
GROUP BY Nom_Districte
ORDER BY 2 DESC LIMIT 1;

# Cuál es el distrito de Barcelona con menos barrios
SELECT Nom_Districte as "Distrito", COUNT(distinct(Codi_Barri)) as "Número de barrios"
FROM antiguedadmotosbcn_valid
GROUP BY Nom_Districte
ORDER BY 2 ASC LIMIT 1;

# Listado de distritos ordenados por número de barrios en orden decreciente
SELECT Nom_Districte as "Distrito", COUNT(distinct(Codi_Barri)) as "Número de barrios"
FROM antiguedadmotosbcn_valid
GROUP BY Nom_Districte
ORDER BY 2 DESC;

# Número total de motos por distrito y año
SELECT Any as "Año", Nom_Districte as "Distrito", SUM(Nombre_motos) as "Cantidad de motos"
FROM antiguedadmotosbcn_valid
GROUP BY Any, Nom_Districte;

# Número total de motos por distrito en los 10 años en orden decreciente
SELECT Nom_Districte as "Distrito", SUM(Nombre_motos) as "Cantidad de motos total 2007-2018"
FROM antiguedadmotosbcn_valid
GROUP BY Nom_Districte
ORDER BY 2 DESC;

# Distrito con un total de motos mayor en los 10 años
SELECT Nom_Districte as "Distrito", SUM(Nombre_motos) as "Cantidad de motos total 2007-2018"
FROM antiguedadmotosbcn_valid
GROUP BY Nom_Districte
ORDER BY 2 DESC LIMIT 1;

# Distrito con un total de motos menor en los 10 años
SELECT Nom_Districte as "Distrito", SUM(Nombre_motos) as "Cantidad de motos total 2007-2018"
FROM antiguedadmotosbcn_valid
GROUP BY Nom_Districte
ORDER BY 2 ASC LIMIT 1;

# Número total de motos por barrio y año
SELECT Any as "Año", Nom_Barri as "Barrio", SUM(Nombre_motos) as "Cantidad de motos"
FROM antiguedadmotosbcn_valid
GROUP BY Any, Nom_Barri;

# Número total de motos por barrio en los 10 años en orden decreciente
SELECT Nom_Barri as "Barrio", SUM(Nombre_motos) as "Cantidad de motos total 2007-2018"
FROM antiguedadmotosbcn_valid
GROUP BY Nom_Barri
ORDER BY 2 DESC;

# Barrio con un total de motos mayor en los 10 años
SELECT Nom_Barri as "Barrio", SUM(Nombre_motos) as "Cantidad de motos total 2007-2018"
FROM antiguedadmotosbcn_valid
GROUP BY Nom_Barri
ORDER BY 2 DESC LIMIT 1;

# Número total de motos en Barcelona por año
SELECT Any as "Año", SUM(Nombre_motos) as "Cantidad de motos"
FROM antiguedadmotosbcn_valid
GROUP BY Any;

# Número total de motos en Barcelona en los 10 años
SELECT SUM(Nombre_motos) as "Cantidad de motos total 2007-2018"
FROM antiguedadmotosbcn_valid;

# Año con más motos en Barcelona
SELECT Any as "Año", SUM(Nombre_motos) as "Cantidad de motos"
FROM antiguedadmotosbcn_valid
GROUP BY Any
ORDER BY 2 DESC LIMIT 1;

# Siendo el año 2012 el que más motos hubo en Barcelona, qué barrio aportó el mayor número de motos?
SELECT Nom_Barri as "Barrio", SUM(Nombre_motos) as "Cantidad de motos"
FROM antiguedadmotosbcn_valid
WHERE Any = 2012
GROUP BY Nom_Barri
ORDER BY 2 DESC LIMIT 1;

# Para cada año, cuál es el barrio de Barcelona con myor número de motos nuevas (Menos de 1 año de antigüedad)
# PASO 1: Debemos crear una tabla temporal para almacenar los datos agregados
CREATE TEMPORARY TABLE TempMotosPorBarrio AS
SELECT Any, Nom_Barri, SUM(Nombre_motos) as Cantidad_Motos
FROM antiguedadmotosbcn_valid
WHERE Antiguitat = "Menys d'un any d'antiguitat"
GROUP BY Any, Nom_Barri;

SELECT * FROM TempMotosPorBarrio;

# PASO 2: Debemos crear una tabla temporal para almacenar los máximos por año
CREATE TEMPORARY TABLE TempMaxMotosPorAño AS
SELECT Any, MAX(Cantidad_Motos) as Cantidad_Motos_Max
FROM TempMotosPorBarrio
GROUP BY Any;

SELECT * FROM TempMaxMotosPorAño;

# PASO 3: Seleccionar los barrios con más motos por año
SELECT t.Any as "Año", t.Nom_Barri as "Barrio", t.Cantidad_Motos as "Cantidad de motos con menos de 1 año de antigüedad"
FROM TempMotosPorBarrio t
JOIN TempMaxMotosPorAño m
ON t.Any = m.Any AND t.Cantidad_Motos = m.Cantidad_Motos_Max
ORDER BY t.Any;

# Para cada año, cuál es el barrio de Barcelona con mayor número de motos antiguas (> 10 años)
# PASO 1: Debemos crear una tabla temporal para almacenar los datos agregados
CREATE TEMPORARY TABLE TempMotosPorBarrio_v2 AS
SELECT Any, Nom_Barri, SUM(Nombre_motos) as Cantidad_Motos
FROM antiguedadmotosbcn_valid
WHERE Antiguitat IN ("Més de 10 anys","Més de 15 anys","Més de 20 anys","D'11 a 15 anys","D'11 a 20 anys")
GROUP BY Any, Nom_Barri;

SELECT * FROM TempMotosPorBarrio_v2;

# PASO 2: Debemos crear una tabla temporal para almacenar los máximos por año
CREATE TEMPORARY TABLE TempMaxMotosPorAño_v2 AS
SELECT Any, MAX(Cantidad_Motos) as Cantidad_Motos_Max
FROM TempMotosPorBarrio_v2
GROUP BY Any;

SELECT * FROM TempMaxMotosPorAño_v2;

# PASO 3: Seleccionar los barrios con más motos por año
SELECT t.Any as "Año", t.Nom_Barri as "Barrio", t.Cantidad_Motos as "Cantidad de motos más antiguas de 10 años"
FROM TempMotosPorBarrio_v2 t
JOIN TempMaxMotosPorAño_v2 m
ON t.Any = m.Any AND t.Cantidad_Motos = m.Cantidad_Motos_Max
ORDER BY t.Any;