---
hide:
  - toc
---

# Esquemas

Un **esquema** es un espacio dentro de una base de datos que organiza sus objetos, como tablas y vistas. En la configuración de estas prácticas, si no indicamos el esquema, se utiliza **`public` por defecto**: `CREATE TABLE productos_demo (...)` crea la misma tabla que `CREATE TABLE public.productos_demo (...)`.

La organización es **servidor → base de datos → esquema → tabla**. Por ejemplo, en nuestro servidor tenemos la base de datos `pruebas`, que contiene el esquema `public`, donde crearemos `productos_demo`.

La notación `[esquema.]nombre_tabla` indica que podemos escribir el esquema seguido de un punto o dejar solo el nombre de la tabla. En los ejemplos posteriores utilizaremos `public`, pero primero vamos a crear un esquema de demostración.

`CREATE SCHEMA` crea un espacio para organizar objetos dentro de la base de datos a la que estamos conectados. Crear un esquema no crea otra base de datos ni cambia el esquema predeterminado del editor.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE SCHEMA [ IF NOT EXISTS ] nombre_esquema</code><br/><code>    [ AUTHORIZATION nombre_usuario ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    - `IF NOT EXISTS`: evita el error si el esquema ya existe.
    - `AUTHORIZATION`: indica su propietario; si se omite, será el usuario que ejecuta la sentencia.


!!! example practica "Pruébalo: Crear un esquema"

    Desde la conexión a **pruebas**, con el usuario **alumno**, ejecuta:

    ```sql
    -- Crear un esquema cuyo propietario será el usuario alumno.
    CREATE SCHEMA laboratorio;
    ```

    Actualiza el nodo **Esquemas / Schemas** de `pruebas` en DBeaver. Debe aparecer `laboratorio` junto a `public`. Si no lo ves, revisa los filtros de esquemas de la conexión.

    Este esquema permitiría organizar tablas con nombres como `laboratorio.productos_demo`. Para crearlas dentro de él tendríamos que indicar el prefijo `laboratorio.`; crearlo no hace que las nuevas tablas dejen de utilizar `public` por defecto.

    Como todavía está vacío y no lo utilizaremos en los siguientes ejemplos, elimínalo:

    ```sql
    -- Eliminar el esquema de demostración, que no contiene objetos.
    DROP SCHEMA laboratorio;
    ```

    Actualiza de nuevo el nodo **Esquemas / Schemas** y comprueba que desaparece. `DROP SCHEMA` sin `CASCADE` solo permite eliminarlo si está vacío.
