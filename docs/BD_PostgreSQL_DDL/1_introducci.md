---
hide:
  - toc
---

# 1. Introducción a DDL

Con **DDL**, Lenguaje de Definición de Datos, definirás la estructura de las bases de datos: tablas, columnas, claves y restricciones. Después, en **DML**, insertarás y modificarás los datos; finalmente, en **DQL**, los consultarás.

Antes de empezar, completa la preparación de [PostgreSQL con Docker Compose](../entorno_postgresql.md) y la [conexión con DBeaver](../2_client_dbeaver_installaci_i_confiuraci.md), disponibles en Inicio. Debes tener el servidor local funcionando y una conexión a `postgres`.

Para ejecutar los ejemplos, debes haber creado la [base de datos de pruebas y su conexión](../crear_pruebas.md), como se explica en Inicio. Utiliza esa conexión para practicar las sentencias de este tema.

Realiza **los ejercicios de cada apartado**: el ejercicio 0 prepara Juegos; los ejercicios 1–2 crean sus primeras tablas, los 3–8 incorporan restricciones y los 9–13 completan la estructura con ALTER TABLE. Los ejercicios 14–15 de dominios y tipos enumerados son de ampliación: hazlos después de estudiar CREATE TABLE y restricciones.

Los ejercicios 16–20 de índices y vistas y los 21–22 de secuencias se realizarán más adelante, en el nuevo bloque de **DQL**. Continúan la numeración de los ejercicios de DDL.

Los recuadros **Pruébalo** se ejecutan en `pruebas`; los ejercicios de construcción de Juegos se realizan en `juegos`, salvo que indiquen expresamente `pruebas`. Guarda las sentencias de construcción en `02_juegos.sql` y las de los objetos auxiliares en `03_objetos_pruebas.sql`. Conserva las tablas de Juegos y déjalas vacías hasta la carga de datos en DML.
