---
hide:
  - toc
---

# Tipos de datos

Al crear una tabla debemos indicar **qué tipo de dato almacenará cada columna**. El tipo determina qué valores admite, cómo se representan y qué operaciones podemos realizar con ellos. Por ejemplo, un nombre necesita un tipo de texto, una cantidad un tipo entero y una fecha de compra un tipo de fecha.

Elegir el tipo adecuado ayuda a mantener la coherencia de los datos. En nuestras bases utilizaremos principalmente texto, números, fechas y valores lógicos. Para los precios emplearemos números decimales exactos; los códigos postales, en cambio, se guardarán como texto para conservar posibles ceros iniciales.

La siguiente tabla resume los tipos de PostgreSQL que utilizaremos en las prácticas:

| Tipo | Descripción breve | Ejemplo |
| --- | --- | --- |
| `INTEGER` | Número entero, sin decimales. | `25`, `0`, `-8` |
| `SERIAL` | Abreviatura que crea una columna entera con una secuencia para generar valores automáticamente. No añade una PK. | Genera automáticamente `1`, `2`, `3`… al omitir el valor de la columna. |
| `VARCHAR(n)` | Texto de hasta `n` caracteres. | En `VARCHAR(20)`: `'Ana García'`. |
| `VARCHAR` o `TEXT` | Texto sin una longitud máxima declarada; no se limita a 255 caracteres. | `'Proyecto de desarrollo de una aplicación web'` |
| `DECIMAL(10,2)` o `NUMERIC(10,2)` | Número decimal exacto con hasta diez cifras en total, dos de ellas decimales. | `1299.95` |
| `DATE` | Fecha sin hora. | `'2005-03-01'` |
| `TIMESTAMP` | Fecha y hora sin zona horaria. | `'2026-09-15 10:30:00'` |
| `BOOLEAN` | Valor lógico: `TRUE` o `FALSE`. Admite `NULL` si la columna no es obligatoria. | `TRUE`, `FALSE` |

Consulta los [tipos de PostgreSQL 17](https://www.postgresql.org/docs/17/datatype.html).

Además de los tipos básicos, PostgreSQL permite definir [dominios](dominios.md), que reutilizan un tipo y sus restricciones, y [tipos enumerados](tipos_enumerados.md), que establecen una lista de valores permitidos. Los estudiaremos en el último bloque de DDL, después de la gestión de tablas.
