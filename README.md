# parque_motos_barcelona

![foto_motoh](motohBarcelona.jfif)

Este proyecto consiste en una práctica de unión de archivos .csv para conformar el dataset final y consultas en MySQL sobre el parque de motocicletas de Barcelona en los años 2007-2018.

El dataset analizado en este proyecto se ha obtenido del repositorio "Open Data BCN" del Ayuntamiento de Barcelona en su categoría Transporte.
Puedes acceder al dataset mediante el siguiente enlace 👉​ https://opendata-ajuntament.barcelona.cat/data/en/dataset/est-vehicles-antiguitat-motos.

## PASO 1
Descargar los archivos .csv para los años 2007 a 2018.

## PASO 2
A través de Power Query en Excel se realiza una combinación de consultas a los diferentes archivos .csv para conformar el dataset final formado por 13.024 filas en formato CSV (separado por comas).
Para facilitar la tarea, adjunto dataset final en el repositorio.

## PASO 3
Accedemos a MySQL Workbench, creamos la base de datos e importamos el dataset final.

## PASO 4
En este proceso hemos identificado algunos valores que no serán válidos para realizar el análisis. ¡Es el momento de limpiar nuestros datos!

### POSIBILIDAD 1
1. Eliminaremos cualquier fila que contenga el valor "No consta" en la columna Antiguitat.
2. Eliminaremos cualquier fila que contenta el valor "99" en el Codi_Districte

### POSIBILIDAD 2
Crear una tabla temporal con los datos correctos, es decir, creamos la tabla temporal realizando un SELECT descartando las dos opciones mencionadas en la POSIBILIDAD 1.

## PASO 5
¡Ya tenemos listo nuestro dataset para ser analizado! 
TRABAJAREMOS CON LA TABLA TEMPORAL CREADA

## PASO 6
Daremos respuesta a las siguientes preguntas:

✅​ Cuantos distritos hay en Barcelona?

✅​ Listado de distritos de Barcelona

✅​ Cuántos barrios hay en Barcelona?

✅​ Listado de barrios de Barcelona

✅​ Cuál es el distrito de Barcelona con más barrios?

✅​ Cuál es el distrito de Barcelona con menos barrios?

✅​ Listado de distritos ordenados por número de barrios en orden decreciente

✅​ Número total de motos por distrito y año

✅​ Número total de motos por distrito en los 10 años en orden decreciente

✅​ Distrito con un total de motos mayor en los 10 años

✅​ Distrito con un total de motos menor en los 10 años

✅​ Número total de motos por barrio y año

✅​ Número total de motos por barrio en los 10 años en orden decreciente

✅​ Barrio con un total de motos mayor en los 10 años

✅​ Número total de motos en Barcelona por año

✅​ Número total de motos en Barcelona en los 10 años

✅​ Año con más motos en Barcelona

✅​ Siendo el año 2012 el que más motos hubo en Barcelona, ¿qué barrio aportó el mayor número de motos?

✅​ Para cada año, ¿cuál es el barrio de Barcelona con myor número de motos nuevas (Menos de 1 año de antigüedad)?

✅​ Para cada año, ¿cuál es el barrio de Barcelona con mayor número de motos antiguas (> 10 años)?


Puedes descargar el archivo .sql con las consultas realizadas a través de este enlace 👉 o accediendo a través del archivo adjunto en el repositorio.
