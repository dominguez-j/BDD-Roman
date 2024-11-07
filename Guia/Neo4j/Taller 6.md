## Primeras consultas
1.  Muestre en orden alfabético, los nombres de las primeras 10 personas apellidadas ‘Smith’.
~~~
MATCH (n:Person) 
WHERE n.surname = "Smith" 
RETURN n.name 
ORDER BY n.name 
LIMIT 10
~~~
2.  Muestre la marca y modelos de los vehículos de año 2013.
~~~
MATCH (v:Vehicle) 
WHERE v.year = "2013"
RETURN v.make, v.model

OTRA FORMA

MATCH (v:Vehicle{year = "2013"}) 
RETURN v.make, v.model
~~~
3. Muestre el nombre, apellido y rango de los oficiales cuyos apellidos comiencen con ’Mc’, ordenados por rango (rank).
~~~
MATCH (o:Officer) 
WHERE o.surname STARTS WITH "Mc"
RETURN o.name, o.surname, o.rank
ORDER BY o.rank
~~~
4.  Muestre el grafo de las locations en el área M30. Cuantos nodos hay?
~~~
MATCH (l:Location)--(a:Area) 
WHERE a.areaCode = "M30"
RETURN l,a

OTRA FORMA

MATCH (l:Location)-[:LOCATION_IN_AREA]->(a:Area) 
WHERE a.areaCode = "M30" 
RETURN l,a
~~~
Hay 210 nodos de Location y 1 de Area
5.  Muestre el grafo de todos que conocen a alguien que conoce a Gordon Craig.
~~~
MATCH (p:Person)-[:KNOWS]-(a:Person)-[:KNOWS]-(n:Person) 
WHERE n.name = "Craig" AND n.surname = "Gordon"
RETURN p, a, n

OTRA FORMA

MATCH (p:Person)-[:KNOWS*2]-(n:Person) 
WHERE n.name = "Craig" AND n.surname = "Gordon"
RETURN p, n
~~~
LW -> Lives with, SN -> Social Network
6. Muestre las personas que están a distancia 3 de Gordon Craig.
~~~
MATCH (p:Person)-[:KNOWS*3]-(n:Person)
WHERE n.name = "Craig" AND n.surname = "Gordon"
RETURN p, n
~~~
7. Muestre las personas conocidas de Roger Brooks que no participaron en ningún crimen.
~~~
MATCH (p:Person)-[:KNOWS]-(n:Person {name: "Roger", surname: "Brooks"})
WHERE NOT ((p)--(:Crime))
RETURN p
~~~
8. Muestre el camino más corto de Judith Moore a Richard Green.
~~~
MATCH s = shortestPath(
(:Person {name: "Judith", surname: "Moore"})-[*]-(:Person {name: "Richard", surname: "Green"})) 
return s
~~~
9. Encuentre los oficiales que investigaron los crímenes cometidos en 165 Laurel Street.
~~~
MATCH (c:Crime)-[:INVESTIGATED_BY]->(o:Officer) 
WHERE (c)-[:OCCURRED_AT]->(:Location {address: "165 Laurel Street"}) 
RETURN o

OTRA FORMA

MATCH (:Location {address: "165 Laurel Street"})<-[:OCCURRED_AT]-(:Crime)-[:INVESTIGATED_BY]->(o:Officer) 
RETURN o
~~~
10. Obtenga el modelo, marca y año del auto más viejo de la base.
~~~
MATCH (v:Vehicle)
RETURN v.make, v.model, v.year
ORDER BY v.year ASC
LIMIT 1

OTRA FORMA

MATCH (a:Vehicle) 
WITH min(a.year) AS min_year
MATCH (v:Vehicle) WHERE v.year = min_year 
RETURN v.model AS model, v.make AS brand, v.year AS year
~~~
11. ¿A qué distancia se encuentra el auto más viejo de Roger Brooks?
~~~
MATCH (a:Vehicle) 
WITH min(a.year) AS min_year 
MATCH (v:Vehicle) WHERE v.year = min_year 
WITH v AS older_car 
MATCH s = shortestPath(
     (rb:Person {name: "Roger", surname: "Brooks"})-[*]-(older_car)
) 

RETURN Length(s) - 2
~~~
12. Devuelva el nombre y apellido de personas que conozcan más de 10 personas.
~~~
MATCH (p:Person)-[:KNOWS]-(:Person)
WITH p, COUNT(*) AS cant
WHERE cant > 10
RETURN p.name, p.surname, cant
~~~
13. Cuantas personas hay en la base? Cuantos tiene teléfono? Cuantos mail?
~~~
MATCH (p:Person)
WITH COUNT(*) AS cant_personas
MATCH (r:Phone)
WITH cant_personas, COUNT(*) AS cant_con_tel
MATCH (e:Email)
WITH cant_personas, cant_con_tel, COUNT(*) AS cant_con_email
RETURN cant_personas, cant_con_tel, cant_con_email
~~~