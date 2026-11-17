# Usuarios y privilegios

Para realizar los ejemplos, utiliza la [base de datos **pruebas** y su conexión](../crear_pruebas.md), con el usuario **alumno**. Las tablas y usuarios de esta página son independientes de los ejemplos anteriores.

Hasta ahora hemos trabajado con `alumno`, el administrador de nuestro entorno. En una base de datos compartida, cada usuario debe disponer de los permisos que necesita: por ejemplo, una persona puede consultar una tabla sin poder modificarla.

En PostgreSQL los permisos se asignan a **roles**. Un rol que puede iniciar sesión actúa como un **usuario**. `CREATE USER` equivale a `CREATE ROLE` con la opción `LOGIN`. Los usuarios pertenecen al servidor PostgreSQL y pueden utilizarse en sus distintas bases de datos; los permisos sobre tablas se conceden dentro de la base correspondiente.

`CREATE USER` crea un usuario, `ALTER USER` permite cambiar su contraseña y `DROP USER` lo elimina. La creación de usuarios se completa con `GRANT`, para **conceder privilegios**, y `REVOKE`, para **retirarlos**. Estas dos sentencias forman parte de **DCL** (*Data Control Language*, lenguaje de control de datos). Las estudiamos aquí para completar la definición y el acceso a los objetos de la base de datos.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE USER nombre PASSWORD 'contraseña';</code></td></tr>
    <tr><td><code>ALTER USER nombre PASSWORD 'nueva_contraseña';</code></td></tr>
    <tr><td><code>GRANT privilegio [, ...]</code><br/><code>    ON TABLE [esquema.]tabla TO usuario;</code></td></tr>
    <tr><td><code>REVOKE privilegio [, ...]</code><br/><code>    ON TABLE [esquema.]tabla FROM usuario;</code></td></tr>
    <tr><td><code>DROP USER nombre;</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE USER`**

    - `CREATE USER`: crea un rol con permiso para iniciar sesión.
    - `PASSWORD`: establece su contraseña.

    **`ALTER USER`**

    - `PASSWORD`: cambia la contraseña.

    **`GRANT privilegio`**

    - `TO`: usuario que recibe los permisos.
    - Para una tabla: `SELECT`, `INSERT`, `UPDATE` y `DELETE`, entre otros.

    **`REVOKE privilegio`**

    - `FROM`: usuario al que se retira el permiso concedido.

    **`DROP USER`**

    - Antes deben eliminarse o reasignarse sus objetos y retirarse sus permisos en las bases de datos correspondientes.


## Usuarios y roles: qué diferencia hay

Imagina que varias personas necesitan consultar las mismas tablas. Podemos conceder `SELECT` a cada usuario por separado, pero tendríamos que repetir las concesiones cada vez que se incorpora alguien. Un **rol de grupo** permite reunir esos permisos y asignarlos de una vez a sus miembros.

| Concepto | Para qué sirve | Ejemplo |
| --- | --- | --- |
| Usuario, un rol con `LOGIN` | Identifica a una persona o aplicación que se conecta. | `lector_demo` |
| Rol de grupo, normalmente con `NOLOGIN` | Agrupa permisos para compartirlos entre usuarios. | `consulta_demo` |
| Privilegio | Autoriza una operación sobre un objeto. | `SELECT` sobre `permisos_demo` |
| Pertenencia | Vincula un usuario con un rol de grupo. | `lector_demo` pertenece a `consulta_demo` |

**Los permisos se conceden al rol; los usuarios se incorporan a ese rol.** Por ejemplo, si cinco usuarios pertenecen a `consulta_demo`, podemos conceder una nueva tabla al rol y sus cinco miembros tendrán acceso a ella. Cada persona sigue conectándose con su propio usuario y contraseña.

En PostgreSQL ambos son roles: `CREATE ROLE consulta_demo NOLOGIN` crea el grupo sin inicio de sesión; `CREATE USER lector_demo ...` crea un rol con `LOGIN`. Con la configuración predeterminada que utilizamos, los usuarios **heredan automáticamente** los permisos de los roles a los que pertenecen.

## Permisos más habituales

| Objeto | Privilegio | Permite |
| --- | --- | --- |
| Base de datos | `CONNECT` | Conectarse a esa base de datos. |
| Esquema | `USAGE` | Acceder a los objetos del esquema, si también se tienen los permisos necesarios sobre ellos. |
| Tabla o vista | `SELECT` | Consultar sus datos. |
| Tabla | `INSERT` | Insertar filas. |
| Tabla | `UPDATE` | Modificar filas. |
| Tabla | `DELETE` | Borrar filas. |

**Conectarse a una base de datos no da permiso para consultar o modificar todas sus tablas.** Los permisos de base de datos, esquema y tabla cumplen funciones diferentes. Tampoco es lo mismo `DELETE`, que borra filas, que `DROP TABLE`, que elimina la tabla: conceder `DELETE` no permite eliminar su estructura.

## Crear un usuario de consulta

!!! example practica "Pruébalo: Crear un usuario y conceder permisos"

    Desde tu conexión a **pruebas**, con el usuario **alumno**, ejecuta las sentencias una a una. Utilizaremos una tabla independiente de los ejemplos anteriores.

    ```sql
    -- Crear una tabla para comprobar los permisos.
    CREATE TABLE permisos_demo (
        id INTEGER PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );

    -- Crear un usuario sin privilegios de administrador.
    CREATE USER lector_demo PASSWORD 'lector_demo';

    -- Permitir la conexión a pruebas y el acceso al esquema public.
    GRANT CONNECT ON DATABASE pruebas TO lector_demo;
    GRANT USAGE ON SCHEMA public TO lector_demo;

    -- Permitir únicamente la consulta de esta tabla.
    GRANT SELECT ON TABLE public.permisos_demo TO lector_demo;
    ```

    La contraseña es un ejemplo para el entorno local de las prácticas. No modifiques el usuario `alumno` ni las variables de `compose.yaml`: el nuevo usuario se crea en el servidor que ya está funcionando.

PostgreSQL puede conceder algunos permisos a `PUBLIC`, que representa a todos los usuarios. Por ejemplo, `CONNECT` y el acceso al esquema `public` pueden estar disponibles de antemano. Los indicamos explícitamente para distinguir los niveles de acceso. Un usuario acumula sus permisos directos, los de sus roles y los de `PUBLIC`.

## Comprobar los permisos desde DBeaver

!!! example practica "Pruébalo: Conectarte como lector_demo"

    Crea una **nueva conexión PostgreSQL** en DBeaver con estos datos. Conserva abierta la conexión de `alumno` para administrar los permisos.

    | Campo | Valor |
    | --- | --- |
    | Host | `localhost` |
    | Puerto | `5433` |
    | Base de datos | `pruebas` |
    | Usuario | `lector_demo` |
    | Contraseña | `lector_demo` |
    | Nombre de la conexión | `Pruebas - lector` |

    Abre **Editor SQL → Nuevo script SQL** desde esta nueva conexión y ejecuta:

    ```sql
    SELECT current_database(), current_user;
    SELECT * FROM public.permisos_demo;
    ```

    La primera consulta debe mostrar `pruebas` y `lector_demo`. La segunda funciona, aunque no devuelve filas porque la tabla está vacía.

    Después ejecuta **por separado**:

    ```sql
    DELETE FROM public.permisos_demo;
    ```

    Debe aparecer un error de permiso denegado: `lector_demo` puede consultar la tabla, pero no borrar sus filas, aunque esté vacía. Estas comprobaciones deben hacerse con `lector_demo`; el administrador `alumno` no tiene esas limitaciones. Si el editor queda en una transacción fallida tras el error, pulsa **Rollback** antes de continuar.

## Conceder y retirar permisos

!!! example practica "Pruébalo: Cambiar los permisos"

    Vuelve al editor de **pruebas con el usuario alumno** y concede el permiso de borrado:

    ```sql
    GRANT DELETE ON TABLE public.permisos_demo TO lector_demo;
    ```

    Desde la conexión **Pruebas - lector**, repite:

    ```sql
    DELETE FROM public.permisos_demo;
    ```

    Ahora la sentencia se ejecuta correctamente y afecta a **0 filas**, porque la tabla está vacía.

    De nuevo como **alumno**, retira ese permiso:

    ```sql
    REVOKE DELETE ON TABLE public.permisos_demo FROM lector_demo;
    ```

    Comprueba como **lector_demo**, ejecutando cada sentencia por separado, que `SELECT` sigue funcionando y `DELETE` vuelve a dar un error de permiso denegado.

`REVOKE` retira la concesión indicada. Si un usuario obtiene el mismo permiso a través de otro rol o de `PUBLIC`, puede seguir disponiendo de él. En este ejemplo, el permiso `DELETE` se había concedido directamente a `lector_demo`.

## Agrupar los permisos en un rol

`CREATE ROLE ... NOLOGIN` crea un grupo de permisos. `GRANT rol TO usuario` incorpora un usuario al grupo y `REVOKE rol FROM usuario` retira su pertenencia. `DROP ROLE` elimina el rol una vez resueltas sus dependencias.

Ahora sustituiremos el permiso de consulta concedido directamente a `lector_demo` por un permiso obtenido a través de un rol. Utilizaremos el mismo usuario y la misma tabla, antes de eliminarlos.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE ROLE nombre_rol NOLOGIN;</code></td></tr>
    <tr><td><code>GRANT SELECT ON TABLE tabla TO nombre_rol;</code></td></tr>
    <tr><td><code>GRANT nombre_rol TO usuario;</code></td></tr>
    <tr><td><code>REVOKE nombre_rol FROM usuario;</code></td></tr>
    <tr><td><code>DROP ROLE nombre_rol;</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE ROLE`**

    - `NOLOGIN`: impide iniciar sesión con el rol; es el valor predeterminado de `CREATE ROLE`.

    **`GRANT SELECT`**

    - Concede el permiso al grupo.

    **`GRANT nombre_rol`**

    - Incorpora el usuario al rol; no lleva `ON TABLE`.

    **`REVOKE nombre_rol`**

    - Retira la pertenencia, sin eliminar el usuario ni el rol.

    **`DROP ROLE`**

    - Antes deben retirarse sus permisos y resolverse sus dependencias.


