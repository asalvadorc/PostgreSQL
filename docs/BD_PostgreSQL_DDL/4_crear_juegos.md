# 4. Práctica: crear Juegos

Después de la práctica guiada de Moviles, crearás la base de datos **Juegos** mediante una secuencia de ejercicios. Los ejercicios **1–13** construyen sus ocho tablas y añaden las restricciones por etapas; los **14–18** trabajan índices y vistas; los **19–22** se realizan en `pruebas` con objetos auxiliares.

Consulta el [modelo E/R y relacional de Juegos](../BD_PostgreSQL_DQL/juegos.md). Escribe las sentencias en `02_juegos.sql` y ejecútalas en el orden de los ejercicios. No crees antes todas las tablas con sus restricciones: precisamente irás incorporándolas mediante `CREATE` y `ALTER`.

Las tablas definitivas deben quedar **vacías**. La inserción de datos se realizará después, en DML; las vistas pueden definirse ahora aunque todavía no devuelvan filas.

## 4.1 Crear la base de datos y su conexión

Desde la conexión a `postgres`, ejecuta por separado:

```sql
CREATE DATABASE juegos;
```

Crea una conexión a `juegos` con `localhost`, puerto `5433`, usuario y contraseña `alumno`. Abre su editor y ejecuta:

```sql
SELECT current_database();
```

Debe devolver **juegos**. Usa esta conexión en los ejercicios 1–18. Si ya habías creado las tablas en una práctica anterior, utiliza una base vacía para repetir la secuencia; no ejecutes los CREATE TABLE sobre tablas que ya existen.

## 4.2 Campos de referencia y pautas de trabajo

Utiliza esta tabla para consultar nombres y tipos. **Las claves y demás restricciones se añaden cuando lo indique cada ejercicio**, no todas desde el principio.

| Tabla | Campos y tipos |
| --- | --- |
| categorias | id_categoria SERIAL, descripcion VARCHAR(100). |
| productos | id_producto SERIAL, nombre VARCHAR(200), precio DECIMAL(10,2), stock INTEGER, stock_minimo INTEGER, id_categoria INTEGER. |
| provincias | id_provincia SERIAL, nombre VARCHAR(100). |
| ciudades | id_ciudad SERIAL, nombre VARCHAR(100), id_provincia INTEGER. |
| vendedores | id_vendedor SERIAL, nombre VARCHAR(150), direccion VARCHAR(200), codigo_postal VARCHAR(10), id_ciudad INTEGER, id_jefe INTEGER. |
| jugadores | id_jugador SERIAL, nombre VARCHAR(150), direccion VARCHAR(200), codigo_postal VARCHAR(10), id_ciudad INTEGER. |
| compras | id_compra SERIAL, fecha DATE, id_jugador INTEGER, id_vendedor INTEGER, iva DECIMAL(5,2), descuento DECIMAL(5,2). |
| lineas_compra | id_compra INTEGER, num_linea INTEGER, id_producto INTEGER, cantidad INTEGER, precio_unitario DECIMAL(10,2), descuento_linea DECIMAL(5,2). |

Recuerda:

- `SERIAL` genera códigos, pero no añade una PK por sí solo. Para las claves ajenas utiliza `INTEGER`.
- La PK de `lineas_compra` será `(id_compra, num_linea)`; no añadas otro código autonumérico.
- `vendedores.id_jefe` puede ser nulo y referencia a la propia tabla. Añadirás esa FK en el ejercicio 12.
- La FK de las líneas hacia las compras llevará `ON DELETE CASCADE`; las demás referencias conservarán `NO ACTION`, como indica el ejercicio 13.
- Después de cada ejercicio, actualiza el navegador de DBeaver y revisa las columnas y restricciones que hayas añadido.

## 4.3 Construcción progresiva

**Ex_1.** Crea `categorias` con sus columnas, de momento sin restricciones. Usa SERIAL para el código, pero no añadas todavía la PK. La generación del código no sustituye a la restricción de clave primaria.

**Ex_2.** Crea `productos` sin restricciones, usando SERIAL para `id_producto`.

**Ex_3.** Crea `provincias` con su clave primaria.

**Ex_4.** Crea `ciudades`, con PK y FK hacia `provincias`.

**Ex_5.** Crea `vendedores`, con PK y FK hacia `ciudades`. Deja la FK reflexiva para el ejercicio 12.

**Ex_6.** Crea `jugadores`, con PK y FK hacia `ciudades`.

**Ex_7.** Crea `compras`, con PK y FK hacia `jugadores` y `vendedores`. Las dos referencias deben ser no nulas.

