# 2. DDL: definir la estructura

**DDL** (*Data Definition Language*) permite crear, modificar y eliminar bases de datos, tablas, restricciones y otros objetos. `CREATE` crea, `ALTER` modifica y `DROP` elimina. Practica los ejemplos auxiliares en la conexión **pruebas** del [entorno Docker](1_introducci.md). Las prácticas completas crearán después **mundomoviles** y **gamehub**.

## 2.1 Tipos de datos

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

Los códigos postales son texto: pueden comenzar por cero y no se usan para operaciones aritméticas. Para importes evita tipos de coma flotante cuando necesites precisión decimal. Consulta los [tipos de PostgreSQL 17](https://www.postgresql.org/docs/17/datatype.html).

## 2.2 CREATE TABLE

```sql
CREATE TABLE tabla (
    columna tipo [restricciones],
    otra_columna tipo [DEFAULT valor],
    [restricciones_de_tabla]
);
```

Las columnas se separan por comas. Usa identificadores sin espacios, acentos ni comillas, como `precio_unitario`. Una tabla recién creada está vacía.

Conectado a `pruebas`:

```sql
CREATE TABLE categorias_demo (
    id_categoria SERIAL PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

CREATE TABLE productos_demo (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    precio NUMERIC(10,2),
    stock INTEGER DEFAULT 0,
    id_categoria INTEGER,
    CONSTRAINT ck_demo_precio CHECK (precio >= 0),
    CONSTRAINT fk_demo_categoria FOREIGN KEY (id_categoria)
        REFERENCES categorias_demo(id_categoria)
);
```

`DEFAULT` se aplica cuando omites la columna o escribes `DEFAULT`; no sustituye un `NULL` explícito.

### Restricciones de una columna

- **PRIMARY KEY**: identifica la fila, sin duplicados ni nulos.
- **NOT NULL**: exige un valor.
- **UNIQUE**: impide duplicados; en su comportamiento normal permite varios nulos.
- **CHECK**: exige que una expresión no sea falsa. Si el resultado es desconocido por un NULL, la fila puede aceptarse; añade `NOT NULL` si el dato es obligatorio.
- **REFERENCES**: exige que el valor no nulo exista en una clave referenciada.

### Restricciones de varias columnas

```sql
CREATE TABLE lineas_demo (
    id_compra INTEGER,
    num_linea INTEGER,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2),
    descuento_linea NUMERIC(5,2),
    PRIMARY KEY (id_compra, num_linea),
    CONSTRAINT ck_demo_descuento
        CHECK (descuento_linea BETWEEN 0 AND 100)
);
```

La clave identifica cada línea dentro de su compra. Distintas compras pueden tener una línea número 1. La combinación completa no se repite.

### Claves ajenas y participación

En GameHub, `compras.id_jugador` combina **REFERENCES** y **NOT NULL**: toda compra debe pertenecer a un jugador existente. Una FK nullable permite que la referencia esté ausente; la clave ajena por sí sola no obliga a rellenarla.

Al definir `REFERENCES ... ON DELETE CASCADE`, borrar la fila referenciada también elimina las filas dependientes. Con `NO ACTION`, la operación falla si al comprobar la restricción quedan referencias sin destino. No apliques cascada a todas las relaciones por costumbre.

## 2.3 ALTER TABLE

Sirve para cambiar una tabla existente:

```sql
ALTER TABLE productos_demo ADD COLUMN activo BOOLEAN DEFAULT TRUE;
ALTER TABLE productos_demo ALTER COLUMN nombre TYPE VARCHAR(250);
ALTER TABLE productos_demo ALTER COLUMN stock SET DEFAULT 1;
ALTER TABLE productos_demo ALTER COLUMN stock SET NOT NULL;
ALTER TABLE productos_demo ADD CONSTRAINT ck_demo_stock CHECK (stock >= 0);
ALTER TABLE productos_demo RENAME COLUMN activo TO disponible;
ALTER TABLE productos_demo DROP COLUMN disponible;
ALTER TABLE productos_demo DROP CONSTRAINT ck_demo_stock;
```

Antes de añadir una restricción, los datos existentes deben cumplirla. `SET NOT NULL` falla si ya hay nulos. Para cambiar una FK, elimina su restricción y créala con el comportamiento nuevo.

## 2.4 DROP TABLE

```sql
DROP TABLE productos_demo;
DROP TABLE categorias_demo;
DROP TABLE lineas_demo;
```

Borra primero las tablas dependientes. `IF EXISTS` evita el error de objeto inexistente, pero no protege datos. `DROP TABLE ... CASCADE` elimina también objetos dependientes; no es equivalente a `ON DELETE CASCADE`, que actúa sobre filas. Usa `pruebas` para estos ejemplos.

## 2.5 Índices

Un índice puede facilitar búsquedas y ordenaciones, a costa de espacio y trabajo adicional al modificar datos. PostgreSQL ya crea índices para PK y UNIQUE; no crea automáticamente uno para cada FK.

En `gamehub`, después de crear sus tablas:

```sql
CREATE INDEX i_jugadores_nombre ON jugadores (nombre);
CREATE INDEX i_vendedores_cp_direccion ON vendedores (codigo_postal ASC, direccion DESC);

DROP INDEX i_jugadores_nombre;
DROP INDEX i_vendedores_cp_direccion;
```

El optimizador decide si utiliza un índice. Con tablas pequeñas puede preferir un recorrido completo.

## 2.6 Vistas

Una vista guarda una consulta, no una copia estática de sus filas. Ejemplo en `gamehub`:

```sql
CREATE VIEW resumen_compras AS
SELECT c.id_compra, c.fecha, c.id_jugador, c.id_vendedor,
       SUM(l.cantidad * l.precio_unitario) AS base_sin_descuentos,
       SUM(l.cantidad * l.precio_unitario *
           (1 - COALESCE(l.descuento_linea, 0) / 100.0)) AS base_descuento_lineas,
       SUM(l.cantidad * l.precio_unitario *
           (1 - COALESCE(l.descuento_linea, 0) / 100.0)) *
           (1 - COALESCE(c.descuento, 0) / 100.0) AS base_descuento_general,
       SUM(l.cantidad * l.precio_unitario *
           (1 - COALESCE(l.descuento_linea, 0) / 100.0)) *
           (1 - COALESCE(c.descuento, 0) / 100.0) *
           (1 + COALESCE(c.iva, 0) / 100.0) AS total
FROM compras AS c
JOIN lineas_compra AS l ON l.id_compra = c.id_compra
GROUP BY c.id_compra;

SELECT * FROM resumen_compras ORDER BY id_compra;
```

Aquí se calculan descuentos en dos niveles: primero el de cada línea y después el general de la compra. El IVA se aplica al final. `100.0` evita una división entera si cambian los tipos de los campos. La vista utiliza los datos actuales y solo incluye compras con líneas.

```sql
DROP VIEW resumen_compras;
```

## 2.7 Secuencias, dominios y tipos

### Secuencias

En `pruebas`:

```sql
CREATE SEQUENCE seq_jugadores_demo START WITH 1000 INCREMENT BY 5;
CREATE TABLE jugadores_demo (
    id_jugador INTEGER DEFAULT nextval('seq_jugadores_demo') PRIMARY KEY,
    nombre VARCHAR(150)
);
ALTER SEQUENCE seq_jugadores_demo OWNED BY jugadores_demo.id_jugador;
INSERT INTO jugadores_demo (nombre) VALUES ('Alex'), ('Noa');
SELECT * FROM jugadores_demo;
DROP TABLE jugadores_demo;
```

Se generan 1000 y 1005. Una secuencia puede tener huecos: no garantiza una numeración consecutiva. Al estar vinculada con `OWNED BY`, se elimina al borrar su columna. Otra opción es `INTEGER GENERATED BY DEFAULT AS IDENTITY`.

### Dominios

Un dominio reutiliza un tipo y sus restricciones:

```sql
CREATE DOMAIN porcentaje_demo AS NUMERIC(5,2)
    CHECK (VALUE BETWEEN 0 AND 100);
CREATE TABLE promociones_demo (
    id_promocion SERIAL PRIMARY KEY,
    descuento porcentaje_demo NOT NULL
);
DROP TABLE promociones_demo;
DROP DOMAIN porcentaje_demo;
```

### Tipos enumerados

```sql
CREATE TYPE estado_producto_demo AS ENUM ('Disponible', 'Agotado', 'En espera');
CREATE TABLE inventario_demo (
    id_producto SERIAL PRIMARY KEY,
    estado estado_producto_demo DEFAULT 'Disponible'
);
DROP TABLE inventario_demo;
DROP TYPE estado_producto_demo;
```

Continúa creando [MundoMoviles](3_crear_mundomoviles.md) y luego [GameHub](4_crear_gamehub.md). Los [ejercicios de todo el tema](exercicis_de_tot_el_tema.md) amplían estas operaciones.
