# Funciones de PostgreSQL

Una función recibe argumentos y devuelve un resultado. Esta página es una referencia de consulta, no una lista para memorizar. Cambia de conexión según la tabla del ejemplo.

## Numéricas

| Función | Uso |
| --- | --- |
| `ABS(n)` | Valor absoluto. |
| `ROUND(n, decimales)` | Redondeo de un NUMERIC. |
| `TRUNC(n, decimales)` | Truncamiento de un NUMERIC. |
| `CEIL(n)`, `FLOOR(n)` | Entero superior o inferior. |
| `POWER(a,b)`, `SQRT(n)` | Potencia y raíz cuadrada. |
| `MOD(a,b)` | Resto. |
| `LN(n)`, `LOG(base,n)` | Logaritmos. |
| `SIN(n)`, `COS(n)`, `TAN(n)` | Funciones trigonométricas, con ángulos en radianes. |
| `RANDOM()` | Número pseudoaleatorio mayor o igual que 0 y menor que 1. |

```sql
SELECT ROUND(799.00::NUMERIC * 1.05, 2);
SELECT FLOOR(RANDOM() * 6 + 1) AS dado;
```

## Texto

| Función | Uso |
| --- | --- |
| `UPPER(t)`, `LOWER(t)`, `INITCAP(t)` | Conversión de mayúsculas y minúsculas. |
| `LENGTH(t)` | Longitud. |
| `SUBSTR(t, inicio, longitud)` | Extrae una parte del texto; la primera posición es 1. |
| `STRPOS(t, subcadena)` | Posición de la primera aparición; 0 si no aparece. |
| `SPLIT_PART(t, separador, numero)` | Extrae una parte separada por un delimitador. |
| `REPLACE(t, origen, destino)` | Sustituye una subcadena. |
| `TRIM(t)`, `LTRIM(t)`, `RTRIM(t)` | Elimina caracteres de los extremos. |
| `LPAD(t,n,relleno)`, `RPAD(t,n,relleno)` | Rellena hasta la longitud indicada. |
| `CONCAT(a,b,...)` | Concatena los argumentos, ignorando los nulos. |

En `moviles`, para obtener la primera palabra del modelo:

```sql
SELECT modelo, SPLIT_PART(modelo, ' ', 1) AS primera_palabra
FROM moviles;
```

Esta función también sirve para un modelo de una sola palabra, como `Xperia`. Usar `SUBSTR(modelo, 1, STRPOS(modelo, ' ') - 1)` sin comprobar que hay espacio produciría una longitud negativa en ese caso.

En `juegos`, algunos productos utilizan un separador `:`:

```sql
SELECT nombre, SPLIT_PART(nombre, ':', 1) AS parte_inicial
FROM productos;
```

Para escribir una comilla simple dentro de un literal, repítela:

```sql
SELECT 'Pack ''Gamer'' Premium' AS nombre;
```

## Nulos y expresiones condicionales

```sql
SELECT id_producto, COALESCE(stock, 0) AS stock_completado,
       CASE WHEN stock IS NULL THEN 'Sin información'
            WHEN stock < stock_minimo THEN 'Reponer'
            ELSE 'Disponible' END AS estado
FROM productos;
```

`COALESCE` devuelve el primer argumento no nulo. `NULLIF(a,b)` devuelve NULL si ambos son iguales, útil para evitar divisiones por cero cuando ese es el significado deseado.

## Fecha y hora

| Expresión o función | Uso |
| --- | --- |
| `CURRENT_DATE` | Fecha actual. |
| `CURRENT_TIMESTAMP`, `NOW()` | Fecha y hora con zona horaria, al inicio de la transacción. |
| `LOCALTIMESTAMP` | Fecha y hora sin zona horaria. |
| `CURRENT_TIME`, `LOCALTIME` | Hora con o sin zona horaria. |
| `EXTRACT(campo FROM fecha)` | Extrae año, mes, trimestre u otro componente. |
| `AGE(fecha1, fecha2)` | Intervalo entre las fechas. |
| `DATE_TRUNC('month', fecha)` | Trunca al inicio del mes. |

```sql
SELECT id_compra, fecha, EXTRACT(QUARTER FROM fecha) AS trimestre
FROM compras;
```

## Conversión y presentación

`TO_CHAR` convierte fechas o números en texto con un formato; no cambia el dato almacenado.

```sql
SELECT TO_CHAR(DATE '2024-03-15', 'DD-MM-YYYY') AS fecha_texto;
SELECT TO_CHAR(TIMESTAMP '2024-03-15 13:09:00', 'YYYY-MM-DD HH24:MI') AS momento;
SELECT TO_CHAR(799.5::NUMERIC, 'FM9999990.00') AS precio_texto;
SELECT TO_DATE('15-03-2024', 'DD-MM-YYYY') AS fecha;
SELECT TO_TIMESTAMP('2024-03-15 13:09', 'YYYY-MM-DD HH24:MI') AS momento;
```

`HH24` usa 24 horas; `HH12` usa 12. `MI` significa minutos y `MM`, mes. Los nombres de meses y días dependen de la configuración regional del servidor.

## Geometría y redes

```sql
SELECT AREA(CIRCLE '((5,5),2)') AS area;
SELECT HOST(INET '192.168.2.15/24') AS direccion,
       MASKLEN(INET '192.168.2.15/24') AS prefijo,
       NETMASK(INET '192.168.2.15/24') AS mascara;
```

Consulta la [documentación de PostgreSQL 17](https://www.postgresql.org/docs/17/functions.html) para ampliar esta referencia.
