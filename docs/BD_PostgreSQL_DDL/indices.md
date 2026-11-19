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

    Utiliza `productos`, que has conservado en `pruebas`. Ejecuta primero los CREATE INDEX y comprueba los índices en DBeaver. Después ejecuta los DROP INDEX; la tabla seguirá existiendo.

    ```sql
    CREATE INDEX i_productos_descripcion ON productos (descripcion);
    CREATE INDEX i_productos_referencia_precio
        ON productos (codigo_categoria ASC, precio DESC);

    DROP INDEX i_productos_descripcion;
    DROP INDEX i_productos_referencia_precio;
    ```

El optimizador decide si utiliza un índice. Con tablas pequeñas puede preferir un recorrido completo.

<a id="ejercicios-juegos"></a>

## Ejercicios: Crear índices

Utiliza las tablas de Juegos que has completado en los ejercicios 1–13. Añade las sentencias a `02_juegos.sql`.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 14: Índice por nombre de jugador</span></span> {#ejercicio-14-indice-por-nombre-de-jugador}

!!! ejercicio "Juegos"

    Crea `i_jugadores_nombre` sobre `jugadores(nombre)`.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 15: Índice de vendedores</span></span> {#ejercicio-15-indice-de-vendedores}

!!! ejercicio "Juegos"

    Crea `i_vendedores_cp_direccion` por `codigo_postal` ascendente y `direccion` descendente.

**Antes de continuar:** Actualiza el nodo de índices de cada tabla en DBeaver y comprueba sus columnas y su orden.

