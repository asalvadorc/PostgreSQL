# PostgreSQL local con Docker Compose

En este apartado prepararemos un **contenedor Docker con PostgreSQL**, el sistema gestor de bases de datos que utilizaremos durante el curso. Así podremos trabajar en nuestro propio ordenador sin instalar PostgreSQL directamente, con un entorno que será fácil de arrancar y detener.

Utilizaremos **Docker Compose** para configurar y poner en marcha el servidor. Más adelante, en el tema de **DDL**, crearemos dentro de ese servidor las bases de datos **Moviles** y **Juegos**, junto con sus tablas y relaciones. Después insertaremos los datos en **DML** y realizaremos consultas en **DQL**.

## 2.1 Preparar las herramientas

Necesitas **Docker con Compose**, **DBeaver Community** y un editor de texto.

- En Windows y macOS, instala [Docker Desktop](https://docs.docker.com/desktop/) y ábrelo. En Windows utiliza el motor de contenedores Linux y completa la configuración de WSL 2 que solicita el instalador.
- En Ubuntu, si Docker ya está instalado en el aula, no lo reinstales. En un equipo personal sigue la [instalación oficial de Docker Engine](https://docs.docker.com/engine/install/ubuntu/), que incluye `docker-compose-plugin`.
- Instala [DBeaver Community](https://dbeaver.io/download/).

Comprueba en una terminal:

```bash
docker version
docker compose version
```

`docker version` debe mostrar tanto **Client** como **Server**. Si solo aparece Client o un error de conexión, inicia Docker Desktop o el servicio Docker antes de continuar. Usa `docker compose`, con espacio.

![alt text](image-4.png)

## 2.2 Descargar Docker Compose

Crea una carpeta para las prácticas, por ejemplo `postgresql`, y descarga en ella el archivo [compose.yaml](recursos/postgresql/compose.yaml).

Abre una terminal en esa carpeta. El archivo debe conservar el nombre `compose.yaml`, sin añadir la extensión `.txt`.

Por ahora solo necesitas este archivo para arrancar el servidor PostgreSQL. Crearás las bases y las tablas en DDL; la inserción de datos se realizará en el tema de DML.

## 2.3 Entender el Compose

El archivo utiliza las claves de Docker en inglés; no deben traducirse:

```yaml
name: aula-postgresql
services:
  postgres:
    image: postgres:17
    environment:
      POSTGRES_USER: alumno
      POSTGRES_PASSWORD: alumno
      POSTGRES_DB: postgres
    ports:
      - "127.0.0.1:5433:5432"
    volumes:
      - datos_postgres:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U alumno -d postgres"]
      interval: 5s
      timeout: 5s
      retries: 12
      start_period: 10s
volumes:
  datos_postgres:
```

| Elemento | Para qué sirve |
| --- | --- |
| `postgres:17` | Utiliza la versión mayor 17 de la imagen oficial, evitando cambios de versión mayor por usar `latest`. |
| `POSTGRES_DB: postgres` | Crea la base administrativa inicial. **No crea Moviles ni Juegos**. |
| `127.0.0.1:5433:5432` | Conecta el puerto 5433 de tu ordenador con el 5432 del contenedor. Solo se publica en tu propio equipo. |
| `datos_postgres` | Conserva las bases de datos al detener o recrear el contenedor. |
| `healthcheck` | Comprueba que PostgreSQL acepta conexiones. |

El usuario `alumno` es el administrador de este entorno docente local. La contraseña `alumno` es solo para esta práctica. Las variables de inicialización se aplican al crear un volumen vacío; editarlas después no cambia las credenciales de un volumen existente.

Documentación: [imagen oficial de PostgreSQL](https://hub.docker.com/_/postgres) y [comprobación del estado en Compose](https://docs.docker.com/compose/how-tos/startup-order/).

## 2.4 Arrancar y comprobar

Desde la carpeta que contiene `compose.yaml`:

```bash
docker compose config
docker compose up -d
docker compose ps
```

La primera vez se descarga la imagen. Espera a que el servicio aparezca como **healthy**. Para consultar los mensajes:

```bash
docker compose logs --tail=50 postgres
```

Comprueba el acceso:

```bash
docker compose exec postgres psql -U alumno -d postgres -c "SELECT version();"
```

## 2.5 Parar, reanudar y conservar los datos

```bash
# Detener sin borrar datos.
docker compose stop

# Volver a arrancar.
docker compose up -d

# Eliminar el contenedor y la red, conservando el volumen de datos.
docker compose down
```

No añadas `-v` a `down` en el trabajo habitual: eliminaría el volumen y todas las bases de datos de esta práctica. Para repetir una carga de datos, utiliza una base nueva; los archivos de datos no son una actualización ni deben ejecutarse dos veces sobre las mismas tablas.
