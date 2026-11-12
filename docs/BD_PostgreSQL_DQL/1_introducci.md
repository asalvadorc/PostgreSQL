# Introducción a SQL

**SQL** (*Structured Query Language*) permite definir, manipular y consultar datos de una base de datos relacional. Describe el resultado que se desea obtener; el gestor decide cómo ejecutar cada operación.

## Tipos de sentencias SQL

| Tema | Pregunta que resuelve | Sentencias principales |
| --- | --- | --- |
| DDL | ¿Qué estructura tendrá la base de datos? | CREATE, ALTER, DROP. |
| DML | ¿Cómo introducimos o modificamos sus datos? | INSERT, UPDATE, DELETE. |
| DQL | ¿Qué información queremos obtener? | SELECT. |


Primero prepara [PostgreSQL con Docker Compose](../entorno_postgresql.md) y [DBeaver](2_client_dbeaver_installaci_i_confiuraci.md). En DDL crearás **Moviles** y después **Juegos**. En DML cargarás sus datos y practicarás modificaciones. En DQL usarás Moviles para los ejemplos y Juegos para los ejercicios.

## PostgreSQL y Docker

En este curso utilizaremos **PostgreSQL** como **sistema gestor de bases de datos (SGBD)**. Será el encargado de almacenar nuestras bases de datos, ejecutar las sentencias SQL y mantener las relaciones y restricciones de las tablas.

Para no tener que instalar PostgreSQL directamente en el ordenador, lo ejecutaremos dentro de un **contenedor Docker**. El contenedor proporciona un entorno preparado con PostgreSQL que podemos arrancar y detener cuando lo necesitemos. En el equipo solo necesitaremos tener Docker instalado.

Utilizaremos **Docker Compose** para definir y arrancar ese contenedor, y **DBeaver** como cliente para conectarnos a PostgreSQL, crear las bases de datos y ejecutar nuestras sentencias SQL.
