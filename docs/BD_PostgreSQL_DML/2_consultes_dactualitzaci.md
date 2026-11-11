# 2. INSERT, UPDATE y DELETE

Trabaja en tu conexión **gamehub**, después de la [carga inicial](1_introducci.md). Verifica siempre `SELECT current_database();`.

## 2.1 INSERT

```sql
INSERT INTO tabla (columna1, columna2) VALUES (valor1, valor2);
```

Nombra las columnas para que el orden sea explícito. Si omites un código SERIAL se genera; si omites una columna sin valor por defecto, queda NULL cuando está permitido.

```sql
BEGIN;
INSERT INTO categorias (descripcion) VALUES ('Realidad virtual')
RETURNING id_categoria, descripcion;
ROLLBACK;
```

`RETURNING` muestra la fila insertada. También se pueden insertar varias filas o el resultado de un `SELECT`:

```sql
BEGIN;
CREATE TEMP TABLE productos_copia AS SELECT * FROM productos WITH NO DATA;
INSERT INTO productos_copia SELECT * FROM productos WHERE id_categoria = 3;
SELECT * FROM productos_copia;
ROLLBACK;
```

### Insertar filas relacionadas

Primero crea las filas referenciadas y después las dependientes. En este ejemplo una CTE recupera el código generado de la compra para insertar su línea:

```sql
BEGIN;
WITH nueva_compra AS (
    INSERT INTO compras (fecha, id_jugador, id_vendedor, iva, descuento)
    VALUES (CURRENT_DATE, 1, 2, 21, 0)
    RETURNING id_compra
)
INSERT INTO lineas_compra
    (id_compra, num_linea, id_producto, cantidad, precio_unitario, descuento_linea)
SELECT id_compra, 1, 1, 1, 59.99, 0 FROM nueva_compra;
ROLLBACK;
```

Una compra sin jugador o vendedor falla por NOT NULL. Una referencia a un código inexistente falla por la FK. Al probar un error dentro de una transacción, ejecuta después `ROLLBACK;` para salir de su estado abortado.

## 2.2 UPDATE

```sql
UPDATE tabla SET columna = expresion WHERE condicion;
```

Antes de actualizar, ejecuta un `SELECT` con el mismo filtro para revisar qué filas cambiarán.

```sql
BEGIN;
SELECT id_producto, nombre, precio FROM productos WHERE id_categoria = 3;
UPDATE productos
SET precio = ROUND(precio * 1.05, 2)
WHERE id_categoria = 3
RETURNING id_producto, nombre, precio;
ROLLBACK;
```

Sin `WHERE` se modifican todas las filas. `SET codigo_postal = NULL` elimina el valor; la cadena vacía no es NULL.

## 2.3 DELETE

```sql
DELETE FROM tabla WHERE condicion;
```

```sql
BEGIN;
DELETE FROM compras WHERE id_compra = 12;
SELECT COUNT(*) FROM lineas_compra WHERE id_compra = 12;
ROLLBACK;
```

El resultado es 0 porque la FK de `lineas_compra` hacia `compras` tiene `ON DELETE CASCADE`. El `ROLLBACK` restaura la compra y sus diez líneas. Si construiste esa FK sin cascada, corrígela siguiendo la práctica DDL antes de realizar el ejemplo.

No puedes borrar un producto que siga referenciado por una línea con `NO ACTION`. No resuelvas el error quitando restricciones: revisa la operación que se pide.

## 2.4 Transacciones

`BEGIN` inicia una transacción, `COMMIT` confirma y `ROLLBACK` revierte sus cambios. Utiliza `ROLLBACK` para las prácticas que deben conservar los datos iniciales. `TRUNCATE` vacía tablas completas y no acepta `WHERE`; no lo confundas con un borrado filtrado.

Continúa con los [ejercicios DML de GameHub](exercicis_de_tot_el_tema.md). Al terminar, pasa a DQL y conserva las cargas iniciales.