Fíjate en las dos formas de `GRANT`: **`GRANT SELECT ON TABLE ...` concede un privilegio sobre una tabla**, mientras que **`GRANT consulta_demo TO ...` concede pertenencia a un rol**.

!!! example practica "Pruébalo: Compartir permisos mediante un rol"

    Desde **pruebas con el usuario alumno**, ejecuta:

    ```sql
    -- Crear un rol que agrupará los permisos de consulta.
    CREATE ROLE consulta_demo NOLOGIN;

    -- Conceder el permiso al rol de grupo.
    GRANT SELECT ON TABLE public.permisos_demo TO consulta_demo;

    -- Incorporar el usuario al grupo.
    GRANT consulta_demo TO lector_demo;

    -- Retirar la concesión directa: la consulta dependerá ahora del rol.
    REVOKE SELECT ON TABLE public.permisos_demo FROM lector_demo;
    ```

    Desde la conexión **Pruebas - lector**, ejecuta:

    ```sql
    SELECT * FROM public.permisos_demo;
    ```

    La consulta sigue funcionando: `lector_demo` recibe `SELECT` por pertenecer a `consulta_demo`, aunque ya no lo tenga concedido directamente.

    Ahora, como **alumno**, retira la pertenencia:

    ```sql
    REVOKE consulta_demo FROM lector_demo;
    ```

    Repite la consulta como **lector_demo**: debe fallar por falta de permisos. Si queda una transacción fallida, pulsa **Rollback**. El usuario sigue existiendo y puede conectarse, pero ya no recibe el permiso del grupo.

    Por último, como **alumno**, vuelve a incorporarlo:

    ```sql
    GRANT consulta_demo TO lector_demo;
    ```

    Comprueba que la consulta vuelve a funcionar desde **Pruebas - lector**.

