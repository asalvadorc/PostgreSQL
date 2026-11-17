---
hide:
  - toc
---

# DROP TABLE

`DROP TABLE` elimina una tabla completa, incluida su estructura y todos sus datos. Las opciones `RESTRICT` y `CASCADE` determinan qué ocurre si otros objetos dependen de ella.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>DROP TABLE [ IF EXISTS ] [esquema.]nombre [, ...]</code><br/><code>    [ CASCADE | RESTRICT ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    - `IF EXISTS`: evita el error si no existe.
    - `RESTRICT`: impide borrar si hay dependencias (por defecto).
    - `CASCADE`: elimina también objetos dependientes.


- `IF EXISTS`: si la tabla no existe, emite un aviso en lugar de un error.
- `RESTRICT`: comportamiento predeterminado; rechaza el borrado si hay objetos dependientes.
- `CASCADE`: elimina también objetos dependientes, como vistas o restricciones de clave ajena de otras tablas; no significa necesariamente borrar esas otras tablas.
- `[, ...]`: permite indicar varias tablas, separadas por comas.

!!! example practica "Pruébalo: Eliminar una tabla que ya no necesitamos"

    Crea una tabla auxiliar vacía y elimínala. Conserva `categorias` y `productos`, que utilizaremos después en los ejemplos de índices y vistas.

    ```sql
    CREATE TABLE tabla_borrado (codigo INTEGER);
    DROP TABLE tabla_borrado;
    ```

    Actualiza el navegador de DBeaver y comprueba que `tabla_borrado` ha desaparecido.

Borra primero las tablas dependientes. `IF EXISTS` evita el error de objeto inexistente, pero no protege datos. `DROP TABLE ... CASCADE` elimina también objetos dependientes; no es equivalente a `ON DELETE CASCADE`, que actúa sobre filas. Usa `pruebas` para estos ejemplos.
