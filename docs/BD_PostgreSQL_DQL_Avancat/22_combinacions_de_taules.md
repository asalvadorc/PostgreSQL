# 2. Combinaciones de tablas

Una combinación reúne columnas de distintas tablas. Trabaja en **juegos** y consulta las claves del [modelo relacional](../BD_PostgreSQL_DQL/juegos.md).

## 2.1 Producto cartesiano

```sql
SELECT j.nombre AS jugador, c.nombre AS ciudad
FROM jugadores AS j CROSS JOIN ciudades AS c;
```

Combina cada jugador con todas las ciudades: con 8 jugadores y 6 ciudades devuelve **48 filas**. No significa que todos vivan en todas las ciudades; falta la condición que relaciona sus claves.

## 2.2 INNER JOIN

```sql
SELECT j.nombre AS jugador, c.nombre AS ciudad
FROM jugadores AS j
JOIN ciudades AS c ON c.id_ciudad = j.id_ciudad
ORDER BY j.id_jugador;
```

La condición `ON` compara la FK con la PK. Solo se conservan las parejas que cumplen la condición. Los alias evitan repetir nombres largos y resuelven ambigüedades: `j.nombre` y `c.nombre` son columnas distintas.

Si el campo común tiene el mismo nombre, puedes usar `JOIN ciudades USING (id_ciudad)`. Evita `NATURAL JOIN` en estas prácticas: relacionaría todas las columnas con el mismo nombre, incluido `nombre`, que aquí no representa el mismo dato.

También es posible escribir la combinación con tablas separadas por comas y el filtro en WHERE, pero `JOIN ... ON` separa mejor la relación de los filtros.

## 2.3 Combinar varias tablas

Para llegar de un jugador a sus productos recorremos `jugadores → compras → lineas_compra → productos`.

```sql
SELECT j.nombre,p.id_producto,p.nombre AS producto FROM jugadores j JOIN compras c ON c.id_jugador=j.id_jugador JOIN lineas_compra l ON l.id_compra=c.id_compra JOIN productos p ON p.id_producto=l.id_producto ORDER BY j.id_jugador,c.id_compra,l.num_linea;
```

Una fila representa una línea vendida. Si el jugador compra el mismo producto en varias ocasiones, se repetirá. Usa `DISTINCT` únicamente si la pregunta pide eliminar esas repeticiones.

## 2.4 Agrupaciones y totales

```sql
SELECT c.id_compra,c.fecha,c.id_jugador,SUM(l.precio_unitario*l.cantidad) AS base FROM compras c JOIN lineas_compra l ON l.id_compra=c.id_compra GROUP BY c.id_compra ORDER BY c.id_compra;
```

Al unir una compra con sus líneas, su cabecera se repite. No sumes después el total de la cabecera una vez por línea: multiplicarías sus importes. Suma las líneas por compra o agrega primero en una subconsulta.

Para el total final hay tres pasos: descuento de cada línea, descuento de la compra y finalmente IVA.

```sql
SELECT c.id_compra,SUM(l.precio_unitario*l.cantidad*(1-COALESCE(l.descuento_linea,0)/100.0))*(1-COALESCE(c.descuento,0)/100.0)*(1+COALESCE(c.iva,0)/100.0) AS total FROM compras c JOIN lineas_compra l ON l.id_compra=c.id_compra GROUP BY c.id_compra ORDER BY c.id_compra;
```

No redondees cada operación intermedia salvo que la regla de negocio lo pida. Puedes redondear a dos decimales el total mostrado.

## 2.5 Relación reflexiva

Una tabla se puede reunir consigo misma utilizando dos alias:

```sql
SELECT v.nombre AS vendedor, jefe.nombre AS jefe
FROM vendedores AS v
LEFT JOIN vendedores AS jefe ON jefe.id_vendedor = v.id_jefe
ORDER BY v.id_vendedor;
```

Son dos papeles de la misma tabla: vendedor y jefe. `LEFT JOIN` mantiene también al vendedor de nivel superior, cuyo jefe es NULL.

## 2.6 Combinaciones externas

`LEFT JOIN` conserva todas las filas de la izquierda; `RIGHT JOIN`, las de la derecha; `FULL JOIN`, las de ambos lados. Cuando no hay pareja, las columnas del otro lado son NULL.

```sql
SELECT j.id_jugador,j.nombre,COUNT(c.id_compra) AS compras FROM jugadores j LEFT JOIN compras c ON c.id_jugador=j.id_jugador GROUP BY j.id_jugador ORDER BY j.id_jugador;
```

Usamos `COUNT(c.id_compra)` y no `COUNT(*)`: para un jugador sin compras, la combinación externa produce una fila, pero el código de compra es nulo y no debe contarse.

Un filtro del lado opcional en WHERE puede eliminar esas filas sin pareja y convertir el resultado, en la práctica, en una combinación interna. Si quieres conservarlas, estudia si ese filtro pertenece a `ON`.

Para buscar jugadores sin compras:

```sql
SELECT j.id_jugador,j.nombre FROM jugadores j LEFT JOIN compras c ON c.id_jugador=j.id_jugador WHERE c.id_compra IS NULL ORDER BY j.id_jugador;
```

## Ejercicios de Juegos

Conexión `juegos`, usuario `alumno`. Usa la carga inicial del tema DML.

**Ex_51** Sacar el nombre del jugador, el código y la fecha de cada compra.

**Ex_52** Sacar el nombre de cada jugador y los productos que ha comprado, permitiendo repeticiones.

**Ex_53** Repetir la consulta anterior sin repetir una combinación de jugador y producto.

**Ex_54** Sacar todos los jugadores con su número de compras, incluyendo quienes no han comprado.

**Ex_55** Sacar el código, la fecha, el jugador y la base sin descuentos ni IVA de cada compra.

**Ex_56** Calcular el total final de cada compra: descuento de líneas, descuento general y finalmente IVA.

**Ex_57** Sacar el código y nombre de los vendedores que supervisan a otro vendedor.

**Ex_58** Sacar los productos y su categoría, incluyendo productos sin categoría.

**Ex_59** Sacar las categorías y su número de productos, incluyendo las vacías.

**Ex_60** Sacar los jugadores que no han realizado compras.

**Ex_61** Sacar todos los productos y sus unidades vendidas, mostrando 0 si no tienen ventas.

**Ex_62** Sacar todas las ciudades con su número de jugadores, incluyendo las que no tienen ninguno.

**Ex_63** Sacar las categorías sin productos. Un resultado vacío puede ser correcto con estos datos.
