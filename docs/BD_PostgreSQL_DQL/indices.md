# Índices

En este bloque de DQL estudiaremos este objeto y su uso en las consultas. Sus sentencias de creación, modificación y eliminación siguen perteneciendo a **DDL**.

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


Para los ejemplos **Pruébalo**, utiliza `departamentos` y `empleados` de la conexión **Empresa**, creadas en [Restricciones de DDL](../BD_PostgreSQL_DDL/restricciones.md#restricciones-de-una-columna). Si no las conservas, repite sus CREATE TABLE antes de continuar. Estos ejemplos se realizan en el orden **índices → vistas**.

!!! example practica "Pruébalo: Crear y eliminar índices"

    Utiliza `empleados`, que has conservado en **empresa**. Ejecuta primero los CREATE INDEX y comprueba los índices en DBeaver. Después ejecuta los DROP INDEX; la tabla seguirá existiendo.

    ```sql
    CREATE INDEX i_empleados_nombre ON empleados (nombre);
    CREATE INDEX i_empleados_departamento_salario
        ON empleados (codigo_departamento ASC, salario DESC);

    DROP INDEX i_empleados_nombre;
    DROP INDEX i_empleados_departamento_salario;
    ```

El optimizador decide si utiliza un índice. Con tablas pequeñas puede preferir un recorrido completo.

<a id="ejercicios-juegos"></a>

## Ejercicios: Crear índices

Utiliza las tablas de Juegos que has completado en los ejercicios 1–13 de DDL. Añade las sentencias a `02_juegos.sql`.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 16: Índice por nombre de jugador</span></span> {#ejercicio-16-indice-por-nombre-de-jugador}

!!! ejercicio "Juegos"

    Crea `i_jugadores_nombre` sobre `jugadores(nombre)`.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 17: Índice de vendedores</span></span> {#ejercicio-17-indice-de-vendedores}

!!! ejercicio "Juegos"

    Crea `i_vendedores_cp_direccion` por `codigo_postal` ascendente y `direccion` descendente.

**Antes de continuar:** Actualiza el nodo de índices de cada tabla en DBeaver y comprueba sus columnas y su orden.

