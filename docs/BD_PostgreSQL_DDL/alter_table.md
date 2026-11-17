---
hide:
  - toc
---

# ALTER TABLE

`ALTER TABLE` modifica la estructura de una tabla existente: permite añadir, eliminar o modificar columnas y restricciones.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>ALTER TABLE [esquema.]tabla</code><br/><code>    { ADD | DROP | ALTER }</code><br/><code>    { COLUMN columna | CONSTRAINT restriccion_de_tabla } ...;</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    - `ADD`: añade una columna o una restricción.
    - `DROP`: elimina una columna o una restricción.
    - `ALTER`: modifica una propiedad de una columna o, en los casos permitidos, de una restricción.
    - `COLUMN`: actúa sobre una columna.
    - `CONSTRAINT`: actúa sobre una restricción de tabla.
    - `...`: representa los detalles que necesita cada operación. Es un esquema general; no todas las combinaciones son válidas.

Antes de añadir una restricción, los datos existentes deben cumplirla. Para cambiar la definición de un `CHECK` o una clave ajena, se elimina la restricción y se crea de nuevo.

!!! example practica "Pruébalo: Modificar una tabla"

    Ejecuta las sentencias una a una y observa los cambios en las columnas y restricciones de `productos_demo`.

    ```sql
    ALTER TABLE productos_demo ADD COLUMN activo BOOLEAN DEFAULT TRUE;
    ALTER TABLE productos_demo ALTER COLUMN nombre TYPE VARCHAR(250);
    ALTER TABLE productos_demo ALTER COLUMN stock SET DEFAULT 1;
    ALTER TABLE productos_demo ALTER COLUMN stock SET NOT NULL; -- Restricción de columna: NOT NULL
    ALTER TABLE productos_demo ADD CONSTRAINT ck_demo_stock CHECK (stock >= 0); -- Restricción de tabla: CHECK
    ALTER TABLE productos_demo RENAME COLUMN activo TO disponible;
    ALTER TABLE productos_demo DROP COLUMN disponible;
    ALTER TABLE productos_demo DROP CONSTRAINT ck_demo_stock; -- Elimina la restricción de tabla CHECK
    ```

