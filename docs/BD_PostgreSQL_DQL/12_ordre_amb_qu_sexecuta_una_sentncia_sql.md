# 12. Orden lógico de una consulta

El orden lógico ayuda a entender una consulta; el optimizador puede utilizar un plan físico diferente.

1. `FROM` y `JOIN` determinan las filas de origen.
2. `WHERE` filtra las filas.
3. `GROUP BY` forma los grupos y se calculan los agregados.
4. `HAVING` filtra los grupos.
5. `SELECT` calcula las columnas de salida.
6. `DISTINCT` elimina las filas repetidas si se solicita.
7. `ORDER BY` ordena el resultado.
8. `LIMIT` y `OFFSET` seleccionan una parte del resultado.

En `moviles`, esta consulta es incorrecta porque `modelo` no está agrupado ni agregado:

```sql
-- Ejemplo que debe producir un error.
SELECT id_empresa, COUNT(*), modelo
FROM moviles
GROUP BY id_empresa;
```

Cada empresa puede tener varios modelos. Después de agrupar, no existe un único modelo que mostrar. Si quieres contar móviles por empresa:

```sql
SELECT id_empresa, COUNT(*) AS moviles
FROM moviles
GROUP BY id_empresa
ORDER BY id_empresa;
```

Tampoco es válida `SELECT MAX(precio), modelo FROM moviles`: el agregado devuelve un valor para todas las filas, pero no identifica qué modelo lo tiene. Cuando estudies subconsultas, podrás obtener todos los empates:

```sql
SELECT modelo, precio
FROM moviles
WHERE precio = (SELECT MAX(precio) FROM moviles);
```

Un alias calculado en SELECT suele poder usarse en ORDER BY, pero no en WHERE de esa misma consulta. Para filtrar agregados utiliza HAVING, no WHERE.
