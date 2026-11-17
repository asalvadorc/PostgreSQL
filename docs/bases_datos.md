---
hide:
  - toc
---

# Presentación

En este apartado se reúnen los **modelos entidad-relación (E/R) y relacionales** de las bases de datos **Moviles** y **Juegos** que utilizaremos durante el curso.

Los dejamos aquí para tenerlos **fácilmente localizables desde cualquier tema**. Podrás volver a ellos para consultar las entidades y relaciones, las tablas, sus campos y las claves primarias y ajenas, tanto al crear la estructura en **DDL** como al trabajar con los datos en **DML** o realizar consultas en **DQL**.

Este será nuestro entorno de trabajo cuando estén creadas las bases de datos: `pruebas` para experimentar y `moviles` y `juegos` para las prácticas, junto a la base inicial `postgres`. Todas estarán en el **mismo servidor PostgreSQL y contenedor Docker**; desde DBeaver elegiremos a cuál conectarnos.

![Entorno de trabajo con DBeaver, PostgreSQL en Docker y las bases de datos postgres, pruebas, juegos y moviles](cliente-servidor-postgresql-docker-bases.png){ width="600" }

- [Moviles](moviles.md): base de datos de países, empresas y modelos de teléfonos móviles, utilizada en los ejemplos.
- [Juegos](juegos.md): tienda de videojuegos, consolas y accesorios, utilizada en los ejercicios.
