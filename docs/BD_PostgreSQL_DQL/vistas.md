# Vistas

En este bloque de DQL estudiaremos este objeto y su uso en las consultas. Sus sentencias de creación, modificación y eliminación siguen perteneciendo a **DDL**.

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

Para los ejemplos **Pruébalo**, utiliza `departamentos` y `empleados` de la conexión **Empresa**, creadas en [Restricciones de DDL](../BD_PostgreSQL_DDL/restricciones.md#restricciones-de-una-columna). Si no las conservas, repite sus CREATE TABLE antes de continuar. Estos ejemplos se realizan en el orden **índices → vistas**.

!!! example practica "Pruébalo: Crear y consultar una vista"

    En **empresa**, crea una vista que muestre cada empleado junto al nombre de su departamento. Utiliza las tablas `empleados` y `departamentos` que has conservado.

    ```sql
    CREATE VIEW vista_empleados AS
    SELECT e.codigo, e.nombre, e.fecha_nacimiento, e.salario,
           d.nombre AS departamento
    FROM empleados AS e
    LEFT JOIN departamentos AS d ON d.codigo = e.codigo_departamento;

    SELECT * FROM vista_empleados ORDER BY codigo;
    ```

La consulta estará vacía porque todavía no hemos insertado datos: eso se trabajará en DML. Comprueba que la vista aparece en **Views** y revisa sus columnas. Cuando las tablas tengan datos, mostrará sus valores actuales, sin guardar una copia independiente.

!!! example practica "Pruébalo: Eliminar la vista"

    Elimina la vista y comprueba que desaparece de **Views**. Las dos tablas se conservan.

    ```sql
    DROP VIEW vista_empleados;
    ```

Conserva las cinco tablas de Empresa creadas en DDL. Eliminar la vista no elimina sus tablas ni sus relaciones.

<a id="ejercicios-juegos"></a>

## Ejercicios: Crear vistas

Utiliza las tablas de Juegos construidas en DDL y cargadas en DML. Crea las vistas y consulta sus resultados con los datos disponibles. Conserva los índices de los ejercicios 16–17.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 18: Vista resumen_compras</span></span> {#ejercicio-18-vista-resumen_compras}

!!! ejercicio "Juegos"

    Crea la vista `resumen_compras` con las bases sin descuentos, con descuento de líneas, con descuento general y el total con IVA. Calcula primero `SUM(cantidad * precio_unitario)`. Para el descuento de líneas, suma `cantidad * precio_unitario * (1 - COALESCE(descuento_linea, 0) / 100.0)`; después multiplica por `(1 - COALESCE(descuento, 0) / 100.0)` y, al final, por `(1 + COALESCE(iva, 0) / 100.0)`. La columna del importe final debe llamarse `total`.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 19: Vista resumen_vendedores</span></span> {#ejercicio-19-vista-resumen_vendedores}

!!! ejercicio "Juegos"

    Crea `resumen_vendedores`: código y nombre del vendedor, total de unidades vendidas y base de sus compras tras los descuentos. Evita duplicar el importe de una compra al reunirla con sus líneas.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 20: Vista resumen_categorias</span></span> {#ejercicio-20-vista-resumen_categorias}

!!! ejercicio "Juegos"

    Crea `resumen_categorias`: categoría, unidades vendidas e importe de líneas tras aplicar solo `descuento_linea`.

**Antes de continuar:** Comprueba que las tres vistas aparecen en DBeaver y consulta sus resultados. Los datos deben proceder de la carga de DML; no los vuelvas a insertar.

