# 3. Crear MundoMoviles

Esta es la primera base de datos que construirás. Antes de empezar, arranca el [entorno Docker Compose](../entorno_postgresql.md). Consulta el [modelo de MundoMoviles](../BD_PostgreSQL_DQL/3_dades_dels_exemples_i_els_exercicis.md).

## 3.1 Crear la base de datos

En DBeaver, conectado a `postgres` y con autocommit, ejecuta por separado:

```sql
CREATE DATABASE mundomoviles;
```

Crea una nueva conexión a `mundomoviles`: host `localhost`, puerto `5433`, usuario y contraseña `alumno`. Abre su editor SQL y comprueba:

```sql
SELECT current_database();
```

Debe devolver `mundomoviles`. A partir de este punto todas las sentencias se ejecutan en esa conexión.

## 3.2 Diseñar las tres tablas

La cadena es **PAISES (1) → (N) EMPRESAS (1) → (N) MOVILES**.

| Tabla | Campos | Restricciones |
| --- | --- | --- |
| paises | id_pais SERIAL, nombre_pais VARCHAR(100) | PK id_pais; nombre_pais no nulo. |
| empresas | id_empresa SERIAL, nombre VARCHAR(100), sede VARCHAR(100), id_pais INTEGER | PK id_empresa; nombre e id_pais no nulos; FK id_pais a paises. |
| moviles | id_movil SERIAL, modelo VARCHAR(200), fecha_lanzamiento DATE, precio DECIMAL(10,2), id_empresa INTEGER | PK id_movil; modelo e id_empresa no nulos; FK id_empresa a empresas. |

Escribe y ejecuta los `CREATE TABLE` en este orden: **paises → empresas → moviles**. Justifica por qué una tabla que referencia a otra se crea después de ella.

## 3.3 Comprobar las tablas vacías

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

Deben aparecer `empresas`, `moviles` y `paises`. Comprueba las claves en DBeaver antes de cargar datos.

## 3.4 Final de la práctica DDL

Las tres tablas deben quedar creadas y vacías. Guarda tus sentencias en `01_mundomoviles.sql` y una captura de las tablas y sus restricciones. Continúa con [Crear GameHub](4_crear_gamehub.md).

La carga de datos se realizará después, en [DML: introducción y carga](../BD_PostgreSQL_DML/1_introducci.md). No ejecutes todavía `mundomoviles-datos.sql` ni el script combinado de estructura y datos.