Si más adelante creamos otro usuario que necesite consultar esta tabla, bastará con incorporarlo a `consulta_demo`. No tendremos que repetir la concesión de `SELECT` para cada usuario.

## Limpiar los objetos de la práctica

!!! example practica "Pruébalo: Eliminar la tabla y el usuario de demostración"

    Cierra los editores y desconecta **Pruebas - lector**. Si había cambios pendientes, revierte la transacción. Desde **pruebas con el usuario alumno**, ejecuta:

    ```sql
    -- Eliminar la tabla y los permisos asociados a ella.
    DROP TABLE public.permisos_demo;

    -- Retirar las otras concesiones explícitas de la práctica.
    REVOKE USAGE ON SCHEMA public FROM lector_demo;
    REVOKE CONNECT ON DATABASE pruebas FROM lector_demo;

    -- Retirar la pertenencia al grupo.
    REVOKE consulta_demo FROM lector_demo;

    -- Eliminar el rol y el usuario una vez resueltas sus dependencias.
    DROP ROLE consulta_demo;
    DROP USER lector_demo;
    ```

    Después puedes eliminar de DBeaver la conexión **Pruebas - lector**, que ya no podrá utilizarse. Conserva tu conexión habitual con `alumno`.

!!! question "Autoevaluación"

    Un usuario puede conectarse a `pruebas`, pero recibe un error al consultar `permisos_demo`. ¿Es suficiente tener `CONNECT`? ¿Qué otros permisos necesita?

    ??? success "Ver solución"

        No. Necesita `USAGE` sobre el esquema que contiene la tabla y `SELECT` sobre la tabla. `CONNECT` permite conectarse a la base de datos, pero no concede por sí solo acceso a sus tablas.

!!! question "Autoevaluación: permisos directos y roles"

    Si retiramos a `lector_demo` del rol `consulta_demo`, ¿se elimina el usuario? ¿Podría seguir consultando la tabla si también tuviera `SELECT` concedido directamente?

    ??? success "Ver solución"

        El usuario no se elimina: solo pierde la pertenencia al rol y los permisos que recibía por esa vía. Si conserva una concesión directa de `SELECT`, puede seguir consultando la tabla. Para retirar un acceso hay que revisar todas las vías por las que lo obtiene.

Consulta también la documentación sobre [pertenencia a roles](https://www.postgresql.org/docs/17/role-membership.html).

Consulta la documentación de PostgreSQL 17 sobre [usuarios y roles](https://www.postgresql.org/docs/17/sql-createrole.html) y [concesión de privilegios](https://www.postgresql.org/docs/17/sql-grant.html).

Continúa con la [práctica guiada de Moviles](3_crear_moviles.md) y después con la [práctica de Juegos](4_crear_juegos.md).
