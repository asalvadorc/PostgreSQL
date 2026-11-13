# 2. DDL: Esquema de la BD

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
| `[esquema.]nombre` | El esquema es opcional; en nuestro entorno se utiliza `public` por defecto. Por ejemplo, `public.productos_demo`. |

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

## 2.2 Crear bases de datos

Una **base de datos** contiene los esquemas y objetos con los que trabajaremos. `CREATE DATABASE` crea una base de datos nueva dentro del servidor PostgreSQL; después debemos conectarnos a ella para crear sus tablas.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE DATABASE nombre_bd</code><br/><code>    [ OWNER nombre_usuario ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    - `nombre_bd`: nombre de la nueva base de datos.
    - `OWNER`: indica su propietario; si se omite, será el usuario que ejecuta la sentencia.


En [Inicio creamos la base de datos `pruebas`](../crear_pruebas.md) ejecutando `CREATE DATABASE pruebas;` desde la conexión a `postgres`. **No vuelvas a crearla si ya existe.** La creación se ejecuta como sentencia independiente, fuera de un bloque de transacción. También puede realizarse desde el modo gráfico de DBeaver, como vimos en ese apartado.

Crear una base de datos no cambia automáticamente la conexión del editor SQL. Para los ejemplos siguientes utiliza la conexión a **pruebas** y comprueba su destino con `SELECT current_database();`.

## 2.3 Esquemas

Un **esquema** es un espacio dentro de una base de datos que organiza sus objetos, como tablas y vistas. En la configuración de estas prácticas, si no indicamos el esquema, se utiliza **`public` por defecto**: `CREATE TABLE productos_demo (...)` crea la misma tabla que `CREATE TABLE public.productos_demo (...)`. Este comportamiento depende de la ruta de búsqueda de esquemas (`search_path`); aquí mantendremos su configuración inicial.

La organización es **servidor → base de datos → esquema → tabla**. Por ejemplo, en nuestro servidor tenemos la base de datos `pruebas`, que contiene el esquema `public`, donde crearemos `productos_demo`.

La notación `[esquema.]nombre_tabla` indica que podemos escribir el esquema seguido de un punto o dejar solo el nombre de la tabla. En los ejemplos posteriores utilizaremos `public`, pero primero vamos a crear un esquema de demostración.

`CREATE SCHEMA` crea un espacio para organizar objetos dentro de la base de datos a la que estamos conectados. Crear un esquema no crea otra base de datos ni cambia el esquema predeterminado del editor.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE SCHEMA [ IF NOT EXISTS ] nombre_esquema</code><br/><code>    [ AUTHORIZATION nombre_usuario ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    - `IF NOT EXISTS`: evita el error si el esquema ya existe.
    - `AUTHORIZATION`: indica su propietario; si se omite, será el usuario que ejecuta la sentencia.


!!! example practica "Pruébalo: Crear un esquema"

    Desde la conexión a **pruebas**, con el usuario **alumno**, ejecuta:

    ```sql
    -- Crear un esquema cuyo propietario será el usuario alumno.
    CREATE SCHEMA laboratorio;
    ```

    Actualiza el nodo **Esquemas / Schemas** de `pruebas` en DBeaver. Debe aparecer `laboratorio` junto a `public`. Si no lo ves, revisa los filtros de esquemas de la conexión.

    Este esquema permitiría organizar tablas con nombres como `laboratorio.productos_demo`. Para crearlas dentro de él tendríamos que indicar el prefijo `laboratorio.`; crearlo no hace que las nuevas tablas dejen de utilizar `public` por defecto.

    Como todavía está vacío y no lo utilizaremos en los siguientes ejemplos, elimínalo:

    ```sql
    -- Eliminar el esquema de demostración, que no contiene objetos.
    DROP SCHEMA laboratorio;
    ```

    Actualiza de nuevo el nodo **Esquemas / Schemas** y comprueba que desaparece. `DROP SCHEMA` sin `CASCADE` solo permite eliminarlo si está vacío.

## 2.4 Tablas

### CREATE TABLE

`CREATE TABLE` crea una tabla y define sus columnas, tipos de datos, valores por defecto y restricciones. La tabla se crea vacía, preparada para insertar datos más adelante.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE TABLE [ IF NOT EXISTS ] [esquema.]nombre_tabla (</code><br><code>    columna tipo_dato [ DEFAULT expresion ] [ restricciones_de_columna ]</code><br><code>    [, ...]</code><br><code>    [, restricciones_de_tabla ... ]</code><br><code>);</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    - `IF NOT EXISTS`: evita el error si la tabla ya existe; no modifica su estructura.
    - `esquema.`: opcional; si se omite, en estas prácticas se utiliza `public` por defecto.
    - `DEFAULT`: valor que se aplica si se omite la columna.
    - `restricciones_de_columna`: reglas como `NOT NULL`, `PRIMARY KEY`, `UNIQUE`, `CHECK` o `REFERENCES`.
    - `restricciones_de_tabla`: reglas sobre una o varias columnas, separadas de las definiciones de columna mediante comas.

Las columnas se separan por comas. Usa identificadores sin espacios, acentos ni comillas.

!!! example practica "Pruébalo: Crear las primeras tablas"

    Ejecuta las sentencias en orden y comprueba que aparecen `categorias_demo` y `productos_demo` en el navegador de DBeaver.

    ```sql
    CREATE TABLE categorias_demo (
        id_categoria SERIAL PRIMARY KEY, -- Restricción de columna: PRIMARY KEY
        descripcion VARCHAR(100) NOT NULL -- Restricción de columna: NOT NULL
    );

    CREATE TABLE productos_demo (
        id_producto SERIAL PRIMARY KEY, -- Restricción de columna: PRIMARY KEY
        nombre VARCHAR(200) NOT NULL, -- Restricción de columna: NOT NULL
        precio NUMERIC(10,2),
        stock INTEGER DEFAULT 0,
        id_categoria INTEGER,
        CONSTRAINT ck_demo_precio CHECK (precio >= 0), -- Restricción de tabla: CHECK
        CONSTRAINT fk_demo_categoria FOREIGN KEY (id_categoria) -- Restricción de tabla: FOREIGN KEY
            REFERENCES categorias_demo(id_categoria)
    );
    ```

### Restricciones

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

### ALTER TABLE

`ALTER TABLE` modifica la estructura de una tabla existente: permite añadir o eliminar columnas y restricciones, cambiar tipos y valores por defecto, o renombrar la tabla y sus columnas.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>ALTER TABLE [esquema.]nombre_tabla</code><br/><code>    accion [, ...];</code></td></tr>
    <tr><td><code>ADD COLUMN columna tipo_dato [ restricciones ]</code><br/><code>DROP COLUMN columna [ CASCADE | RESTRICT ]</code><br/><code>ALTER COLUMN columna TYPE tipo_dato [ USING expresion ]</code><br/><code>ALTER COLUMN columna SET DEFAULT expresion</code><br/><code>ALTER COLUMN columna DROP DEFAULT</code><br/><code>ALTER COLUMN columna SET NOT NULL</code><br/><code>ALTER COLUMN columna DROP NOT NULL</code></td></tr>
    <tr><td><code>ADD [ CONSTRAINT nombre_restriccion ] restriccion_de_tabla</code><br/><code>DROP CONSTRAINT nombre_restriccion</code></td></tr>
    <tr><td><code>ALTER TABLE [esquema.]nombre_tabla</code><br/><code>    RENAME COLUMN columna TO nuevo_nombre;</code><br/><br/><br/><code>ALTER TABLE [esquema.]nombre_tabla</code><br/><code>    RENAME TO nuevo_nombre;</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`ALTER TABLE`**

    - `accion`: cambio que se aplica a la tabla.
    - Se pueden separar varias acciones compatibles por comas.

    **`ADD COLUMN`**

    - `ADD / DROP COLUMN`: añade o elimina una columna.
    - `TYPE`: cambia el tipo; `USING` indica cómo convertir los valores.
    - `SET / DROP DEFAULT`: establece o quita el valor por defecto.
    - `SET / DROP NOT NULL`: exige un valor o permite nulos.

    **`ADD [`**

    - `ADD CONSTRAINT`: añade una restricción.
    - `DROP CONSTRAINT`: elimina la restricción indicada.

    **`ALTER TABLE`**

    - `RENAME COLUMN`: cambia el nombre de una columna.
    - `RENAME TO`: cambia el nombre de la tabla. Son sentencias independientes.


`USING` indica cómo convertir los valores existentes al cambiar el tipo de una columna.

!!! example practica "Pruébalo: Modificar una tabla"

    Ejecuta las sentencias una a una y observa los cambios en las columnas y restricciones de `productos_demo`.

    ```sql
    ALTER TABLE productos_demo ADD COLUMN activo BOOLEAN DEFAULT TRUE;
    ALTER TABLE productos_demo ALTER COLUMN nombre TYPE VARCHAR(250);
    ALTER TABLE productos_demo ALTER COLUMN stock SET DEFAULT 1;
    ALTER TABLE productos_demo ALTER COLUMN stock SET NOT NULL; -- Restricción de columna: NOT NULL
    ALTER TABLE productos_demo ADD CONSTRAINT ck_demo_stock CHECK (stock >= 0); -- Restricción de tabla: CHECK
    ALTER TABLE productos_demo RENAME COLUMN activo TO disponible;
    ALTER TABLE productos_demo DROP COLUMN disponible;
    ALTER TABLE productos_demo DROP CONSTRAINT ck_demo_stock; -- Elimina la restricción de tabla CHECK
    ```

Antes de añadir una restricción, los datos existentes deben cumplirla. `SET NOT NULL` falla si ya hay nulos. Para cambiar una FK, elimina su restricción y créala con el comportamiento nuevo.

### DROP TABLE

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

    Elimina únicamente `lineas_demo` y actualiza el navegador. Conserva `productos_demo` y `categorias_demo`: las utilizaremos después en los ejemplos de índices y vistas.

    ```sql
    DROP TABLE lineas_demo;
    ```

Borra primero las tablas dependientes. `IF EXISTS` evita el error de objeto inexistente, pero no protege datos. `DROP TABLE ... CASCADE` elimina también objetos dependientes; no es equivalente a `ON DELETE CASCADE`, que actúa sobre filas. Usa `pruebas` para estos ejemplos.

## 2.5 Índices

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

    Utiliza `productos_demo`, que has conservado en `pruebas`. Ejecuta primero los CREATE INDEX y comprueba los índices en DBeaver. Después ejecuta los DROP INDEX; la tabla seguirá existiendo.

    ```sql
    CREATE INDEX i_demo_productos_nombre ON productos_demo (nombre);
    CREATE INDEX i_demo_productos_categoria_precio
        ON productos_demo (id_categoria ASC, precio DESC);

    DROP INDEX i_demo_productos_nombre;
    DROP INDEX i_demo_productos_categoria_precio;
    ```

El optimizador decide si utiliza un índice. Con tablas pequeñas puede preferir un recorrido completo.

## 2.6 Vistas

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

## 2.7 Secuencias

Una secuencia genera valores numéricos que podemos utilizar como identificadores. `CREATE SEQUENCE` define su inicio e incremento; `ALTER SEQUENCE` permite reiniciar el contador o vincularlo a una columna, y `DROP SEQUENCE` elimina la secuencia.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE SEQUENCE [ IF NOT EXISTS ] [esquema.]nombre</code><br/><code>    [ START WITH inicio ]</code><br/><code>    [ INCREMENT BY incremento ]</code><br/><code>    [ OWNED BY tabla.columna ];</code></td></tr>
    <tr><td><code>ALTER SEQUENCE [esquema.]nombre</code><br/><code>    RESTART WITH valor;</code><br/><br/><br/><code>ALTER SEQUENCE [esquema.]nombre</code><br/><code>    OWNED BY tabla.columna;</code></td></tr>
    <tr><td><code>DROP SEQUENCE [ IF EXISTS ] [esquema.]nombre [, ...]</code><br/><code>    [ CASCADE | RESTRICT ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE SEQUENCE`**

    - `START WITH`: primer valor; por defecto, 1 en una secuencia ascendente.
    - `INCREMENT BY`: salto entre valores; por defecto, 1.
    - `OWNED BY`: vincula la secuencia a una columna.

    **`ALTER SEQUENCE`**

    - `RESTART WITH`: establece el próximo valor.
    - `OWNED BY`: vincula una secuencia existente a una columna.

    **`DROP SEQUENCE`**

    - `IF EXISTS`: evita el error si no existe.
    - `RESTRICT`: impide borrar si hay dependencias (por defecto).
    - `CASCADE`: elimina también objetos dependientes.


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

## 2.8 Dominios

Un dominio reutiliza un tipo de dato y sus restricciones en distintas columnas. `CREATE DOMAIN` lo define; `ALTER DOMAIN` cambia sus valores por defecto o sus restricciones, y `DROP DOMAIN` lo elimina, teniendo en cuenta los objetos que lo utilizan.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE DOMAIN [esquema.]nombre AS tipo_dato</code><br/><code>    [ DEFAULT expresion ]</code><br/><code>    [ NOT NULL ]</code><br/><code>    [ [ CONSTRAINT nombre_restriccion ] CHECK (condicion) ];</code></td></tr>
    <tr><td><code>ALTER DOMAIN [esquema.]nombre</code><br/><code>    { SET DEFAULT expresion</code><br/><code>    | DROP DEFAULT</code><br/><code>    | SET NOT NULL</code><br/><code>    | DROP NOT NULL</code><br/><code>    | ADD [ CONSTRAINT nombre ] CHECK (condicion)</code><br/><code>    | DROP CONSTRAINT nombre };</code></td></tr>
    <tr><td><code>DROP DOMAIN [ IF EXISTS ] [esquema.]nombre [, ...]</code><br/><code>    [ CASCADE | RESTRICT ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE DOMAIN`**

    - `DEFAULT`: valor por defecto.
    - `NOT NULL`: exige un valor.
    - `CHECK`: comprueba una condición sobre `VALUE`.
    - `CONSTRAINT`: asigna un nombre a la restricción.

    **`ALTER DOMAIN`**

    - `SET / DROP`: establece o elimina el valor por defecto o la obligatoriedad.
    - `ADD / DROP CONSTRAINT`: añade o elimina restricciones.

    **`DROP DOMAIN`**

    - `IF EXISTS`: evita el error si no existe.
    - `RESTRICT`: impide borrar si hay dependencias (por defecto).
    - `CASCADE`: elimina también objetos dependientes.


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

## 2.9 Tipos enumerados

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

## 2.10 Usuarios y privilegios

Hasta ahora hemos trabajado con `alumno`, el administrador de nuestro entorno. En una base de datos compartida, cada usuario debe disponer de los permisos que necesita: por ejemplo, una persona puede consultar una tabla sin poder modificarla.

En PostgreSQL los permisos se asignan a **roles**. Un rol que puede iniciar sesión actúa como un **usuario**. `CREATE USER` equivale a `CREATE ROLE` con la opción `LOGIN`. Los usuarios pertenecen al servidor PostgreSQL y pueden utilizarse en sus distintas bases de datos; los permisos sobre tablas se conceden dentro de la base correspondiente.

`CREATE USER` crea un usuario, `ALTER USER` permite cambiar su contraseña y `DROP USER` lo elimina. La creación de usuarios se completa con `GRANT`, para **conceder privilegios**, y `REVOKE`, para **retirarlos**. Estas dos sentencias forman parte de **DCL** (*Data Control Language*, lenguaje de control de datos). Las estudiamos aquí para completar la definición y el acceso a los objetos de la base de datos.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE USER nombre PASSWORD 'contraseña';</code></td></tr>
    <tr><td><code>ALTER USER nombre PASSWORD 'nueva_contraseña';</code></td></tr>
    <tr><td><code>GRANT privilegio [, ...]</code><br/><code>    ON TABLE [esquema.]tabla TO usuario;</code></td></tr>
    <tr><td><code>REVOKE privilegio [, ...]</code><br/><code>    ON TABLE [esquema.]tabla FROM usuario;</code></td></tr>
    <tr><td><code>DROP USER nombre;</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE USER`**

    - `CREATE USER`: crea un rol con permiso para iniciar sesión.
    - `PASSWORD`: establece su contraseña.

    **`ALTER USER`**

    - `PASSWORD`: cambia la contraseña.

    **`GRANT privilegio`**

    - `TO`: usuario que recibe los permisos.
    - Para una tabla: `SELECT`, `INSERT`, `UPDATE` y `DELETE`, entre otros.

    **`REVOKE privilegio`**

    - `FROM`: usuario al que se retira el permiso concedido.

    **`DROP USER`**

    - Antes deben eliminarse o reasignarse sus objetos y retirarse sus permisos en las bases de datos correspondientes.


### Usuarios y roles: qué diferencia hay

Imagina que varias personas necesitan consultar las mismas tablas. Podemos conceder `SELECT` a cada usuario por separado, pero tendríamos que repetir las concesiones cada vez que se incorpora alguien. Un **rol de grupo** permite reunir esos permisos y asignarlos de una vez a sus miembros.

| Concepto | Para qué sirve | Ejemplo |
| --- | --- | --- |
| Usuario, un rol con `LOGIN` | Identifica a una persona o aplicación que se conecta. | `lector_demo` |
| Rol de grupo, normalmente con `NOLOGIN` | Agrupa permisos para compartirlos entre usuarios. | `consulta_demo` |
| Privilegio | Autoriza una operación sobre un objeto. | `SELECT` sobre `permisos_demo` |
| Pertenencia | Vincula un usuario con un rol de grupo. | `lector_demo` pertenece a `consulta_demo` |

**Los permisos se conceden al rol; los usuarios se incorporan a ese rol.** Por ejemplo, si cinco usuarios pertenecen a `consulta_demo`, podemos conceder una nueva tabla al rol y sus cinco miembros tendrán acceso a ella. Cada persona sigue conectándose con su propio usuario y contraseña.

En PostgreSQL ambos son roles: `CREATE ROLE consulta_demo NOLOGIN` crea el grupo sin inicio de sesión; `CREATE USER lector_demo ...` crea un rol con `LOGIN`. Con la configuración predeterminada que utilizamos, los usuarios **heredan automáticamente** los permisos de los roles a los que pertenecen.

### Permisos más habituales

| Objeto | Privilegio | Permite |
| --- | --- | --- |
| Base de datos | `CONNECT` | Conectarse a esa base de datos. |
| Esquema | `USAGE` | Acceder a los objetos del esquema, si también se tienen los permisos necesarios sobre ellos. |
| Tabla o vista | `SELECT` | Consultar sus datos. |
| Tabla | `INSERT` | Insertar filas. |
| Tabla | `UPDATE` | Modificar filas. |
| Tabla | `DELETE` | Borrar filas. |

**Conectarse a una base de datos no da permiso para consultar o modificar todas sus tablas.** Los permisos de base de datos, esquema y tabla cumplen funciones diferentes. Tampoco es lo mismo `DELETE`, que borra filas, que `DROP TABLE`, que elimina la tabla: conceder `DELETE` no permite eliminar su estructura.

### Crear un usuario de consulta

!!! example practica "Pruébalo: Crear un usuario y conceder permisos"

    Desde tu conexión a **pruebas**, con el usuario **alumno**, ejecuta las sentencias una a una. Utilizaremos una tabla independiente de los ejemplos anteriores.

    ```sql
    -- Crear una tabla para comprobar los permisos.
    CREATE TABLE permisos_demo (
        id INTEGER PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );

    -- Crear un usuario sin privilegios de administrador.
    CREATE USER lector_demo PASSWORD 'lector_demo';

    -- Permitir la conexión a pruebas y el acceso al esquema public.
    GRANT CONNECT ON DATABASE pruebas TO lector_demo;
    GRANT USAGE ON SCHEMA public TO lector_demo;

    -- Permitir únicamente la consulta de esta tabla.
    GRANT SELECT ON TABLE public.permisos_demo TO lector_demo;
    ```

    La contraseña es un ejemplo para el entorno local de las prácticas. No modifiques el usuario `alumno` ni las variables de `compose.yaml`: el nuevo usuario se crea en el servidor que ya está funcionando.

PostgreSQL puede conceder algunos permisos a `PUBLIC`, que representa a todos los usuarios. Por ejemplo, `CONNECT` y el acceso al esquema `public` pueden estar disponibles de antemano. Los indicamos explícitamente para distinguir los niveles de acceso. Un usuario acumula sus permisos directos, los de sus roles y los de `PUBLIC`.

### Comprobar los permisos desde DBeaver

!!! example practica "Pruébalo: Conectarte como lector_demo"

    Crea una **nueva conexión PostgreSQL** en DBeaver con estos datos. Conserva abierta la conexión de `alumno` para administrar los permisos.

    | Campo | Valor |
    | --- | --- |
    | Host | `localhost` |
    | Puerto | `5433` |
    | Base de datos | `pruebas` |
    | Usuario | `lector_demo` |
    | Contraseña | `lector_demo` |
    | Nombre de la conexión | `Pruebas - lector` |

    Abre **Editor SQL → Nuevo script SQL** desde esta nueva conexión y ejecuta:

    ```sql
    SELECT current_database(), current_user;
    SELECT * FROM public.permisos_demo;
    ```

    La primera consulta debe mostrar `pruebas` y `lector_demo`. La segunda funciona, aunque no devuelve filas porque la tabla está vacía.

    Después ejecuta **por separado**:

    ```sql
    DELETE FROM public.permisos_demo;
    ```

    Debe aparecer un error de permiso denegado: `lector_demo` puede consultar la tabla, pero no borrar sus filas, aunque esté vacía. Estas comprobaciones deben hacerse con `lector_demo`; el administrador `alumno` no tiene esas limitaciones. Si el editor queda en una transacción fallida tras el error, pulsa **Rollback** antes de continuar.

### Conceder y retirar permisos

!!! example practica "Pruébalo: Cambiar los permisos"

    Vuelve al editor de **pruebas con el usuario alumno** y concede el permiso de borrado:

    ```sql
    GRANT DELETE ON TABLE public.permisos_demo TO lector_demo;
    ```

    Desde la conexión **Pruebas - lector**, repite:

    ```sql
    DELETE FROM public.permisos_demo;
    ```

    Ahora la sentencia se ejecuta correctamente y afecta a **0 filas**, porque la tabla está vacía.

    De nuevo como **alumno**, retira ese permiso:

    ```sql
    REVOKE DELETE ON TABLE public.permisos_demo FROM lector_demo;
    ```

    Comprueba como **lector_demo**, ejecutando cada sentencia por separado, que `SELECT` sigue funcionando y `DELETE` vuelve a dar un error de permiso denegado.

`REVOKE` retira la concesión indicada. Si un usuario obtiene el mismo permiso a través de otro rol o de `PUBLIC`, puede seguir disponiendo de él. En este ejemplo, el permiso `DELETE` se había concedido directamente a `lector_demo`.

### Agrupar los permisos en un rol

`CREATE ROLE ... NOLOGIN` crea un grupo de permisos. `GRANT rol TO usuario` incorpora un usuario al grupo y `REVOKE rol FROM usuario` retira su pertenencia. `DROP ROLE` elimina el rol una vez resueltas sus dependencias.

Ahora sustituiremos el permiso de consulta concedido directamente a `lector_demo` por un permiso obtenido a través de un rol. Utilizaremos el mismo usuario y la misma tabla, antes de eliminarlos.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE ROLE nombre_rol NOLOGIN;</code></td></tr>
    <tr><td><code>GRANT SELECT ON TABLE tabla TO nombre_rol;</code></td></tr>
    <tr><td><code>GRANT nombre_rol TO usuario;</code></td></tr>
    <tr><td><code>REVOKE nombre_rol FROM usuario;</code></td></tr>
    <tr><td><code>DROP ROLE nombre_rol;</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **`CREATE ROLE`**

    - `NOLOGIN`: impide iniciar sesión con el rol; es el valor predeterminado de `CREATE ROLE`.

    **`GRANT SELECT`**

    - Concede el permiso al grupo.

    **`GRANT nombre_rol`**

    - Incorpora el usuario al rol; no lleva `ON TABLE`.

    **`REVOKE nombre_rol`**

    - Retira la pertenencia, sin eliminar el usuario ni el rol.

    **`DROP ROLE`**

    - Antes deben retirarse sus permisos y resolverse sus dependencias.


Fíjate en las dos formas de `GRANT`: **`GRANT SELECT ON TABLE ...` concede un privilegio sobre una tabla**, mientras que **`GRANT consulta_demo TO ...` concede pertenencia a un rol**.

!!! example practica "Pruébalo: Compartir permisos mediante un rol"

    Desde **pruebas con el usuario alumno**, ejecuta:

    ```sql
    -- Crear un rol que agrupará los permisos de consulta.
    CREATE ROLE consulta_demo NOLOGIN;

    -- Conceder el permiso al rol de grupo.
    GRANT SELECT ON TABLE public.permisos_demo TO consulta_demo;

    -- Incorporar el usuario al grupo.
    GRANT consulta_demo TO lector_demo;

    -- Retirar la concesión directa: la consulta dependerá ahora del rol.
    REVOKE SELECT ON TABLE public.permisos_demo FROM lector_demo;
    ```

    Desde la conexión **Pruebas - lector**, ejecuta:

    ```sql
    SELECT * FROM public.permisos_demo;
    ```

    La consulta sigue funcionando: `lector_demo` recibe `SELECT` por pertenecer a `consulta_demo`, aunque ya no lo tenga concedido directamente.

    Ahora, como **alumno**, retira la pertenencia:

    ```sql
    REVOKE consulta_demo FROM lector_demo;
    ```

    Repite la consulta como **lector_demo**: debe fallar por falta de permisos. Si queda una transacción fallida, pulsa **Rollback**. El usuario sigue existiendo y puede conectarse, pero ya no recibe el permiso del grupo.

    Por último, como **alumno**, vuelve a incorporarlo:

    ```sql
    GRANT consulta_demo TO lector_demo;
    ```

    Comprueba que la consulta vuelve a funcionar desde **Pruebas - lector**.

Si más adelante creamos otro usuario que necesite consultar esta tabla, bastará con incorporarlo a `consulta_demo`. No tendremos que repetir la concesión de `SELECT` para cada usuario.

### Limpiar los objetos de la práctica

!!! example practica "Pruébalo: Eliminar la tabla y el usuario de demostración"

    Cierra los editores y desconecta **Pruebas - lector**. Si había cambios pendientes, revierte la transacción. Desde **pruebas con el usuario alumno**, ejecuta:

    ```sql
    -- Eliminar la tabla y los permisos asociados a ella.
    DROP TABLE public.permisos_demo;

    -- Retirar las otras concesiones explícitas de la práctica.
    REVOKE USAGE ON SCHEMA public FROM lector_demo;
    REVOKE CONNECT ON DATABASE pruebas FROM lector_demo;

    -- Retirar la pertenencia al grupo.
    REVOKE consulta_demo FROM lector_demo;

    -- Eliminar el rol y el usuario una vez resueltas sus dependencias.
    DROP ROLE consulta_demo;
    DROP USER lector_demo;
    ```

    Después puedes eliminar de DBeaver la conexión **Pruebas - lector**, que ya no podrá utilizarse. Conserva tu conexión habitual con `alumno`.

!!! question "Autoevaluación"

    Un usuario puede conectarse a `pruebas`, pero recibe un error al consultar `permisos_demo`. ¿Es suficiente tener `CONNECT`? ¿Qué otros permisos necesita?

    ??? success "Ver solución"

        No. Necesita `USAGE` sobre el esquema que contiene la tabla y `SELECT` sobre la tabla. `CONNECT` permite conectarse a la base de datos, pero no concede por sí solo acceso a sus tablas.

!!! question "Autoevaluación: permisos directos y roles"

    Si retiramos a `lector_demo` del rol `consulta_demo`, ¿se elimina el usuario? ¿Podría seguir consultando la tabla si también tuviera `SELECT` concedido directamente?

    ??? success "Ver solución"

        El usuario no se elimina: solo pierde la pertenencia al rol y los permisos que recibía por esa vía. Si conserva una concesión directa de `SELECT`, puede seguir consultando la tabla. Para retirar un acceso hay que revisar todas las vías por las que lo obtiene.

Consulta también la documentación sobre [pertenencia a roles](https://www.postgresql.org/docs/17/role-membership.html).

Consulta la documentación de PostgreSQL 17 sobre [usuarios y roles](https://www.postgresql.org/docs/17/sql-createrole.html) y [concesión de privilegios](https://www.postgresql.org/docs/17/sql-grant.html).

**Referencias de sintaxis**

- [Gestión de bases de datos y objetos: material de referencia](https://nbeltran-gva.github.io/asgbd/ud3/03-basesdatos-objetos/).
- [Órdenes SQL de PostgreSQL 17](https://www.postgresql.org/docs/17/sql-commands.html), con las variantes completas, incluidas opciones avanzadas de particionamiento y almacenamiento.

Continúa con la [práctica guiada de Moviles](3_crear_moviles.md) y después con la [práctica de Juegos](4_crear_juegos.md), que reúne los ejercicios de creación de tablas, restricciones, índices, vistas y otros objetos.
