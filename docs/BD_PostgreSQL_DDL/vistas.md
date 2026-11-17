---
hide:
  - toc
---

# Vistas

Una vista guarda una consulta, no una copia estática de sus filas. `CREATE VIEW` define la vista y `CREATE OR REPLACE VIEW` permite sustituir su consulta. `ALTER VIEW` puede cambiar su nombre y `DROP VIEW` elimina la vista sin borrar las tablas consultadas.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE [ OR REPLACE ] VIEW [esquema.]nombre_vista</code><br/><code>    [ (columna [, ...]) ]</code><br/><code>    AS consulta;</code></td></tr>
    <tr><td><code>ALTER VIEW [esquema.]nombre_vista RENAME TO nuevo_nombre;</code></td></tr>
    <tr><td><code>DROP VIEW [ IF EXISTS ] [esquema.]nombre [, ...]</code><br/><code>    [ CASCADE | RESTRICT ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE [`**

    - `OR REPLACE`: sustituye la consulta de una vista existente, manteniendo compatibles sus columnas.
    - Lista de columnas: permite asignar nombres a las columnas de salida.

    **`ALTER VIEW`**

    - `RENAME TO`: cambia el nombre de la vista.
    - Para cambiar la consulta se utiliza `CREATE OR REPLACE VIEW`.

    **`DROP VIEW`**

    - `IF EXISTS`: evita el error si no existe.
    - `RESTRICT`: impide borrar si hay dependencias (por defecto).
    - `CASCADE`: elimina también objetos dependientes.


`ALTER VIEW` **no cambia la consulta**: para eso se usa `CREATE OR REPLACE VIEW`. La lista de columnas existente debe conservar nombres, orden y tipos. Para cambiar tipos o eliminar columnas puede ser necesario borrar y recrear la vista, revisando antes sus dependencias.

!!! example practica "Pruébalo: Crear y consultar una vista"

    En la misma base `pruebas`, crea una vista que muestre los productos junto con la descripción de su categoría. Utiliza las tablas `productos_demo` y `categorias_demo` de los ejemplos anteriores.

    ```sql
    CREATE VIEW catalogo_demo AS
    SELECT p.id_producto, p.nombre, c.descripcion AS categoria,
           p.precio, p.stock
    FROM productos_demo AS p
    LEFT JOIN categorias_demo AS c ON c.id_categoria = p.id_categoria;

    SELECT * FROM catalogo_demo ORDER BY id_producto;
    ```

La consulta estará vacía porque todavía no hemos insertado datos: eso se trabajará en DML. Aun así, puedes comprobar que la vista aparece en **Views** y revisar sus columnas. Cuando las tablas tengan datos, la vista mostrará sus valores actuales; no guarda una copia independiente.

!!! example practica "Pruébalo: Eliminar la vista"

    Elimina la vista y comprueba que desaparece de **Views**. Las dos tablas se conservan.

    ```sql
    DROP VIEW catalogo_demo;
    ```

!!! example practica "Pruébalo: Limpiar las tablas utilizadas"

    Una vez terminados los ejemplos de índices y vistas, estas dos tablas ya no se necesitan. Elimina primero la tabla que contiene la clave ajena y después la tabla referenciada.

    ```sql
    DROP TABLE productos_demo;
    DROP TABLE categorias_demo;
    ```
