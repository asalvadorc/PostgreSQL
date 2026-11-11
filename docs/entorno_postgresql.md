# PostgreSQL local con Docker Compose

En este tema crearás tus propias bases de datos. Primero construirás **MundoMoviles**, con tres tablas y dos relaciones 1:N; después construirás **GameHub**, con ocho tablas, una clave compuesta y una relación reflexiva. En DQL consultarás las bases que has creado y en DML modificarás sus datos.

Cada alumno trabaja en su ordenador. Un único contenedor de PostgreSQL guarda las dos bases de datos y una tercera, `pruebas`, para experimentar con DDL.

## 1.1 Preparar las herramientas

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

## 1.2 Descargar el entorno

Descarga [postgresql-aula.zip](recursos/postgresql-aula.zip), descomprímelo y abre una terminal dentro de la carpeta `postgresql`:

```text
postgresql/
├── compose.yaml
├── LEEME.md
└── sql/
    ├── mundomoviles-datos.sql
    └── gamehub-datos.sql
```

Los archivos `*-datos.sql` contienen solo los datos que cargarás en DML, después de crear tus tablas en DDL. El paquete no contiene soluciones de creación de tablas.

También puedes descargar el [compose.yaml](recursos/postgresql/compose.yaml) por separado. En ese caso crea a su lado la carpeta `sql` y guarda allí los dos scripts de datos anteriores, disponibles en las prácticas.

## 1.3 Entender el Compose

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
      - ./sql:/sql:ro
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
| `POSTGRES_DB: postgres` | Crea la base administrativa inicial. **No crea MundoMoviles ni GameHub**. |
| `127.0.0.1:5433:5432` | Conecta el puerto 5433 de tu ordenador con el 5432 del contenedor. Solo se publica en tu propio equipo. |
| `datos_postgres` | Conserva las bases de datos al detener o recrear el contenedor. |
| `./sql:/sql:ro` | Permite leer los scripts desde el contenedor; no los ejecuta automáticamente. |
| `healthcheck` | Comprueba que PostgreSQL acepta conexiones. |

El usuario `alumno` es el administrador de este entorno docente local. La contraseña `alumno` es solo para esta práctica. Las variables de inicialización se aplican al crear un volumen vacío; editarlas después no cambia las credenciales de un volumen existente.

Documentación: [imagen oficial de PostgreSQL](https://hub.docker.com/_/postgres) y [comprobación del estado en Compose](https://docs.docker.com/compose/how-tos/startup-order/).

## 1.4 Arrancar y comprobar

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

## 1.5 Conectar desde DBeaver

Crea una conexión PostgreSQL con estos datos:

| Campo | Valor |
| --- | --- |
| Host | `localhost` |
| Puerto | `5433` |
| Base de datos | `postgres` |
| Usuario | `alumno` |
| Contraseña | `alumno` |

Pulsa **Probar conexión**; acepta la descarga del controlador PostgreSQL si se solicita. Guarda la conexión como **PostgreSQL aula — administración**.

Abre un editor SQL conectado a `postgres`. Para crear la base de pruebas, ejecuta esta sentencia **por separado**, con autocommit activado:

```sql
CREATE DATABASE pruebas;
```

`CREATE DATABASE` no puede ejecutarse dentro de una transacción. No lo rodees de `BEGIN`/`COMMIT` ni lo incluyas en un script que DBeaver ejecute como una única transacción.

Crea otra conexión con los mismos datos, cambiando **Base de datos** a `pruebas`. PostgreSQL no dispone de `USE base_de_datos`: para cambiar de base, abre la conexión correspondiente.

## 1.6 Orden de trabajo

1. Estudia las [sentencias DDL](BD_PostgreSQL_DDL/2_ddl.md).
2. Completa [Crear MundoMoviles](BD_PostgreSQL_DDL/3_crear_mundomoviles.md): crea la base y sus tablas, que quedarán vacías.
3. Completa [Crear GameHub](BD_PostgreSQL_DDL/4_crear_gamehub.md), siguiendo el orden de sus claves ajenas.
4. Realiza los [ejercicios DDL](BD_PostgreSQL_DDL/exercicis_de_tot_el_tema.md).
5. Continúa con [DML](BD_PostgreSQL_DML/1_introducci.md): carga primero los datos de MundoMoviles y después los de GameHub; practica inserciones, modificaciones y borrados.
6. Finalmente usa `mundomoviles` para los ejemplos de DQL y `gamehub` para los ejercicios de DQL.

## 1.7 Parar, reanudar y conservar los datos

```bash
# Detener sin borrar datos.
docker compose stop

# Volver a arrancar.
docker compose up -d

# Eliminar el contenedor y la red, conservando el volumen de datos.
docker compose down
```

No añadas `-v` a `down` en el trabajo habitual: eliminaría el volumen y todas las bases de datos de esta práctica. Para repetir una carga de datos, utiliza una base nueva; los archivos de datos no son una actualización ni deben ejecutarse dos veces sobre las mismas tablas.

## 1.8 Resolver problemas

| Problema | Comprobación y solución |
| --- | --- |
| No conecta con Docker | Abre Docker Desktop o pide al profesor que revise el servicio Docker. |
| El puerto 5433 está ocupado | Cambia solo el primer puerto del Compose, por ejemplo a `127.0.0.1:5434:5432`, y usa 5434 en DBeaver. |
| Error de contraseña tras editar Compose | Las credenciales anteriores siguen en el volumen; usa las originales. Cambiar variables no cambia usuarios ya creados. |
| No aparece una tabla | Comprueba `SELECT current_database();`, actualiza el navegador de DBeaver y revisa `Schemas → public → Tables`. |
| `relation already exists` | Estás volviendo a ejecutar el script de estructura. Continúa en una base vacía o revisa los objetos que ya creaste. |
| Error de clave ajena al insertar | Carga los datos completos en su orden original, con todas las tablas ya creadas. |
| `permission denied` al usar Docker en Linux | Revisa la configuración de permisos del equipo con el profesor; no cambies permisos de archivos de PostgreSQL. |
