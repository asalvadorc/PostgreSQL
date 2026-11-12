# 4. Operaciones de conjuntos

`UNION`, `INTERSECT` y `EXCEPT` combinan filas completas de dos consultas. Ambas deben devolver el mismo número de columnas, con tipos compatibles en cada posición. Trabaja en **juegos**.

## 4.1 UNION

Une las filas de ambos resultados y elimina duplicados. `UNION ALL` conserva todas las repeticiones y evita ese paso de deduplicación.

```sql
SELECT j.nombre FROM jugadores j JOIN compras c ON c.id_jugador=j.id_jugador UNION SELECT v.nombre FROM vendedores v JOIN compras c ON c.id_vendedor=v.id_vendedor ORDER BY nombre;
```

El resultado representa nombres distintos, no personas identificadas de manera única: dos personas con el mismo nombre se fusionan. Si necesitas distinguirlas, añade columnas de código y origen compatibles en ambas consultas.

## 4.2 INTERSECT

Devuelve las filas que aparecen en ambas consultas:

```sql
SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN jugadores j ON j.id_ciudad=c.id_ciudad INTERSECT SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN vendedores v ON v.id_ciudad=c.id_ciudad ORDER BY id_ciudad;
```

Compara las dos columnas de cada fila, no solo el nombre de la ciudad. Las ciudades con jugadores y vendedores aparecen una sola vez.

## 4.3 EXCEPT

Devuelve las filas de la primera consulta que no aparecen en la segunda:

```sql
SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN vendedores v ON v.id_ciudad=c.id_ciudad EXCEPT SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN jugadores j ON j.id_ciudad=c.id_ciudad ORDER BY id_ciudad;
```

Cambiar el orden de las consultas cambia el significado. Con los datos iniciales, este resultado es vacío: las ciudades con vendedores también tienen jugadores.

## 4.4 Ordenación y paréntesis

Sitúa `ORDER BY` al final para ordenar el resultado conjunto. Si necesitas un `ORDER BY ... LIMIT` dentro de una de las consultas, enciérrala entre paréntesis. Usa también paréntesis para hacer explícito el orden al mezclar varios operadores de conjuntos.

## Ejercicios de Juegos

Conexión `juegos`, usuario `alumno`. Usa la carga inicial del tema DML.

**Ex_75** Sacar sin repeticiones los nombres de jugadores y vendedores que participan en alguna compra.

**Ex_76a** Sacar mediante UNION las ciudades donde hay jugadores o vendedores.

**Ex_76b** Sacar mediante INTERSECT las ciudades donde hay jugadores y también vendedores.

**Ex_76c** Sacar mediante EXCEPT las ciudades donde hay vendedores pero no jugadores.
