### Parte A: Consultas de una tabla

1.  Devuelva todos los datos de las notas que no sean de la materia 75.1.

 - ` SELECT * FROM notas
WHERE codigo <> 75 AND numero <> 1 `

2. Devuelva para cada materia dos columnas: una llamada “codigo” que contenga una concatenación del código de departamento, un punto y el número de materia, con el formato
“XX.YY” (ambos valores con dos dígitos, agregando ceros a la izquierda en caso de ser
necesario) y otra con el nombre de la materia.

 - ` SELECT (codigo ||'.'|| to_char(numero, 'fm09')) AS codigo, nombre FROM materias `

3. Para cada nota registrada, devuelva el padrón, código de departamento, número de materia,
fecha y nota expresada como un valor entre 1 y 100.

 - ` SELECT padron, codigo, numero, fecha, nota * 10 FROM notas `

4. Idem al anterior pero mostrando los resultados paginados en páginas de 5 resultados cada
una, devolviendo la segunda página.

 - ` SELECT padron, codigo, numero, fecha, nota * 10 FROM notas 
 OFFSET 5 FETCH FIRST 5 ROWS ONLY `

5. Ejecute una consulta SQL que devuelva el padrón y nombre de los alumnos cuyo apellido
es “Molina”.

 - ` SELECT padron, nombre FROM alumnos
WHERE upper(apellido) = 'MOLINA' ` 

6. Obtener el padrón de los alumnos que ingresaron a la facultad en el año 2010.

 - ` SELECT padron FROM alumnos
WHERE EXTRACT(YEAR FROM fecha_ingreso) = 2010 ` 

### Parte B: Funciones de agregación

7. Obtener la mejor nota registrada en la materia 75.15.
 
 - ` SELECT MAX(nota) FROM notas
WHERE codigo = 75 AND numero = 15 `

8. Obtener el promedio de notas de las materias del departamento de código 75.

 - ` SELECT AVG(nota) FROM notas
WHERE codigo = 75  ` 

9. Obtener el promedio de nota de aprobación de las materias del departamento de código 75.

 - ` SELECT AVG(nota) FROM notas
WHERE codigo = 75 AND nota >= 4 ` 

10. Obtener la cantidad de alumnos que tienen al menos una nota.

 - ` SELECT COUNT(1) AS cant_alumnos FROM notas
WHERE nota IS NOT null `  

### Parte C: Operadores de conjunto

11. Devolver los padrones de alumnos que no registran nota en materias.

 - ` SELECT padron FROM alumnos EXCEPT
SELECT padron FROM notas ` 

12. Con el objetivo de traducir a otro idioma los nombres de materias y departamentos, devolver
en una única consulta las nombres de todas las materias y de todos los departamentos.

 - ` SELECT nombre FROM materias UNION
SELECT nombre FROM departamentos ` 

### Parte D: Joins

13. Devolver para cada materia su nombre y el nombre del departamento.

 - ` SELECT m.nombre, d.nombre from materias m
INNER JOIN departamentos d ON m.codigo = d.codigo ` 

14. Para cada 10 registrado, devuelva el padron y nombre del alumno y el nombre de la materia
correspondientes a dicha nota.

 - ` SELECT a.padron, a.nombre, m.nombre FROM alumnos a
INNER JOIN notas n ON a.padron = n.padron
INNER JOIN materias m ON m.numero = n.numero AND m.codigo = n.codigo
WHERE n.nota = 10; ` 

15. Listar para cada carrera su nombre y el padrón de los alumnos que estén anotados en ella.
Incluir también las carreras sin alumnos inscriptos.

 - ` SELECT c.nombre, a.padron FROM carreras c
LEFT JOIN inscripto_en i ON c.codigo = i.codigo
LEFT JOIN alumnos a ON i.padron = a.padron ` 

16. Listar para cada carrera su nombre y el padron de los alumnos con padron mayor a 75000
que estén anotados en ella. Incluir también las carreras sin alumnos inscriptos con padrón
mayor a 75000

 - ` SELECT DISTINCT c.nombre, a.padron FROM carreras c
LEFT JOIN inscripto_en i ON c.codigo = i.codigo
LEFT JOIN alumnos a ON i.padron = a.padron AND a.padron > 75000 ` 

17. Listar el padrón de aquellos que tengan más de una nota en la materia 75.15.

 - ` SELECT padron FROM notas
WHERE codigo = 75 AND numero = 15
GROUP BY padron
HAVING COUNT(*) > 1 `
 
18. Obtenga el padrón y nombre de las alumnos que aprobaron la materia 71.14 y no aprobaron
la materia 71.15.

 - ` SELECT a.padron, a.nombre FROM alumnos a
INNER JOIN notas n ON a.padron = n.padron
WHERE n.codigo = 71 AND n.numero = 14 AND n.nota >= 4
INTERSECT 
SELECT a.padron, a.nombre FROM alumnos a
INNER JOIN notas n ON a.padron = n.padron
WHERE n.codigo = 71 AND n.numero = 15 AND n.nota < 4 ` 

19. Obtener, sin repeticiones, todos los pares de padrones de alumnos tales que ambos alumnos
rindieron la misma materia el mismo día. Devuelva también la fecha y el código y número
de la materia.

 - ` SELECT DISTINCT LEAST(n1.padron, n2.padron) AS padron1, 
GREATEST(n1.padron, n2.padron) AS padron2, n1.fecha, n1.codigo, n1.numero
FROM notas n1
INNER JOIN notas n2 
ON  n1.fecha = n2.fecha 
AND n1.codigo = n2.codigo
AND n1.numero = n2.numero 
AND n1.padron < n2.padron ` 

### Parte E: Agrupamiento

20. Para cada departamento, devuelva su código, nombre, la cantidad de materias que tiene y la
cantidad total de notas registradas en materias del departamento. Ordene por la cantidad
de materias descendente.

 - ` SELECT d.codigo, d.nombre, COUNT(DISTINCT m.numero) cant_mat, COUNT(n.nota) cant_notas
FROM departamentos d
LEFT JOIN notas n ON d.codigo = n.codigo
LEFT JOIN materias m ON n.numero = m.numero AND n.codigo = m.codigo
GROUP BY d.codigo, d.nombre
ORDER BY cant_mat DESC ` 

21. Para cada carrera devuelva su nombre y la cantidad de alumnos inscriptos. Incluya las
carreras sin alumnos.

 - ` SELECT c.nombre, COUNT(i.padron) cant_alumnos
FROM carreras c
LEFT JOIN inscripto_en i ON c.codigo = i.codigo
GROUP BY c.codigo ` 

22. Para cada alumno con al menos tres notas, devuelva su padron, nombre, promedio de notas
y mejor nota registrada.

 - ` SELECT a.padron, a.nombre, AVG(n.nota), MAX(n.nota)
FROM alumnos a
INNER JOIN notas n ON a.padron = n.padron
GROUP BY a.padron, a.nombre
HAVING COUNT(n.nota) >= 3 ` 

### Parte F: Consultas avanzadas

23. Obtener el código y número de la o las materias con mayor cantidad de notas registradas.

 - ` ` 

24. Obtener el padrón de los alumnos que tienen nota en todas las materias.
  
 - ` ` 

25. Obtener el promedio general de notas por alumno (cuantas notas tiene en promedio un
alumno), considerando únicamente alumnos con al menos una nota.

 - ` ` 