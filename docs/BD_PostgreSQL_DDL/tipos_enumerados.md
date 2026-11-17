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

<a id="ejercicios-juegos"></a>

## Ejercicios: Combinar generación de códigos y validaciones

Realiza estos ejercicios después de estudiar secuencias, dominios y tipos enumerados. Trabaja en **pruebas** y añade las sentencias a `03_objetos_pruebas.sql`.

### Ejercicio 21: Generar códigos con SERIAL

!!! ejercicio "Pruebas"

    En `pruebas`, crea `compras_demo` con `id_compra SERIAL PRIMARY KEY`, `fecha DATE`, `iva NUMERIC(5,2)` y `descuento NUMERIC(5,2)`. El IVA debe ser obligatorio y solo admitir 10 o 21; el descuento debe estar entre 0 y menos de 50 cuando se informe. Inserta una fila válida omitiendo el código y comprueba, por separado, una inserción rechazada por IVA y otra por descuento. Elimina la tabla al terminar y compara `SERIAL` con la secuencia definida manualmente.

### Ejercicio 22: Combinar dominio, tipo y restricciones

!!! ejercicio "Pruebas"

    En `pruebas`, crea un dominio `codigo_barras_demo` basado en `VARCHAR(13)` que solo admita textos formados por exactamente 13 dígitos, y un tipo enumerado `estado_producto_demo` con los valores `Disponible`, `Agotado` y `En espera`. Utilízalos en `productos_demo`, junto con código, nombre, precio, stock y stock mínimo. Exige valores no negativos para precio, stock y stock mínimo, y añade como **restricción de tabla con nombre** `stock >= stock_minimo`. Comprueba una fila válida y varias rechazadas, ejecutándolas por separado. El control de formato no verifica el dígito de control del código de barras ni indica el país de fabricación. Explica por qué en un inventario real puede ser útil permitir stock bajo mínimo. Elimina primero la tabla y después el tipo y el dominio.

**Antes de continuar:** Elimina los objetos de demostración en el orden adecuado, sin modificar la base de datos Juegos.

