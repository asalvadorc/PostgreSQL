# Operadores de PostgreSQL

Los operadores permiten calcular expresiones y construir condiciones en DQL. Los tipos de las columnas se definieron en DDL. Ejemplos de móviles: conexión `moviles`; ejemplos de tienda: conexión `juegos`.

## Aritméticos

| Operador | Significado |
| --- | --- |
| `+`, `-`, `*`, `/` | Suma, resta, multiplicación y división. |
| `%` | Resto de una división entera. |
| `^` | Potencia. |

```sql
SELECT 7 / 2 AS division_entera, 7 / 2.0 AS division_decimal;
SELECT 5 ^ 3 AS potencia, 7 % 2 AS resto;
```

La división de dos enteros trunca la parte decimal. Para porcentajes usa `100.0` o una conversión a NUMERIC.

## Cadenas

`||` concatena texto. Si alguno de sus operandos es NULL, el resultado es NULL; utiliza `COALESCE` cuando necesites sustituirlo.

```sql
SELECT modelo || ' — ' || precio::TEXT AS movil FROM moviles;
```

## Comparación y lógica

| Operador | Significado |
| --- | --- |
| `=`, `<>` o `!=` | Igual y distinto. |
| `<`, `<=`, `>`, `>=` | Comparaciones de orden. |
| `AND`, `OR`, `NOT` | Combinación o negación de condiciones. |
| `BETWEEN a AND b` | Intervalo con ambos extremos incluidos. |
| `IN (...)` | Pertenencia a un conjunto. |
| `LIKE`, `ILIKE` | Patrón de texto; ILIKE no distingue mayúsculas. |
| `IS NULL`, `IS NOT NULL` | Presencia o ausencia de un valor. |

```sql
SELECT modelo, precio FROM moviles
WHERE precio BETWEEN 300 AND 900 AND id_empresa IN (1, 2)
ORDER BY precio;
```

En los patrones, `%` representa cualquier secuencia de caracteres y `_` exactamente un carácter. Usa `IS NULL`, no `= NULL`. SQL tiene tres valores lógicos: verdadero, falso y desconocido por NULL. WHERE conserva solo las filas cuya condición es verdadera.

## Conversión de tipos

```sql
SELECT '2024-03-01'::DATE;
SELECT CAST('799.00' AS NUMERIC(10,2));
```

`::tipo` es la notación de PostgreSQL; `CAST(... AS tipo)` es otra forma de expresar la conversión. Utiliza fechas ISO para evitar depender del formato regional.

## Otros tipos

PostgreSQL también tiene operadores geométricos y de red. No todos los operadores sirven para todos los tipos:

```sql
SELECT point(0, 0) <-> point(3, 4) AS distancia;
SELECT inet '192.168.1.10' << inet '192.168.1.0/24' AS pertenece_a_red;
```

Consulta la [referencia de funciones y operadores](https://www.postgresql.org/docs/17/functions.html) cuando necesites un tipo específico.
