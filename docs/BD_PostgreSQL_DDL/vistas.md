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

    En la misma base `pruebas`, crea una vista que muestre las filas de `productos` junto con el nombre de la fila relacionada de `categorias`. Utiliza las tablas que has conservado de los ejemplos anteriores.

    ```sql
    CREATE VIEW vista_tablas AS
    SELECT t2.codigo, t2.num_variante, t2.descripcion,
           t1.nombre AS nombre_relacionado, t2.precio, t2.stock
    FROM productos AS t2
    LEFT JOIN categorias AS t1 ON t1.codigo = t2.codigo_categoria;

    SELECT * FROM vista_tablas ORDER BY codigo, num_variante;
    ```

La consulta estará vacía porque todavía no hemos insertado datos: eso se trabajará en DML. Aun así, puedes comprobar que la vista aparece en **Views** y revisar sus columnas. Cuando las tablas tengan datos, la vista mostrará sus valores actuales; no guarda una copia independiente.

!!! example practica "Pruébalo: Eliminar la vista"

    Elimina la vista y comprueba que desaparece de **Views**. Las dos tablas se conservan.

    ```sql
    DROP VIEW vista_tablas;
    ```

!!! example practica "Pruébalo: Limpiar las tablas utilizadas"

    Una vez terminados los ejemplos de índices y vistas, estas dos tablas ya no se necesitan. Elimina primero la tabla que contiene la clave ajena y después la tabla referenciada.

    ```sql
    DROP TABLE productos;
    DROP TABLE categorias;
    ```

<a id="ejercicios-juegos"></a>

## Ejercicios: Crear vistas

Conserva las tablas y los índices anteriores. Las vistas se crean con las tablas vacías; sus resultados se comprobarán cuando carguemos los datos en DML. La construcción de las consultas se desarrollará en DQL.

### Ejercicio 16: Vista resumen_compras

!!! ejercicio "Juegos"

    Crea la vista `resumen_compras` con las bases sin descuentos, con descuento de líneas, con descuento general y el total con IVA. Calcula primero `SUM(cantidad * precio_unitario)`. Para el descuento de líneas, suma `cantidad * precio_unitario * (1 - COALESCE(descuento_linea, 0) / 100.0)`; después multiplica por `(1 - COALESCE(descuento, 0) / 100.0)` y, al final, por `(1 + COALESCE(iva, 0) / 100.0)`. La columna del importe final debe llamarse `total`.

### Ejercicio 17: Vista resumen_vendedores

!!! ejercicio "Juegos"

    Crea `resumen_vendedores`: código y nombre del vendedor, total de unidades vendidas y base de sus compras tras los descuentos. Evita duplicar el importe de una compra al reunirla con sus líneas.

### Ejercicio 18: Vista resumen_categorias

!!! ejercicio "Juegos"

    Crea `resumen_categorias`: categoría, unidades vendidas e importe de líneas tras aplicar solo `descuento_linea`.

**Antes de continuar:** Comprueba que las tres vistas aparecen en DBeaver. No introduzcas datos de prueba en Juegos: sus tablas deben quedar vacías.

