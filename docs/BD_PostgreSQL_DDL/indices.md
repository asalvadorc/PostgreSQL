---
hide:
  - toc
---

# Índices

Un índice puede facilitar búsquedas y ordenaciones, a costa de espacio y trabajo adicional al modificar datos. PostgreSQL ya crea índices para PK y UNIQUE; no crea automáticamente uno para cada FK.

`CREATE INDEX` crea un índice sobre una o varias columnas; `ALTER INDEX` permite renombrarlo y `DROP INDEX` lo elimina sin borrar la tabla ni sus datos.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE [ UNIQUE ] INDEX [ IF NOT EXISTS ] nombre_indice</code><br/><code>    ON [esquema.]tabla (columna [ ASC | DESC ] [, ...]);</code></td></tr>
    <tr><td><code>ALTER INDEX [esquema.]nombre_indice RENAME TO nuevo_nombre;</code></td></tr>
    <tr><td><code>DROP INDEX [ IF EXISTS ] [esquema.]nombre [, ...]</code><br/><code>    [ CASCADE | RESTRICT ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE [`**

    - `UNIQUE`: impide duplicados.
    - `IF NOT EXISTS`: evita el error si el índice ya existe.
    - `ASC / DESC`: orden ascendente (por defecto) o descendente.

    **`ALTER INDEX`**

    - `RENAME TO`: cambia el nombre del índice.

    **`DROP INDEX`**

    - `IF EXISTS`: evita el error si no existe.
    - `RESTRICT`: impide borrar si hay dependencias (por defecto).
    - `CASCADE`: elimina también objetos dependientes.


!!! example practica "Pruébalo: Crear y eliminar índices"

    Utiliza `productos_demo`, que has conservado en `pruebas`. Ejecuta primero los CREATE INDEX y comprueba los índices en DBeaver. Después ejecuta los DROP INDEX; la tabla seguirá existiendo.

    ```sql
    CREATE INDEX i_demo_productos_nombre ON productos_demo (nombre);
    CREATE INDEX i_demo_productos_categoria_precio
        ON productos_demo (id_categoria ASC, precio DESC);

    DROP INDEX i_demo_productos_nombre;
    DROP INDEX i_demo_productos_categoria_precio;
    ```

El optimizador decide si utiliza un índice. Con tablas pequeñas puede preferir un recorrido completo.
