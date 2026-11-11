# 4. Crear GameHub

Después de MundoMoviles construirás **GameHub**, la tienda de videojuegos y accesorios. Consulta su [modelo E/R y modelo relacional](../BD_PostgreSQL_DQL/gamehub.md) para escribir las sentencias; no necesitas conectarte a ninguna base remota.

## 4.1 Crear una segunda base independiente

Conéctate a `postgres`, activa autocommit y ejecuta por separado:

```sql
CREATE DATABASE gamehub;
```

Crea una conexión a `gamehub` con `localhost`, puerto `5433`, usuario y contraseña `alumno`. Comprueba `SELECT current_database();`. No crees estas tablas en MundoMoviles.

## 4.2 Crear las ocho tablas

Utiliza `SERIAL` para las claves simples y `INTEGER` para las claves ajenas. La clave de las líneas es compuesta, no una nueva columna autonumérica.

| Orden | Tabla | Campos y tipos |
| ---: | --- | --- |
| 1 | provincias | id_provincia SERIAL PK, nombre VARCHAR(100). |
| 2 | ciudades | id_ciudad SERIAL PK, nombre VARCHAR(100), id_provincia INTEGER FK a provincias. |
| 3 | categorias | id_categoria SERIAL PK, descripcion VARCHAR(100). |
| 4 | productos | id_producto SERIAL PK, nombre VARCHAR(200), precio DECIMAL(10,2), stock INTEGER, stock_minimo INTEGER, id_categoria INTEGER FK a categorias. |
| 5 | jugadores | id_jugador SERIAL PK, nombre VARCHAR(150), direccion VARCHAR(200), codigo_postal VARCHAR(10), id_ciudad INTEGER FK a ciudades. |
| 6 | vendedores | id_vendedor SERIAL PK, nombre VARCHAR(150), direccion VARCHAR(200), codigo_postal VARCHAR(10), id_ciudad INTEGER FK a ciudades, id_jefe INTEGER FK a vendedores. |
| 7 | compras | id_compra SERIAL PK, fecha DATE, id_jugador INTEGER NOT NULL FK a jugadores, id_vendedor INTEGER NOT NULL FK a vendedores, iva DECIMAL(5,2), descuento DECIMAL(5,2). |
| 8 | lineas_compra | id_compra INTEGER FK a compras, num_linea INTEGER, id_producto INTEGER NOT NULL FK a productos, cantidad INTEGER, precio_unitario DECIMAL(10,2), descuento_linea DECIMAL(5,2). PK (id_compra, num_linea). |

En `lineas_compra`, define la referencia a `compras` con **ON DELETE CASCADE**: al eliminar una compra se eliminan sus líneas. Las demás referencias usan el comportamiento predeterminado **NO ACTION**. Es una decisión de borrado para practicar DML; no cambia las relaciones del modelo.

En `vendedores`, `id_jefe` puede ser nulo: el responsable de nivel superior no tiene jefe. La clave ajena puede apuntar a la misma tabla que estás creando.

Escribe las sentencias en `02_gamehub.sql`. Si una tabla depende de otra aún no creada, revisa el orden. Ejecuta tu script en la conexión `gamehub`.

## 4.3 Revisar las restricciones

En DBeaver revisa **Columns**, **Constraints** y **Foreign Keys** de cada tabla. También puedes consultar:

```sql
SELECT table_name, constraint_type, constraint_name
FROM information_schema.table_constraints
WHERE table_schema = 'public'
  AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY table_name, constraint_type, constraint_name;
```

Deben existir **ocho claves primarias y nueve claves ajenas**. En `compras`, `id_jugador` e `id_vendedor` son no nulos; en `lineas_compra`, `id_producto` también. Las columnas que forman una clave primaria ya son no nulas.

## 4.4 Entrega de DDL

Comprueba que tienes **tres tablas vacías en mundomoviles y ocho en gamehub**. Entrega `01_mundomoviles.sql`, `02_gamehub.sql`, el `compose.yaml` utilizado y capturas de las restricciones. Explica la clave compuesta, la relación reflexiva y el orden de creación.

Después continúa con [DML: introducción y carga de datos](../BD_PostgreSQL_DML/1_introducci.md). Allí cargarás primero MundoMoviles y después GameHub. No ejecutes todavía los archivos de datos ni el script combinado.
