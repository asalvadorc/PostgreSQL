# 3. Práctica: crear Juegos

La práctica de **Juegos** se construye poco a poco a lo largo de los apartados de teoría. **No tienes que esperar al final para hacerla**: después de cada explicación, realiza el bloque de ejercicios correspondiente y conserva lo que hayas creado para el siguiente. Esta página reúne la preparación, los campos de referencia, el recorrido y la entrega.

Consulta el [modelo E/R y relacional de Juegos](../juegos.md). Escribe las sentencias en `02_juegos.sql` y ejecútalas en el orden de los ejercicios. No crees antes todas las tablas con sus restricciones: precisamente irás incorporándolas mediante `CREATE` y `ALTER`.

Si todavía no has comenzado, prepara la base y su conexión con las instrucciones siguientes y vuelve al apartado CREATE TABLE.

Las tablas definitivas deben quedar **vacías**. La inserción de datos se realizará después, en DML; las vistas pueden definirse ahora aunque todavía no devuelvan filas.

## 3.1 Crear la base de datos y su conexión

El **ejercicio 0** consiste en crear `juegos` y su conexión. Se realiza en [Crear bases de datos](crear_bases_datos.md#crear-juegos-y-su-conexion), siguiendo los mismos pasos que con `pruebas`. Si ya lo has completado, **no repitas la creación**. Después continuarás con los ejercicios **1–22**, sin cambios en su numeración.

Abre un editor desde la conexión **Juegos** y comprueba que `SELECT current_database();` devuelve `juegos`. Usa esta conexión en los ejercicios 1–18. No ejecutes los CREATE TABLE sobre tablas que ya existen.

## 3.2 Campos de referencia y pautas de trabajo

Esta tabla reúne todos los campos y tipos como referencia general. También encontrarás los campos de cada tabla junto a su ejercicio de creación, para trabajar sin cambiar de página. **Las claves y demás restricciones se añaden cuando lo indique cada ejercicio**, no todas desde el principio.

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

## 3.3 Construcción progresiva

Los enunciados están junto a la explicación de cada sentencia. Realiza los bloques en este orden, sin repetir los ejercicios que ya hayas completado:

| Después de estudiar | Ejercicios | Trabajo acumulado en Juegos |
| --- | --- | --- |
| [CREATE TABLE](tablas.md#ejercicios-juegos) | 1–2 | Crear `categorias` y `productos`, dejando pendientes sus claves. |
| [Restricciones](restricciones.md#ejercicios-juegos) | 3–8 | Crear las otras seis tablas, con las claves que se indican. |
| [ALTER TABLE](alter_table.md#ejercicios-juegos) | 9–13 | Modificar columnas y completar las claves pendientes. |

!!! info "Una única práctica, varios momentos de trabajo"
    Trabaja siempre sobre las mismas tablas de `juegos` y añade las sentencias al mismo archivo `02_juegos.sql`. No vuelvas a crear la base de datos ni elimines sus tablas entre bloques. Antes de añadir una FK, comprueba que la clave referenciada ya existe.

## 3.4 Índices y vistas

Continúa sobre la estructura que has completado:

| Después de estudiar | Ejercicios | Qué añadirás |
| --- | --- | --- |
| [Índices](indices.md#ejercicios-juegos) | 14–15 | Dos índices sobre jugadores y vendedores. |
| [Vistas](vistas.md#ejercicios-juegos) | 16–18 | Resúmenes de compras, vendedores y categorías. |

Las vistas pueden crearse con las tablas vacías. Sus consultas devolverán resultados cuando se carguen los datos en DML.

## 3.5 Objetos auxiliares en pruebas

Cambia a **pruebas** para estos ejercicios. Guarda las sentencias en `03_objetos_pruebas.sql` y no cambies las secuencias ni las tablas definitivas de Juegos.

| Después de estudiar | Ejercicios | Qué practicarás |
| --- | --- | --- |
| [Secuencias](secuencias.md#ejercicios-juegos) | 19–20 | NEXTVAL explícito y generación de códigos mediante DEFAULT. |
| [Dominios y tipos enumerados](tipos_enumerados.md#ejercicios-juegos) | 21–22 | SERIAL, CHECK y validaciones reutilizables. |

Elimina los objetos de demostración cuando lo indique cada ejercicio. Las inserciones de esta parte solo sirven para comprobar su funcionamiento en `pruebas`; la carga de datos de Juegos se realizará en DML.

## 3.6 Comprobar la estructura final

Después de completar los ejercicios 1–13, en DBeaver revisa **Columns**, **Constraints** y **Foreign Keys** de cada tabla. También puedes consultar:

```sql
SELECT table_name, constraint_type, constraint_name
FROM information_schema.table_constraints
WHERE table_schema = 'public'
  AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY table_name, constraint_type, constraint_name;
```

Deben existir **ocho claves primarias y nueve claves ajenas**. En `compras`, `id_jugador` e `id_vendedor` son no nulos; en `lineas_compra`, `id_producto` también. Las columnas que forman una clave primaria ya son no nulas.

## 3.7 Entrega de DDL

Comprueba que tienes **ocho tablas vacías en juegos**. Entrega `02_juegos.sql`, `03_objetos_pruebas.sql`, el `compose.yaml` utilizado y capturas de las restricciones. Explica la clave compuesta, la relación reflexiva y el orden de creación.

Después continúa con [DML: introducción y carga de datos](../BD_PostgreSQL_DML/1_introducci.md). Allí cargarás los datos de Juegos. No ejecutes todavía los archivos de datos ni el script combinado.

Secuencia adaptada a Juegos a partir de los [ejercicios progresivos de DDL sobre Factura](https://asalvadorc.github.io/BBDD_PostgreSQL_DDL/2_ddl/#2212-restriccions-de-camp-multiple). Se conservan los bloques 1–22 y se ajustan los nombres, las relaciones y los objetos de prueba al entorno de estos apuntes.
