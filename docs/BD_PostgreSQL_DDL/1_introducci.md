---
hide:
  - toc
---

# 1. Introducción a DDL

Con **DDL**, Lenguaje de Definición de Datos, definirás la estructura de las bases de datos: tablas, columnas, claves y restricciones. Después, en **DML**, insertarás y modificarás los datos; finalmente, en **DQL**, los consultarás.

Antes de empezar, completa la preparación de [PostgreSQL con Docker Compose](../entorno_postgresql.md) y la [conexión con DBeaver](../2_client_dbeaver_installaci_i_confiuraci.md), disponibles en Inicio. Debes tener el servidor local funcionando y una conexión a `postgres`.

En el apartado **2. Bases de datos y esquemas**, crearemos primero la [base de datos Empresa y su conexión](crear_bases_datos.md#crear-empresa) como ejemplo guiado. A partir de ese momento, utiliza esa conexión para realizar los **ejemplos guiados** del tema.

En los recuadros **Pruébalo** iremos construyendo, dentro de `empresa`, la **base de datos de Empresa que vimos en el modelo relacional**. No son ejemplos aislados: ejecuta las sentencias en orden y conserva las tablas para continuar en el apartado siguiente. Esta es la base de datos que utilizaremos para los **ejemplos guiados** de los apuntes.

La construiremos por etapas:

1. **CREATE TABLE:** crearemos `departamentos` y `empleados` sin restricciones, para centrarnos en las columnas y los tipos de datos.
2. **Restricciones de columna:** recrearemos esas dos tablas, todavía vacías, con sus claves y reglas de validación; añadiremos `proyectos`, relacionado con departamentos.
3. **Restricciones de varias columnas:** crearemos `familiares` y `trabaja`, para practicar claves compuestas y la relación N:M entre empleados y proyectos.
4. **ALTER TABLE:** completaremos los datos del empleado, la relación con su supervisor y la dirección de cada departamento.
5. **DROP TABLE:** practicaremos con una tabla auxiliar que podremos borrar sin perder las tablas de Empresa.

Retomamos las entidades y relaciones del modelo relacional con nombres SQL sin espacios ni guiones. Para mantener los ejemplos actuales, utilizaremos `codigo` como identificador de empleados, departamentos y proyectos, y `salario` para el sueldo. El DNI del empleado se incorporará como dato único. Al terminar tendremos **cinco tablas relacionadas**, que conservaremos para los ejemplos posteriores.
