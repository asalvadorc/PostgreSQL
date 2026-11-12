# 2. DDL: definir la estructura

**DDL** (*Data Definition Language*) permite crear, modificar y eliminar bases de datos, tablas, restricciones y otros objetos. `CREATE` crea, `ALTER` modifica y `DROP` elimina. 

!!! warning "Antes de empezar: conecta a pruebas y ejecuta los ejemplos"
    Abre un editor SQL desde la conexión **Pruebas** de DBeaver. Comprueba que estás en la base correcta ejecutando:

    ```sql
    SELECT current_database();
    ```

    El resultado debe ser **pruebas**. **No te limites a leer los ejemplos: escribe y ejecuta cada sentencia**, observa el resultado y revisa los cambios en las tablas. Todos los ejemplos de este apartado se realizan en **pruebas**, siguiendo el orden en que aparecen.

**Cómo leer los bloques de sintaxis**

Los bloques de **sintaxis** sirven como referencia: sustituye los nombres genéricos y elige las opciones que necesites. No se ejecutan literalmente.

| Notación | Significado |
| --- | --- |
| `[ ... ]` | Parte opcional. |
| `{ opcion1 \| opcion2 }` | Debes elegir una de las alternativas. |
| `[, ...]` | Se pueden repetir elementos separados por comas. |
| `[esquema.]nombre` | Puedes indicar el esquema; por ejemplo, `public.productos_demo`. |

Los recuadros **Pruébalo** contienen las sentencias concretas que sí debes ejecutar, en el orden indicado.

## 2.1 Tipos de datos

Al crear una tabla debemos indicar **qué tipo de dato almacenará cada columna**. El tipo determina qué valores admite, cómo se representan y qué operaciones podemos realizar con ellos. Por ejemplo, un nombre necesita un tipo de texto, una cantidad un tipo entero y una fecha de compra un tipo de fecha.

Elegir el tipo adecuado ayuda a mantener la coherencia de los datos. En nuestras bases utilizaremos principalmente texto, números, fechas y valores lógicos. Para los precios emplearemos números decimales exactos; los códigos postales, en cambio, se guardarán como texto para conservar posibles ceros iniciales.

La siguiente tabla resume los tipos de PostgreSQL que utilizaremos en las prácticas:

| Tipo | Uso en nuestras bases |
| --- | --- |
| INTEGER | Códigos que referencian otras tablas, cantidades y stock. |
| SERIAL | Abreviatura de una columna entera con una secuencia y un valor por defecto. No añade por sí solo una PK. |
| VARCHAR(n) | Texto con longitud máxima: nombres, modelos y direcciones. |
| VARCHAR o TEXT | Texto sin el límite `n` declarado. En PostgreSQL, omitir `n` **no** establece un límite de 255. |
| DECIMAL(10,2) o NUMERIC(10,2) | Valores exactos con hasta diez cifras, dos decimales: precios. |
| DATE | Fechas sin hora. Escribe literales como `DATE '2024-03-01'`. |
| TIMESTAMP | Fecha y hora sin zona horaria. |
| BOOLEAN | Valores TRUE, FALSE o NULL. |

