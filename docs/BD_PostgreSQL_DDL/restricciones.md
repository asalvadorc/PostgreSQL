---
hide:
  - toc
---

# Restricciones

Las restricciones definen las reglas que deben cumplir los datos de una tabla. En `CREATE TABLE` podemos declararlas sobre una columna o sobre varias columnas. Las claves ajenas permiten además mantener la coherencia entre tablas y representar la participación obligatoria en una relación.

#### Restricciones de una columna

Las restricciones de columna establecen las reglas que debe cumplir un campo: exigir un valor, evitar duplicados, identificar una fila o referenciar otra tabla. Se escriben después del tipo de dato y pueden recibir un nombre mediante `CONSTRAINT`.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>[ CONSTRAINT nombre_restriccion ]</code><br/><code>{ NOT NULL</code><br/><code>| UNIQUE</code><br/><code>| PRIMARY KEY</code><br/><code>| CHECK (condicion)</code><br/><code>| REFERENCES [esquema.]tabla_destino (columna_destino)</code><br/><code>    [ ON DELETE accion ]</code><br/><code>    [ ON UPDATE accion ]</code><br/><code>}</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    - `CONSTRAINT`: asigna un nombre a la restricción.
    - `REFERENCES`: indica la clave referenciada.
    - `ON DELETE / ON UPDATE`: acción al borrar o actualizar la fila referenciada.


- **PRIMARY KEY**: identifica la fila, sin duplicados ni nulos.
- **NOT NULL**: exige un valor.
- **UNIQUE**: impide duplicados; en su comportamiento normal permite varios nulos.
- **CHECK**: exige que una expresión no sea falsa. Si el resultado es desconocido por un NULL, la fila puede aceptarse; añade `NOT NULL` si el dato es obligatorio.
- **REFERENCES**: exige que el valor no nulo exista en una clave referenciada.

#### Restricciones de varias columnas

Las restricciones de tabla permiten definir claves que abarcan varias columnas y condiciones que relacionan distintos campos. Se incluyen dentro de `CREATE TABLE`, separadas de las definiciones de columna mediante comas.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>[ CONSTRAINT nombre_restriccion ]</code><br/><code>{ PRIMARY KEY (columna [, ...])</code><br/><code>| UNIQUE (columna [, ...])</code><br/><code>| CHECK (condicion)</code><br/><code>| FOREIGN KEY (columna [, ...])</code><br/><code>    REFERENCES [esquema.]tabla_destino (columna_destino [, ...])</code><br/><code>    [ ON DELETE accion ]</code><br/><code>    [ ON UPDATE accion ]</code><br/><code>}</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    - `CONSTRAINT`: asigna un nombre a la restricción.
    - `REFERENCES`: indica la clave referenciada.
    - `ON DELETE / ON UPDATE`: acción al borrar o actualizar la fila referenciada.


En una FK compuesta, el número y los tipos de las columnas deben ser compatibles con los de la clave referenciada.

!!! example practica "Pruébalo: Definir una clave compuesta"

    Crea la tabla y revisa que su clave primaria contiene las dos columnas: `id_compra` y `num_linea`.

    ```sql
    CREATE TABLE lineas_demo (
        id_compra INTEGER,
        num_linea INTEGER,
        cantidad INTEGER NOT NULL CHECK (cantidad > 0), -- Restricciones de columna: NOT NULL y CHECK
        precio_unitario NUMERIC(10,2),
        descuento_linea NUMERIC(5,2),
        PRIMARY KEY (id_compra, num_linea), -- Restricción de tabla: PRIMARY KEY compuesta
        CONSTRAINT ck_demo_descuento
            CHECK (descuento_linea BETWEEN 0 AND 100) -- Restricción de tabla: CHECK
    );
    ```

La clave identifica cada línea dentro de su compra. Distintas compras pueden tener una línea número 1. La combinación completa no se repite.

#### Claves ajenas y participación

Las acciones de `ON DELETE` y `ON UPDATE` son:

| Acción | Efecto sobre las filas que contienen la FK |
| --- | --- |
| `NO ACTION` | Rechaza la operación si al comprobar la restricción quedan referencias sin destino. Es la acción predeterminada. |
| `RESTRICT` | Impide la operación si hay referencias; esta comprobación no se puede aplazar. |
| `CASCADE` | Propaga el borrado o la actualización de la clave referenciada. |
| `SET NULL` | Asigna NULL a la referencia; requiere que las columnas afectadas admitan nulos. |
| `SET DEFAULT` | Aplica su valor por defecto, que debe seguir cumpliendo la FK. |

En las tablas que acabamos de crear en `pruebas`, `productos_demo.id_categoria` referencia a `categorias_demo.id_categoria`. Como admite nulos, un producto puede quedarse sin categoría: la clave ajena por sí sola no obliga a rellenarla. Si añadiéramos **NOT NULL** a esa columna, todo producto tendría que pertenecer a una categoría existente; así representaríamos su **participación total** en la relación.

En este ejemplo, se aplica `NO ACTION` por defecto: no podemos borrar una categoría mientras haya productos que la referencien. Si hubiéramos definido la FK con `ON DELETE CASCADE`, borrar la categoría también eliminaría sus productos. La acción debe elegirse según el comportamiento que necesitemos.

