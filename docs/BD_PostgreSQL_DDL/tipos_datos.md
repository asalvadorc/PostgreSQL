---
hide:
  - toc
---

# Tipos de datos

Al crear una tabla debemos indicar **qué tipo de dato almacenará cada columna**. El tipo determina qué valores admite, cómo se representan y qué operaciones podemos realizar con ellos. Por ejemplo, un nombre necesita un tipo de texto, una cantidad un tipo entero y una fecha de compra un tipo de fecha.

Elegir el tipo adecuado ayuda a mantener la coherencia de los datos. En nuestras bases utilizaremos principalmente texto, números, fechas y valores lógicos. Para los precios emplearemos números decimales exactos; los códigos postales, en cambio, se guardarán como texto para conservar posibles ceros iniciales.

La siguiente tabla resume los tipos de PostgreSQL que utilizaremos en las prácticas:

| Tipo | Uso en nuestras bases |
| --- | --- |
| INTEGER | Códigos que referencian otras tablas, cantidades y stock. |
| SERIAL | Abreviatura de una columna entera con una secuencia y un valor por defecto. No añade por sí solo una PK. |
| VARCHAR(n) | Texto con longitud máxima: nombres, modelos y direcciones. |
| VARCHAR o TEXT | Texto sin el límite `n` declarado. En PostgreSQL, omitir `n` **no** establece un límite de 255. |
| DECIMAL(10,2) o NUMERIC(10,2) | Valores exactos con hasta diez cifras, dos decimales: precios. |
| DATE | Fechas sin hora. Escribe literales como `DATE '2024-03-01'`. |
| TIMESTAMP | Fecha y hora sin zona horaria. |
| BOOLEAN | Valores TRUE, FALSE o NULL. |

Consulta los [tipos de PostgreSQL 17](https://www.postgresql.org/docs/17/datatype.html).

Además de los tipos básicos, PostgreSQL permite definir [dominios](dominios.md), que reutilizan un tipo y sus restricciones, y [tipos enumerados](tipos_enumerados.md), que establecen una lista de valores permitidos. Los estudiaremos en el último bloque de DDL, después de la gestión de tablas.
