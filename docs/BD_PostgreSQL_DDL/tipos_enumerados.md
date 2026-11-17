---
hide:
  - toc
---

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
