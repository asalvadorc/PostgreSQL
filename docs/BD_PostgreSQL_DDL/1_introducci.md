---
hide:
  - toc
---

# 1. Introducción a DDL

Con **DDL**, Lenguaje de Definición de Datos, definirás la estructura de las bases de datos: tablas, columnas, claves y restricciones. Después, en **DML**, insertarás y modificarás los datos; finalmente, en **DQL**, los consultarás.

Antes de empezar, completa la preparación de [PostgreSQL con Docker Compose](../entorno_postgresql.md) y la [conexión con DBeaver](../2_client_dbeaver_installaci_i_confiuraci.md), disponibles en Inicio. Debes tener el servidor local funcionando y una conexión a `postgres`.

Para ejecutar los ejemplos, debes haber creado la [base de datos de pruebas y su conexión](../crear_pruebas.md), como se explica en Inicio. Utiliza esa conexión para practicar las sentencias de este tema.

Realiza **los ejercicios de cada apartado en orden**: encontrarás los ejercicios 1–2 en CREATE TABLE, los 3–8 en Restricciones y los 9–13 en ALTER TABLE. Después continuarás con índices, vistas y otros objetos. No hay una práctica adicional: los ejercicios 0–22 forman una única secuencia. Los recuadros **Pruébalo** se ejecutan en `pruebas`; los ejercicios de construcción de Juegos se realizan en `juegos`, salvo que indiquen expresamente `pruebas`.

Guarda las sentencias de los ejercicios 1–18 en `02_juegos.sql` y las de los ejercicios 19–22 en `03_objetos_pruebas.sql`. Conserva las tablas de Juegos entre ejercicios y déjalas vacías hasta la carga de datos en DML.
