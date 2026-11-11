# PostgreSQL para el aula

Abre una terminal en esta carpeta y ejecuta `docker compose up -d`.
Comprueba `docker compose ps`: el servicio debe estar healthy.

DBeaver: localhost, puerto 5433, usuario alumno, contraseña alumno.
Conecta primero a postgres y crea manualmente mundomoviles y gamehub,
en ese orden y en las prácticas correspondientes. Crea también pruebas
para los ejemplos de DDL que modifican o eliminan objetos.

No hay scripts de inicialización automática. El alumnado crea las tablas.
El alumnado escribe los CREATE TABLE en DDL. Este paquete solo incluye
los archivos *-datos.sql, que se ejecutan en DML una sola vez, después
de crear las tablas.
Selecciona la conexión de la base correspondiente y ejecuta el archivo
completo en DBeaver (Alt+X). No ejecutes CREATE DATABASE dentro de BEGIN.

También puedes ejecutar datos desde esta terminal:

docker compose exec -T postgres psql -U alumno -d mundomoviles -v ON_ERROR_STOP=1 -f /sql/mundomoviles-datos.sql
docker compose exec -T postgres psql -U alumno -d gamehub -v ON_ERROR_STOP=1 -f /sql/gamehub-datos.sql

Mantén la carpeta sql junto a compose.yaml. El montaje /sql es de solo lectura.
`docker compose stop` detiene; `docker compose up -d` reanuda.
`docker compose down` elimina el contenedor, conservando el volumen.
No añadas -v salvo que quieras borrar todos los datos de esta práctica.
El usuario y la contraseña son solo para este entorno local docente.

Guía completa: docs/entorno_postgresql.md en el repositorio.
