# Tipos enumerados

Un tipo enumerado limita una columna a una lista de valores permitidos. `CREATE TYPE ... AS ENUM` define esa lista; `ALTER TYPE` permite añadir o renombrar valores, y `DROP TYPE` elimina el tipo cuando ya no se necesita.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE TYPE [esquema.]nombre AS ENUM ('valor1' [, ...]);</code></td></tr>
    <tr><td><code>ALTER TYPE [esquema.]nombre ADD VALUE 'nuevo_valor';</code><br/><br/><br/><code>ALTER TYPE [esquema.]nombre</code><br/><code>    RENAME VALUE 'valor_existente' TO 'nuevo_valor';</code></td></tr>
    <tr><td><code>DROP TYPE [ IF EXISTS ] [esquema.]nombre [, ...]</code><br/><code>    [ CASCADE | RESTRICT ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE TYPE`**

    - `AS ENUM`: lista de valores permitidos entre comillas simples.

    **`ALTER TYPE`**

    - `ADD VALUE`: añade un valor al final de la lista.
    - `RENAME VALUE`: cambia un valor existente.

    **`DROP TYPE`**

    - `IF EXISTS`: evita el error si no existe.
    - `RESTRICT`: impide borrar si hay dependencias (por defecto).
    - `CASCADE`: elimina también objetos dependientes.


No existe una operación directa para eliminar un único valor de un ENUM. Aquí utilizaremos los tipos enumerados para limitar los valores admitidos por una columna.

!!! example practica "Pruébalo: Probar un tipo enumerado"

    Crea el tipo y la tabla; revisa los valores permitidos y el valor por defecto antes de ejecutar los borrados.

    ```sql
    CREATE TYPE estado_producto_demo AS ENUM ('Disponible', 'Agotado', 'En espera');
    CREATE TABLE inventario_demo (
        id_producto SERIAL PRIMARY KEY,
        estado estado_producto_demo DEFAULT 'Disponible'
    );
    DROP TABLE inventario_demo;
    DROP TYPE estado_producto_demo;
    ```

Actualiza la conexión **Empresa** y despliega las tablas. Esta imagen orientativa muestra el estado al terminar el ejemplo:

![Empresa tras eliminar inventario_demo y su tipo enumerado: las cinco tablas originales se conservan](../img/empresa/07-empresa-completa.png){ width="800" }


<a id="ejercicios-juegos"></a>

## Ejercicios: Combinar dominios, tipos y restricciones

Realiza este ejercicio de ampliación después de estudiar CREATE TABLE, restricciones, dominios y tipos enumerados. Trabaja en **empresa** y añade las sentencias a `03_objetos_empresa.sql`.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 14: Combinar dominio, tipo y restricciones</span></span> {#ejercicio-14-combinar-dominio-tipo-y-restricciones}

!!! ejercicio "Empresa"

    Trabaja en la base de datos **`empresa`** y realiza estos pasos:

    1. **Crea el dominio `codigo_barras_demo`**, basado en `VARCHAR(13)`, para admitir únicamente textos formados por exactamente 13 dígitos.

    2. **Crea el tipo enumerado `estado_producto_demo`**, con los valores `Disponible`, `Agotado` y `En espera`.

    3. **Crea la tabla `productos_demo`** con código, nombre, precio, stock, stock mínimo, código de barras y estado. Utiliza el dominio y el tipo enumerado que acabas de definir.

    4. **Añade las validaciones**: precio, stock y stock mínimo deben ser no negativos. Define además `stock >= stock_minimo` como **restricción de tabla con nombre**.

    5. **Comprueba las restricciones** insertando una fila válida y varias que deban rechazarse. Ejecuta las inserciones por separado.

    6. **Reflexiona**: explica por qué en un inventario real puede ser útil permitir que el stock esté por debajo del mínimo.

    7. **Elimina los objetos de demostración**: primero la tabla y después el tipo enumerado y el dominio.

    El dominio solo comprueba el formato de 13 dígitos: no verifica el dígito de control del código de barras ni indica el país de fabricación.

**Antes de continuar:** Elimina los objetos de demostración en el orden adecuado, sin modificar la base de datos Juegos.

