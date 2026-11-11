# 3. Subconsultas

Una subconsulta es una consulta usada dentro de otra. Puede devolver un valor, una columna o una tabla. Ejecuta los ejemplos en **gamehub**.

## 3.1 Subconsulta en FROM

La consulta interior prepara una tabla de resultados; dale un alias:

```sql
SELECT MAX(n) AS maximo_compras FROM (SELECT COUNT(*) AS n FROM compras GROUP BY id_jugador) AS recuentos;
```

Primero se cuentan las compras de cada jugador y después se obtiene el máximo de esos recuentos. También puedes escribirlo con una CTE: `WITH recuentos AS (...) SELECT ...`.

## 3.2 Subconsulta escalar en WHERE

Una subconsulta escalar debe devolver como máximo una fila y una columna. Si devuelve varias filas, la comparación con `=` o `>` falla.

```sql
SELECT * FROM productos WHERE precio>(SELECT AVG(precio) FROM productos) ORDER BY precio DESC,id_producto;
```

La media es un único valor. Para conservar todos los empates del máximo, compara con `MAX(...)` en lugar de ordenar y aplicar `LIMIT 1`.

## 3.3 Subconsultas correlacionadas

La consulta interior puede utilizar una columna de la fila exterior:

```sql
SELECT p.* FROM productos p WHERE p.precio>(SELECT AVG(p2.precio) FROM productos p2 WHERE p2.id_categoria=p.id_categoria) ORDER BY p.id_categoria,p.precio DESC,p.id_producto;
```

Aquí la media cambia según la categoría del producto exterior `p`. Una subconsulta no correlacionada calcularía la media global.

## 3.4 IN, EXISTS y valores nulos

`IN` comprueba si un valor pertenece al resultado de una subconsulta. `EXISTS` comprueba si hay al menos una fila; no importa qué columnas seleccione dentro.

```sql
SELECT c.id_ciudad,c.nombre FROM ciudades c WHERE EXISTS (SELECT 1 FROM jugadores j WHERE j.id_ciudad=c.id_ciudad) AND NOT EXISTS (SELECT 1 FROM vendedores v WHERE v.id_ciudad=c.id_ciudad) ORDER BY c.id_ciudad;
```

Evita sustituir sin más `NOT EXISTS` por `NOT IN`: si la subconsulta de `NOT IN` contiene NULL, las comparaciones pueden quedar desconocidas y eliminar filas que esperabas ver. `ANY` y `ALL` comparan con alguno o con todos los valores; revisa también los casos de conjuntos vacíos y NULL.

## 3.5 Subconsultas en SELECT y HAVING

```sql
SELECT v.id_vendedor,v.nombre,(SELECT COUNT(*) FROM compras c WHERE c.id_vendedor=v.id_vendedor) AS compras,COALESCE((SELECT SUM(r.total) FROM resumen_compras r WHERE r.id_vendedor=v.id_vendedor),0) AS total FROM vendedores v ORDER BY v.id_vendedor;
```

Cada subconsulta de SELECT devuelve un único agregado para el vendedor exterior. `COALESCE` convierte en 0 un SUM sin filas. También puedes utilizar subconsultas en HAVING para filtrar grupos mediante otro agregado.

## 3.6 Vista auxiliar para los importes

Para los ejercicios de importes utiliza `resumen_compras`, definida en el [apartado de vistas de DDL](../BD_PostgreSQL_DDL/2_ddl.md#26-vistas). Si no realizaste aquel ejercicio, crea la vista ahora copiando su definición. Su columna `total` aplica descuentos e IVA; no es la base sin descuentos.

```sql
SELECT * FROM resumen_compras WHERE total=(SELECT MAX(total) FROM resumen_compras) ORDER BY id_compra;
```

## Ejercicios de GameHub

Conexión `gamehub`, usuario `alumno`. Usa la carga inicial del tema DML.

**Ex_64** Sacar el mayor número de compras realizadas por un mismo jugador.

**Ex_65** Sacar el importe de la compra más cara y de la más barata, usando los totales finales.

**Ex_66** Sacar el mayor número de compras atendidas por un vendedor en el segundo semestre de 2024.

**Ex_67** Sacar los productos con precio superior a la media global, ordenados por precio descendente.

**Ex_68** Sacar los productos con precio superior a la media de su propia categoría.

**Ex_69** Sacar las ciudades donde hay jugadores pero no vendedores, usando EXISTS y NOT EXISTS.

**Ex_70** Sacar las ciudades con más vendedores que jugadores. Con los datos iniciales puede no haber ninguna.

**Ex_71** Sacar el importe máximo de compra de cada trimestre.

**Ex_72** Sacar todos los vendedores, su número de compras y su importe total vendido, incluyendo ceros.

**Ex_73** Sacar toda la información de la compra de mayor importe. Incluir todas si hay empate.

**Ex_74** Voluntario: sacar el vendedor con más unidades vendidas de cada categoría, incluyendo empates.
