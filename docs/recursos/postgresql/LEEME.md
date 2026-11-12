# PostgreSQL para el aula

Descarga compose.yaml y guárdalo en una carpeta para las prácticas.
Abre una terminal en esa carpeta y ejecuta:

docker compose up -d
docker compose ps

DBeaver: localhost, puerto 5433, usuario alumno, contraseña alumno.
El Compose solo arranca PostgreSQL. Las bases y las tablas se crean en DDL.
Los datos se descargan e insertan después, en el tema de DML, con DBeaver.
No se necesita una carpeta de scripts para arrancar el contenedor.

Guía completa: docs/entorno_postgresql.md en el repositorio.
