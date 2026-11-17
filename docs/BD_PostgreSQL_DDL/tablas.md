---
hide:
  - toc
---

# CREATE TABLE

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

