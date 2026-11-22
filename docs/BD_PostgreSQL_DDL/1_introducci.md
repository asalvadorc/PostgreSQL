---
hide:
  - toc
---

# 1. Introducción a DDL

Con **DDL**, Lenguaje de Definición de Datos, definirás la estructura de las bases de datos: tablas, columnas, claves y restricciones. Después, en **DML**, insertarás y modificarás los datos; finalmente, en **DQL**, los consultarás.

Antes de empezar, completa la preparación de [PostgreSQL con Docker Compose](../entorno_postgresql.md) y la [conexión con DBeaver](../2_client_dbeaver_installaci_i_confiuraci.md), disponibles en Inicio. Debes tener el servidor local funcionando y una conexión a `postgres`.

En el apartado **2.1 Bases de datos y esquemas**, crearemos primero la [base de datos Empresa y su conexión](crear_bases_datos.md#crear-empresa) como ejemplo guiado. A partir de ese momento, utiliza esa conexión para realizar los **ejemplos guiados** del tema.

En los recuadros **Pruébalo** iremos construyendo, dentro de `empresa`, la **base de datos de Empresa que vimos en el modelo relacional**. No son ejemplos aislados: ejecuta las sentencias en orden y conserva las tablas para continuar en el apartado siguiente. Esta es la base de datos que utilizaremos para los **ejemplos guiados** de los apuntes.

La construiremos por etapas:

1. **CREATE TABLE:** crearemos `departamentos` y `empleados` sin restricciones, para centrarnos en las columnas y los tipos de datos.
2. **Restricciones de columna:** recrearemos esas dos tablas, todavía vacías, con sus claves y reglas de validación; añadiremos `proyectos`, relacionado con departamentos.
3. **Restricciones de varias columnas:** crearemos `familiares` y `trabaja`, para practicar claves compuestas y la relación N:M entre empleados y proyectos.
4. **ALTER TABLE:** completaremos los datos del empleado, la relación con su supervisor y la dirección de cada departamento.
5. **DROP TABLE:** practicaremos con una tabla auxiliar que podremos borrar sin perder las tablas de Empresa.

Retomamos las entidades y relaciones del modelo relacional con nombres SQL sin espacios ni guiones. Para mantener los ejemplos actuales, utilizaremos `codigo` como identificador de empleados, departamentos y proyectos, y `salario` para el sueldo. El DNI del empleado se incorporará como dato único. Al terminar tendremos **cinco tablas relacionadas**, que conservaremos para los ejemplos posteriores.

Realiza **los ejercicios de cada apartado**: el ejercicio 0 prepara Juegos; los ejercicios 1–2 crean sus primeras tablas, los 3–8 incorporan restricciones y los 9–13 completan la estructura con ALTER TABLE. Los ejercicios 14–15 de dominios y tipos enumerados son de ampliación: hazlos después de estudiar CREATE TABLE y restricciones.

Los ejercicios 16–20 de índices y vistas y los 21–22 de secuencias se realizarán más adelante, en el nuevo bloque de **DQL**. Continúan la numeración de los ejercicios de DDL.

Los recuadros **Pruébalo** se ejecutan en `empresa`; los ejercicios de construcción de Juegos se realizan en `juegos`, salvo que indiquen expresamente `empresa`. Guarda la construcción de Empresa en `01_empresa.sql`, las sentencias de construcción de Juegos en `02_juegos.sql` y las de los objetos auxiliares en `03_objetos_empresa.sql`. Conserva las tablas de Juegos y déjalas vacías hasta la carga de datos en DML.