Consulta los [tipos de PostgreSQL 17](https://www.postgresql.org/docs/17/datatype.html).

## 2.2 Tablas

### CREATE TABLE

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Crear</td><td><code>CREATE TABLE [ IF NOT EXISTS ] [esquema.]nombre_tabla (</code><br><code>    columna tipo_dato [ DEFAULT expresion ] [ restricciones ]</code><br><code>    [, ...]</code><br><code>    [, restricciones_de_tabla ... ]</code><br><code>);</code></td><td><code>IF NOT EXISTS</code>: evita el error si ya existe; no modifica su estructura.<br><code>esquema.</code>: esquema de la tabla; usaremos <code>public</code>.<br><code>DEFAULT</code>: valor que se aplica si se omite la columna.<br><code>restricciones</code>: reglas como <code>NOT NULL</code>, <code>PRIMARY KEY</code>, <code>UNIQUE</code>, <code>CHECK</code> o <code>REFERENCES</code>.</td></tr>
    </tbody></table>
    </div>

Las columnas se separan por comas. Usa identificadores sin espacios, acentos ni comillas.

!!! example practica "Pruébalo: Crear las primeras tablas"

    Ejecuta las sentencias en orden y comprueba que aparecen `categorias_demo` y `productos_demo` en el navegador de DBeaver.

    ```sql
    CREATE TABLE categorias_demo (
        id_categoria SERIAL PRIMARY KEY,
        descripcion VARCHAR(100) NOT NULL
    );

    CREATE TABLE productos_demo (
        id_producto SERIAL PRIMARY KEY,
        nombre VARCHAR(200) NOT NULL,
        precio NUMERIC(10,2),
        stock INTEGER DEFAULT 0,
        id_categoria INTEGER,
        CONSTRAINT ck_demo_precio CHECK (precio >= 0),
        CONSTRAINT fk_demo_categoria FOREIGN KEY (id_categoria)
            REFERENCES categorias_demo(id_categoria)
    );
    ```

#### Restricciones de una columna

Puedes nombrar cada restricción con `CONSTRAINT`. Las restricciones se escriben después del tipo de la columna:

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Definir</td><td><code>[ CONSTRAINT nombre_restriccion ]</code><br><code>{ NOT NULL</code><br><code>| UNIQUE</code><br><code>| PRIMARY KEY</code><br><code>| CHECK (condicion)</code><br><code>| REFERENCES [esquema.]tabla_destino (columna_destino)</code><br><code>    [ ON DELETE accion ]</code><br><code>    [ ON UPDATE accion ]</code><br><code>}</code></td><td><code>CONSTRAINT</code>: asigna un nombre a la restricción.<br><code>REFERENCES</code>: indica la clave referenciada.<br><code>ON DELETE / ON UPDATE</code>: acción al borrar o actualizar la fila referenciada.</td></tr>
    </tbody></table>
    </div>

- **PRIMARY KEY**: identifica la fila, sin duplicados ni nulos.
- **NOT NULL**: exige un valor.
- **UNIQUE**: impide duplicados; en su comportamiento normal permite varios nulos.
- **CHECK**: exige que una expresión no sea falsa. Si el resultado es desconocido por un NULL, la fila puede aceptarse; añade `NOT NULL` si el dato es obligatorio.
- **REFERENCES**: exige que el valor no nulo exista en una clave referenciada.

#### Restricciones de varias columnas

Las restricciones de tabla se separan de las columnas mediante comas:

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Definir</td><td><code>[ CONSTRAINT nombre_restriccion ]</code><br><code>{ PRIMARY KEY (columna [, ...])</code><br><code>| UNIQUE (columna [, ...])</code><br><code>| CHECK (condicion)</code><br><code>| FOREIGN KEY (columna [, ...])</code><br><code>    REFERENCES [esquema.]tabla_destino (columna_destino [, ...])</code><br><code>    [ ON DELETE accion ]</code><br><code>    [ ON UPDATE accion ]</code><br><code>}</code></td><td><code>CONSTRAINT</code>: asigna un nombre a la restricción.<br><code>REFERENCES</code>: indica la clave referenciada.<br><code>ON DELETE / ON UPDATE</code>: acción al borrar o actualizar la fila referenciada.</td></tr>
    </tbody></table>
    </div>

En una FK compuesta, el número y los tipos de las columnas deben ser compatibles con los de la clave referenciada.

!!! example practica "Pruébalo: Definir una clave compuesta"

    Crea la tabla y revisa que su clave primaria contiene las dos columnas: `id_compra` y `num_linea`.

    ```sql
    CREATE TABLE lineas_demo (
        id_compra INTEGER,
        num_linea INTEGER,
        cantidad INTEGER NOT NULL CHECK (cantidad > 0),
        precio_unitario NUMERIC(10,2),
        descuento_linea NUMERIC(5,2),
        PRIMARY KEY (id_compra, num_linea),
        CONSTRAINT ck_demo_descuento
            CHECK (descuento_linea BETWEEN 0 AND 100)
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

### ALTER TABLE

Sirve para cambiar columnas, restricciones y otras propiedades de una tabla existente.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Alterar</td><td><code>ALTER TABLE [esquema.]nombre_tabla</code><br><code>    accion [, ...];</code></td><td><code>accion</code>: cambio que se aplica a la tabla.<br>Se pueden separar varias acciones compatibles por comas.</td></tr>
    <tr><td>Columnas</td><td><code>ADD COLUMN columna tipo_dato [ restricciones ]</code><br><code>DROP COLUMN columna [ CASCADE | RESTRICT ]</code><br><code>ALTER COLUMN columna TYPE tipo_dato [ USING expresion ]</code><br><code>ALTER COLUMN columna SET DEFAULT expresion</code><br><code>ALTER COLUMN columna DROP DEFAULT</code><br><code>ALTER COLUMN columna SET NOT NULL</code><br><code>ALTER COLUMN columna DROP NOT NULL</code></td><td><code>ADD / DROP COLUMN</code>: añade o elimina una columna.<br><code>TYPE</code>: cambia el tipo; <code>USING</code> indica cómo convertir los valores.<br><code>SET / DROP DEFAULT</code>: establece o quita el valor por defecto.<br><code>SET / DROP NOT NULL</code>: exige un valor o permite nulos.</td></tr>
    <tr><td>Restricciones</td><td><code>ADD [ CONSTRAINT nombre_restriccion ] restriccion_de_tabla</code><br><code>DROP CONSTRAINT nombre_restriccion</code></td><td><code>ADD CONSTRAINT</code>: añade una restricción.<br><code>DROP CONSTRAINT</code>: elimina la restricción indicada.</td></tr>
    <tr><td>Renombrar</td><td><code>ALTER TABLE [esquema.]nombre_tabla</code><br><code>    RENAME COLUMN columna TO nuevo_nombre;</code><br><br><br><code>ALTER TABLE [esquema.]nombre_tabla</code><br><code>    RENAME TO nuevo_nombre;</code></td><td><code>RENAME COLUMN</code>: cambia el nombre de una columna.<br><code>RENAME TO</code>: cambia el nombre de la tabla. Son sentencias independientes.</td></tr>
    </tbody></table>
    </div>

`USING` indica cómo convertir los valores existentes al cambiar el tipo de una columna.

!!! example practica "Pruébalo: Modificar una tabla"

    Ejecuta las sentencias una a una y observa los cambios en las columnas y restricciones de `productos_demo`.

    ```sql
    ALTER TABLE productos_demo ADD COLUMN activo BOOLEAN DEFAULT TRUE;
    ALTER TABLE productos_demo ALTER COLUMN nombre TYPE VARCHAR(250);
    ALTER TABLE productos_demo ALTER COLUMN stock SET DEFAULT 1;
    ALTER TABLE productos_demo ALTER COLUMN stock SET NOT NULL;
    ALTER TABLE productos_demo ADD CONSTRAINT ck_demo_stock CHECK (stock >= 0);
    ALTER TABLE productos_demo RENAME COLUMN activo TO disponible;
    ALTER TABLE productos_demo DROP COLUMN disponible;
    ALTER TABLE productos_demo DROP CONSTRAINT ck_demo_stock;
    ```

Antes de añadir una restricción, los datos existentes deben cumplirla. `SET NOT NULL` falla si ya hay nulos. Para cambiar una FK, elimina su restricción y créala con el comportamiento nuevo.

### DROP TABLE

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Borrar</td><td><code>DROP TABLE [ IF EXISTS ] [esquema.]nombre [, ...]</code><br><code>    [ CASCADE | RESTRICT ];</code></td><td><code>IF EXISTS</code>: evita el error si no existe.<br><code>RESTRICT</code>: impide borrar si hay dependencias (por defecto).<br><code>CASCADE</code>: elimina también objetos dependientes.</td></tr>
    </tbody></table>
    </div>

- `IF EXISTS`: si la tabla no existe, emite un aviso en lugar de un error.
- `RESTRICT`: comportamiento predeterminado; rechaza el borrado si hay objetos dependientes.
- `CASCADE`: elimina también objetos dependientes, como vistas o restricciones de clave ajena de otras tablas; no significa necesariamente borrar esas otras tablas.
- `[, ...]`: permite indicar varias tablas, separadas por comas.

!!! example practica "Pruébalo: Eliminar una tabla que ya no necesitamos"

    Elimina únicamente `lineas_demo` y actualiza el navegador. Conserva `productos_demo` y `categorias_demo`: las utilizaremos después en los ejemplos de índices y vistas.

    ```sql
    DROP TABLE lineas_demo;
    ```

Borra primero las tablas dependientes. `IF EXISTS` evita el error de objeto inexistente, pero no protege datos. `DROP TABLE ... CASCADE` elimina también objetos dependientes; no es equivalente a `ON DELETE CASCADE`, que actúa sobre filas. Usa `pruebas` para estos ejemplos.

## 2.3 Índices

Un índice puede facilitar búsquedas y ordenaciones, a costa de espacio y trabajo adicional al modificar datos. PostgreSQL ya crea índices para PK y UNIQUE; no crea automáticamente uno para cada FK.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Crear</td><td><code>CREATE [ UNIQUE ] INDEX [ IF NOT EXISTS ] nombre_indice</code><br><code>    ON [esquema.]tabla (columna [ ASC | DESC ] [, ...]);</code></td><td><code>UNIQUE</code>: impide duplicados.<br><code>IF NOT EXISTS</code>: evita el error si el índice ya existe.<br><code>ASC / DESC</code>: orden ascendente (por defecto) o descendente.</td></tr>
    <tr><td>Alterar</td><td><code>ALTER INDEX [esquema.]nombre_indice RENAME TO nuevo_nombre;</code></td><td><code>RENAME TO</code>: cambia el nombre del índice.</td></tr>
    <tr><td>Borrar</td><td><code>DROP INDEX [ IF EXISTS ] [esquema.]nombre [, ...]</code><br><code>    [ CASCADE | RESTRICT ];</code></td><td><code>IF EXISTS</code>: evita el error si no existe.<br><code>RESTRICT</code>: impide borrar si hay dependencias (por defecto).<br><code>CASCADE</code>: elimina también objetos dependientes.</td></tr>
    </tbody></table>
    </div>

!!! example practica "Pruébalo: Crear y eliminar índices"

    Utiliza `productos_demo`, que has conservado en `pruebas`. Ejecuta primero los CREATE INDEX y comprueba los índices en DBeaver. Después ejecuta los DROP INDEX; la tabla seguirá existiendo.

    ```sql
    CREATE INDEX i_demo_productos_nombre ON productos_demo (nombre);
    CREATE INDEX i_demo_productos_categoria_precio
        ON productos_demo (id_categoria ASC, precio DESC);

    DROP INDEX i_demo_productos_nombre;
    DROP INDEX i_demo_productos_categoria_precio;
    ```

El optimizador decide si utiliza un índice. Con tablas pequeñas puede preferir un recorrido completo.

## 2.4 Vistas

Una vista guarda una consulta, no una copia estática de sus filas.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Crear</td><td><code>CREATE [ OR REPLACE ] VIEW [esquema.]nombre_vista</code><br><code>    [ (columna [, ...]) ]</code><br><code>    AS consulta;</code></td><td><code>OR REPLACE</code>: sustituye la consulta de una vista existente, manteniendo compatibles sus columnas.<br>Lista de columnas: permite asignar nombres a las columnas de salida.</td></tr>
    <tr><td>Alterar</td><td><code>ALTER VIEW [esquema.]nombre_vista RENAME TO nuevo_nombre;</code></td><td><code>RENAME TO</code>: cambia el nombre de la vista.<br>Para cambiar la consulta se utiliza <code>CREATE OR REPLACE VIEW</code>.</td></tr>
    <tr><td>Borrar</td><td><code>DROP VIEW [ IF EXISTS ] [esquema.]nombre [, ...]</code><br><code>    [ CASCADE | RESTRICT ];</code></td><td><code>IF EXISTS</code>: evita el error si no existe.<br><code>RESTRICT</code>: impide borrar si hay dependencias (por defecto).<br><code>CASCADE</code>: elimina también objetos dependientes.</td></tr>
    </tbody></table>
    </div>

`ALTER VIEW` **no cambia la consulta**: para eso se usa `CREATE OR REPLACE VIEW`. La lista de columnas existente debe conservar nombres, orden y tipos. Para cambiar tipos o eliminar columnas puede ser necesario borrar y recrear la vista, revisando antes sus dependencias.

!!! example practica "Pruébalo: Crear y consultar una vista"

    En la misma base `pruebas`, crea una vista que muestre los productos junto con la descripción de su categoría. Utiliza las tablas `productos_demo` y `categorias_demo` de los ejemplos anteriores.

    ```sql
    CREATE VIEW catalogo_demo AS
    SELECT p.id_producto, p.nombre, c.descripcion AS categoria,
           p.precio, p.stock
    FROM productos_demo AS p
    LEFT JOIN categorias_demo AS c ON c.id_categoria = p.id_categoria;

    SELECT * FROM catalogo_demo ORDER BY id_producto;
    ```

La consulta estará vacía porque todavía no hemos insertado datos: eso se trabajará en DML. Aun así, puedes comprobar que la vista aparece en **Views** y revisar sus columnas. Cuando las tablas tengan datos, la vista mostrará sus valores actuales; no guarda una copia independiente.

!!! example practica "Pruébalo: Eliminar la vista"

    Elimina la vista y comprueba que desaparece de **Views**. Las dos tablas se conservan.

    ```sql
    DROP VIEW catalogo_demo;
    ```

!!! example practica "Pruébalo: Limpiar las tablas utilizadas"

    Una vez terminados los ejemplos de índices y vistas, estas dos tablas ya no se necesitan. Elimina primero la tabla que contiene la clave ajena y después la tabla referenciada.

    ```sql
    DROP TABLE productos_demo;
    DROP TABLE categorias_demo;
    ```

## 2.5 Secuencias, dominios y tipos

#### Secuencias

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Crear</td><td><code>CREATE SEQUENCE [ IF NOT EXISTS ] [esquema.]nombre</code><br><code>    [ START WITH inicio ]</code><br><code>    [ INCREMENT BY incremento ]</code><br><code>    [ OWNED BY tabla.columna ];</code></td><td><code>START WITH</code>: primer valor; por defecto, 1 en una secuencia ascendente.<br><code>INCREMENT BY</code>: salto entre valores; por defecto, 1.<br><code>OWNED BY</code>: vincula la secuencia a una columna.</td></tr>
    <tr><td>Alterar</td><td><code>ALTER SEQUENCE [esquema.]nombre</code><br><code>    RESTART WITH valor;</code><br><br><br><code>ALTER SEQUENCE [esquema.]nombre</code><br><code>    OWNED BY tabla.columna;</code></td><td><code>RESTART WITH</code>: establece el próximo valor.<br><code>OWNED BY</code>: vincula una secuencia existente a una columna.</td></tr>
    <tr><td>Borrar</td><td><code>DROP SEQUENCE [ IF EXISTS ] [esquema.]nombre [, ...]</code><br><code>    [ CASCADE | RESTRICT ];</code></td><td><code>IF EXISTS</code>: evita el error si no existe.<br><code>RESTRICT</code>: impide borrar si hay dependencias (por defecto).<br><code>CASCADE</code>: elimina también objetos dependientes.</td></tr>
    </tbody></table>
    </div>

`OWNED BY` vincula la secuencia al ciclo de vida de una columna; no la convierte en una clave primaria.

!!! example practica "Pruébalo: Probar una secuencia"

    Ejecuta las sentencias una a una. Observa los códigos generados antes de eliminar la tabla de demostración.

    ```sql
    CREATE SEQUENCE seq_jugadores_demo START WITH 1000 INCREMENT BY 5;
    CREATE TABLE jugadores_demo (
        id_jugador INTEGER DEFAULT nextval('seq_jugadores_demo') PRIMARY KEY,
        nombre VARCHAR(150)
    );
    ALTER SEQUENCE seq_jugadores_demo OWNED BY jugadores_demo.id_jugador;
    INSERT INTO jugadores_demo (nombre) VALUES ('Alex'), ('Noa');
    SELECT * FROM jugadores_demo;
    DROP TABLE jugadores_demo;
    ```

Se generan 1000 y 1005. Una secuencia puede tener huecos: no garantiza una numeración consecutiva. Al estar vinculada con `OWNED BY`, se elimina al borrar su columna. Otra opción es `INTEGER GENERATED BY DEFAULT AS IDENTITY`.

#### Dominios

Un dominio reutiliza un tipo y sus restricciones.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Crear</td><td><code>CREATE DOMAIN [esquema.]nombre AS tipo_dato</code><br><code>    [ DEFAULT expresion ]</code><br><code>    [ NOT NULL ]</code><br><code>    [ [ CONSTRAINT nombre_restriccion ] CHECK (condicion) ];</code></td><td><code>DEFAULT</code>: valor por defecto.<br><code>NOT NULL</code>: exige un valor.<br><code>CHECK</code>: comprueba una condición sobre <code>VALUE</code>.<br><code>CONSTRAINT</code>: asigna un nombre a la restricción.</td></tr>
    <tr><td>Alterar</td><td><code>ALTER DOMAIN [esquema.]nombre</code><br><code>    { SET DEFAULT expresion</code><br><code>    | DROP DEFAULT</code><br><code>    | SET NOT NULL</code><br><code>    | DROP NOT NULL</code><br><code>    | ADD [ CONSTRAINT nombre ] CHECK (condicion)</code><br><code>    | DROP CONSTRAINT nombre };</code></td><td><code>SET / DROP</code>: establece o elimina el valor por defecto o la obligatoriedad.<br><code>ADD / DROP CONSTRAINT</code>: añade o elimina restricciones.</td></tr>
    <tr><td>Borrar</td><td><code>DROP DOMAIN [ IF EXISTS ] [esquema.]nombre [, ...]</code><br><code>    [ CASCADE | RESTRICT ];</code></td><td><code>IF EXISTS</code>: evita el error si no existe.<br><code>RESTRICT</code>: impide borrar si hay dependencias (por defecto).<br><code>CASCADE</code>: elimina también objetos dependientes.</td></tr>
    </tbody></table>
    </div>

En los CHECK de un dominio, `VALUE` representa el valor que se está validando. Los cambios deben ser compatibles con los datos de las columnas que ya lo utilizan.

!!! example practica "Pruébalo: Probar un dominio"

    Crea el dominio y la tabla que lo utiliza. Revisa sus definiciones antes de eliminar los objetos.

    ```sql
    CREATE DOMAIN porcentaje_demo AS NUMERIC(5,2)
        CHECK (VALUE BETWEEN 0 AND 100);
    CREATE TABLE promociones_demo (
        id_promocion SERIAL PRIMARY KEY,
        descuento porcentaje_demo NOT NULL
    );
    DROP TABLE promociones_demo;
    DROP DOMAIN porcentaje_demo;
    ```

#### Tipos enumerados

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table">
    <thead><tr><th scope="col">Operación</th><th scope="col">Sintaxis</th><th scope="col">Opciones</th></tr></thead>
    <tbody>
    <tr><td>Crear</td><td><code>CREATE TYPE [esquema.]nombre AS ENUM (&#x27;valor1&#x27; [, ...]);</code></td><td><code>AS ENUM</code>: lista de valores permitidos entre comillas simples.</td></tr>
    <tr><td>Alterar</td><td><code>ALTER TYPE [esquema.]nombre ADD VALUE &#x27;nuevo_valor&#x27;;</code><br><br><br><code>ALTER TYPE [esquema.]nombre</code><br><code>    RENAME VALUE &#x27;valor_existente&#x27; TO &#x27;nuevo_valor&#x27;;</code></td><td><code>ADD VALUE</code>: añade un valor al final de la lista.<br><code>RENAME VALUE</code>: cambia un valor existente.</td></tr>
    <tr><td>Borrar</td><td><code>DROP TYPE [ IF EXISTS ] [esquema.]nombre [, ...]</code><br><code>    [ CASCADE | RESTRICT ];</code></td><td><code>IF EXISTS</code>: evita el error si no existe.<br><code>RESTRICT</code>: impide borrar si hay dependencias (por defecto).<br><code>CASCADE</code>: elimina también objetos dependientes.</td></tr>
    </tbody></table>
    </div>

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

**Referencias de sintaxis**

- [Gestión de bases de datos y objetos: material de referencia](https://nbeltran-gva.github.io/asgbd/ud3/03-basesdatos-objetos/).
- [Órdenes SQL de PostgreSQL 17](https://www.postgresql.org/docs/17/sql-commands.html), con las variantes completas, incluidas opciones avanzadas de particionamiento y almacenamiento.

Continúa con la [práctica guiada de Moviles](3_crear_moviles.md) y después con la [práctica de Juegos](4_crear_juegos.md), que reúne los ejercicios de creación de tablas, restricciones, índices, vistas y otros objetos.
