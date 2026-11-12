# 3. Práctica guiada: crear Moviles

En esta práctica construiremos juntos la base de datos **Moviles**, paso a paso. Escribe y ejecuta las sentencias en el orden indicado, lee las explicaciones y comprueba cada resultado antes de continuar.

Necesitas el [servidor PostgreSQL con Docker](../entorno_postgresql.md) en marcha y la conexión inicial a `postgres` en DBeaver. Ten a mano el [modelo E/R y relacional de Moviles](../moviles.md).

La estructura es **PAISES (1) → (N) EMPRESAS (1) → (N) MOVILES**. Crearemos primero las tablas referenciadas y después las que contienen sus claves ajenas.

## 3.1 Crear la base de datos y su conexión

!!! example practica "Pruébalo: Crear la base de datos"

    Abre un editor SQL desde la conexión a **postgres** y ejecuta esta sentencia por separado:

    ```sql
    CREATE DATABASE moviles;
    ```

    Actualiza el navegador de DBeaver y comprueba que aparece `moviles`. Si ya la habías creado, continúa con esa base y revisa si sus tablas están vacías o ya existen; no vuelvas a ejecutar los CREATE TABLE de objetos que ya tengas.

Ahora crea una conexión PostgreSQL con los siguientes datos:

| Campo | Valor |
| --- | --- |
| Host | `localhost` |
| Puerto | `5433` |
| Base de datos | `moviles` |
| Usuario | `alumno` |
| Contraseña | `alumno` |

Pulsa **Probar conexión** y guarda la conexión como **Moviles**. Abre un nuevo editor SQL desde ella.

!!! example practica "Pruébalo: Comprobar la conexión"

    ```sql
    SELECT current_database();
    ```

    Debe devolver **moviles**. A partir de ahora, ejecuta todas las sentencias de esta práctica en esa conexión, no en `postgres` ni en `pruebas`.

## 3.2 Crear la tabla paises

Empezamos por `paises` porque no depende de ninguna otra tabla. Cada país tendrá un código y un nombre.

!!! example practica "Pruébalo: Crear paises"

    ```sql
    CREATE TABLE paises (
        id_pais SERIAL PRIMARY KEY,
        nombre_pais VARCHAR(100) NOT NULL
    );
    ```

    Actualiza **Schemas → public → Tables** en DBeaver y comprueba que aparece `paises`. Revisa sus columnas y su clave primaria.

- `SERIAL` genera un código entero cuando se inserta un país sin indicar su código.
- `PRIMARY KEY` identifica cada país y evita códigos duplicados o nulos.
- `VARCHAR(100)` permite un nombre de hasta 100 caracteres.
- `NOT NULL` obliga a indicar el nombre del país.

## 3.3 Crear la tabla empresas

Cada empresa tendrá un código, un nombre, una sede y el país al que pertenece. Ahora podemos crearla porque `paises` ya existe.

!!! example practica "Pruébalo: Crear empresas"

    ```sql
    CREATE TABLE empresas (
        id_empresa SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        sede VARCHAR(100),
        id_pais INTEGER NOT NULL REFERENCES paises(id_pais)
    );
    ```

    Comprueba que aparece `empresas` y revisa **Foreign Keys**: `id_pais` debe referenciar a `paises(id_pais)`.

`id_empresa` identifica a la empresa. `id_pais` es una **clave ajena**, por eso utilizamos `INTEGER`: no genera otro código de país, sino que guarda uno que exista en `paises`.

La combinación de `NOT NULL` y `REFERENCES` exige que toda empresa pertenezca a un país existente. Representa la **participación total de empresas** que aparece con doble línea en el modelo E/R. Varias empresas pueden compartir el mismo país: la relación es **1:N**.

`sede` no lleva `NOT NULL`, por lo que podrá quedar sin informar.

## 3.4 Crear la tabla moviles

Por último creamos `moviles`, que necesita referenciar a una empresa. Guardaremos su modelo, fecha de lanzamiento y precio.

!!! example practica "Pruébalo: Crear moviles"

    ```sql
    CREATE TABLE moviles (
        id_movil SERIAL PRIMARY KEY,
        modelo VARCHAR(200) NOT NULL,
        fecha_lanzamiento DATE,
        precio DECIMAL(10,2),
        id_empresa INTEGER NOT NULL REFERENCES empresas(id_empresa)
    );
    ```

    Revisa la clave primaria `id_movil` y la clave ajena `id_empresa`, que debe apuntar a `empresas(id_empresa)`.

- `DATE` almacena una fecha sin hora.
- `DECIMAL(10,2)` permite hasta diez cifras en total, de las cuales dos son decimales; lo utilizaremos para los precios.
- `modelo` es obligatorio, mientras que la fecha y el precio pueden ser nulos.
- `id_empresa` es obligatorio y debe corresponder a una empresa existente. Así se representa la **participación total de moviles** en la relación **1:N** con empresas.

## 3.5 Comprobar la estructura

!!! example practica "Pruébalo: Revisar las tablas creadas"

    ```sql
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
    ORDER BY table_name;
    ```

    Deben aparecer **empresas**, **moviles** y **paises**. Comprueba en DBeaver que hay **tres claves primarias y dos claves ajenas**.

Las tres tablas están **vacías**: `CREATE TABLE` define la estructura, pero no inserta filas. La carga de datos se realizará en el tema de **DML**.

!!! question "Autoevaluación"
    Antes de continuar, explica por qué hemos seguido el orden `paises → empresas → moviles` y qué ocurriría si intentáramos crear `moviles` antes de `empresas`.

    ??? success "Ver solución"
        Hemos creado primero las tablas que serán referenciadas por otras: `empresas.id_pais` apunta a `paises(id_pais)` y `moviles.id_empresa` apunta a `empresas(id_empresa)`.

        Si intentáramos crear `moviles` con su clave ajena antes de que existiera `empresas`, PostgreSQL devolvería un error porque la tabla referenciada todavía no existe. Por eso seguimos el orden **paises → empresas → moviles**.

        Otra posibilidad sería crear primero las tablas sin las claves ajenas y añadir esas restricciones después con `ALTER TABLE`, cuando ya existan las tablas referenciadas.

## 3.6 Guardar el trabajo

Guarda las tres sentencias `CREATE TABLE` en `01_moviles.sql` y una captura de las tablas y sus restricciones. La sentencia `CREATE DATABASE` se ejecuta por separado desde `postgres`; no la mezcles con la creación de tablas en la conexión `moviles`.

Continúa con [Crear Juegos](4_crear_juegos.md), donde aplicarás lo aprendido a una estructura más completa. No insertes datos todavía: lo haremos después en [DML](../BD_PostgreSQL_DML/1_introducci.md).