**Ex_8.** Crea `lineas_compra`, con PK `(id_compra, num_linea)` e `id_producto` no nulo. Añadirás las dos FK en el ejercicio 13.

**Ex_9.** Añade a `vendedores` una columna `alias VARCHAR(40) NOT NULL UNIQUE`. La tabla todavía está vacía; explica qué habría que preparar si ya tuviera filas.

**Ex_10.** Elimina la columna `alias`.

**Ex_11.** Añade la PK de `categorias`.

**Ex_12.** Añade la PK de `productos`, su FK hacia `categorias` y la FK `vendedores.id_jefe` hacia `vendedores.id_vendedor`.

**Ex_13.** Añade las FK de `lineas_compra`: hacia `compras` con `ON DELETE CASCADE`, y hacia `productos` con `NO ACTION`. Revisa que hay ocho PK y nueve FK.

## 4.4 Índices y vistas

Las vistas pueden crearse con las tablas vacías. Sus consultas devolverán resultados cuando se carguen los datos en DML.

**Ex_14.** Crea `i_jugadores_nombre` sobre `jugadores(nombre)`.

**Ex_15.** Crea `i_vendedores_cp_direccion` por `codigo_postal` ascendente y `direccion` descendente.

**Ex_16.** Crea la vista `resumen_compras` con las bases sin descuentos, con descuento de líneas, con descuento general y el total con IVA. Calcula primero `SUM(cantidad * precio_unitario)`. Para el descuento de líneas, suma `cantidad * precio_unitario * (1 - COALESCE(descuento_linea, 0) / 100.0)`; después multiplica por `(1 - COALESCE(descuento, 0) / 100.0)` y, al final, por `(1 + COALESCE(iva, 0) / 100.0)`. La columna del importe final debe llamarse `total`.

**Ex_17.** Crea `resumen_vendedores`: código y nombre del vendedor, total de unidades vendidas y base de sus compras tras los descuentos. Evita duplicar el importe de una compra al reunirla con sus líneas.

**Ex_18.** Crea `resumen_categorias`: categoría, unidades vendidas e importe de líneas tras aplicar solo `descuento_linea`.

## 4.5 Objetos auxiliares en pruebas

Realiza estos ejercicios en **pruebas**. No cambies las secuencias de las tablas definitivas de Juegos.

**Ex_19.** Crea una secuencia que empiece en 1000 y avance de 5 en 5. Úsala como valor por defecto de `vendedores_demo.id_vendedor`. Inserta dos vendedores, comprueba los códigos y elimina la tabla y la secuencia en el orden adecuado.

**Ex_20.** Crea `jugadores_demo` con una columna `INTEGER GENERATED BY DEFAULT AS IDENTITY`. Inserta un jugador omitiendo su código. Explica la diferencia entre PK, generación del código y UNIQUE.

**Ex_21.** Crea `compras_demo` con código autonumérico, IVA obligatorio de 10 o 21 y descuento entre 0 y menos de 50. Comprueba una inserción válida y otra rechazada.

**Ex_22.** Crea `productos_demo` con precio, stock y stock mínimo no negativos, un tipo enumerado para el estado (`Disponible`, `Agotado`, `En espera`) y un dominio de texto de 13 dígitos para un código de barras. Un control de formato no verifica el dígito de control ni permite deducir el país de fabricación. Añade una restricción de tabla `stock >= stock_minimo` y explica por qué en un inventario real puede ser útil permitir stock bajo mínimo. Elimina los objetos de prueba al terminar.

## 4.6 Comprobar la estructura final

Después de completar los ejercicios 1–13, en DBeaver revisa **Columns**, **Constraints** y **Foreign Keys** de cada tabla. También puedes consultar:

```sql
SELECT table_name, constraint_type, constraint_name
FROM information_schema.table_constraints
WHERE table_schema = 'public'
  AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY table_name, constraint_type, constraint_name;
```

Deben existir **ocho claves primarias y nueve claves ajenas**. En `compras`, `id_jugador` e `id_vendedor` son no nulos; en `lineas_compra`, `id_producto` también. Las columnas que forman una clave primaria ya son no nulas.

## 4.7 Entrega de DDL

Comprueba que tienes **tres tablas vacías en moviles y ocho en juegos**. Entrega `01_moviles.sql`, `02_juegos.sql`, el `compose.yaml` utilizado y capturas de las restricciones. Explica la clave compuesta, la relación reflexiva y el orden de creación.

Después continúa con [DML: introducción y carga de datos](../BD_PostgreSQL_DML/1_introducci.md). Allí cargarás primero Moviles y después Juegos. No ejecutes todavía los archivos de datos ni el script combinado.
