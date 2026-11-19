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

    Ejecuta las sentencias una a una y observa los cambios en las columnas y restricciones de `productos`.

    ```sql
    ALTER TABLE productos ADD COLUMN activo BOOLEAN DEFAULT TRUE;
    ALTER TABLE productos ALTER COLUMN descripcion TYPE VARCHAR(250);
    ALTER TABLE productos ALTER COLUMN stock SET DEFAULT 1;
    ALTER TABLE productos ALTER COLUMN stock SET NOT NULL; -- Restricción de columna: NOT NULL
    ALTER TABLE productos ADD CONSTRAINT ck_productos_stock CHECK (stock >= 0); -- Restricción de tabla: CHECK
    ALTER TABLE productos RENAME COLUMN activo TO disponible;
    ALTER TABLE productos DROP COLUMN disponible;
    ALTER TABLE productos DROP CONSTRAINT ck_productos_stock; -- Elimina la restricción de tabla CHECK
    ```


<a id="ejercicios-juegos"></a>

## Ejercicios: Completar la estructura

Continúa con las ocho tablas ya creadas. Ahora modificarás su estructura con `ALTER TABLE`, sin borrar las tablas ni repetir los CREATE.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 9: Añadir alias</span></span> {#ejercicio-9-anadir-alias}

!!! ejercicio "Juegos"

    Añade a `vendedores` una columna `alias VARCHAR(40) NOT NULL UNIQUE`. La tabla todavía está vacía; explica qué habría que preparar si ya tuviera filas.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 10: Eliminar alias</span></span> {#ejercicio-10-eliminar-alias}

!!! ejercicio "Juegos"

    Elimina la columna `alias`.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 11: Añadir la PK de categorias</span></span> {#ejercicio-11-anadir-la-pk-de-categorias}

!!! ejercicio "Juegos"

    Añade mediante `ALTER TABLE` la clave primaria de `categorias`, que debe estar formada por `id_categoria`.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 12: Completar productos y la relación reflexiva</span></span> {#ejercicio-12-completar-productos-y-la-relacion-reflexiva}

!!! ejercicio "Juegos"

    En `productos`, añade la clave primaria sobre `id_producto` y la clave ajena `id_categoria` hacia `categorias(id_categoria)`. Completa también la relación reflexiva pendiente: `vendedores.id_jefe` debe referenciar a `vendedores.id_vendedor` y admitir nulos para los vendedores sin jefe.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 13: Añadir las FK de lineas_compra</span></span> {#ejercicio-13-anadir-las-fk-de-lineas_compra}

!!! ejercicio "Juegos"

    Añade las FK de `lineas_compra`: hacia `compras` con `ON DELETE CASCADE`, y hacia `productos` con `NO ACTION`. Revisa que hay ocho PK y nueve FK.

**Antes de continuar:** Comprueba que hay ocho PK y nueve FK. La columna temporal `alias` debe haber desaparecido. Conserva todas las tablas vacías para los ejercicios de índices y vistas.

Al finalizar el ejercicio 13, actualiza la conexión **Juegos** y despliega las tablas y sus columnas. Esta imagen orientativa muestra la estructura completa, con las claves primarias y ajenas ya incorporadas. La PK de `lineas_compra` está formada por `id_compra` y `num_linea`:

![Árbol completo de Juegos después del ejercicio 13, con las ocho tablas desplegadas, sus columnas y las claves primarias y ajenas](../juegos-arbol-ejercicio-13.png){ width="800" }

