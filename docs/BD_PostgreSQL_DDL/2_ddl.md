# 2. DDL: definir la estructura

**DDL** (*Data Definition Language*) permite crear, modificar y eliminar bases de datos, tablas, restricciones y otros objetos. `CREATE` crea, `ALTER` modifica y `DROP` elimina. 

!!! warning "Antes de empezar: conecta a pruebas y ejecuta los ejemplos"
    Abre un editor SQL desde la conexión **Pruebas** de DBeaver. Comprueba que estás en la base correcta ejecutando:

    ```sql
    SELECT current_database();
    ```

    El resultado debe ser **pruebas**. **No te limites a leer los ejemplos: escribe y ejecuta cada sentencia**, observa el resultado y revisa los cambios en las tablas. Todos los ejemplos de este apartado se realizan en **pruebas**, siguiendo el orden en que aparecen.

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

## 2.2 CREATE TABLE

```sql
CREATE TABLE tabla (
    columna tipo [restricciones],
    otra_columna tipo [DEFAULT valor],
    [restricciones_de_tabla]
);
```

Las columnas se separan por comas. Usa identificadores sin espacios, acentos ni comillas, como `precio_unitario`. Una tabla recién creada está vacía.

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

`DEFAULT` se aplica cuando omites la columna o escribes `DEFAULT`; no sustituye un `NULL` explícito.

### Restricciones de una columna

- **PRIMARY KEY**: identifica la fila, sin duplicados ni nulos.
- **NOT NULL**: exige un valor.
- **UNIQUE**: impide duplicados; en su comportamiento normal permite varios nulos.
- **CHECK**: exige que una expresión no sea falsa. Si el resultado es desconocido por un NULL, la fila puede aceptarse; añade `NOT NULL` si el dato es obligatorio.
- **REFERENCES**: exige que el valor no nulo exista en una clave referenciada.

### Restricciones de varias columnas

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

### Claves ajenas y participación

En Juegos, `compras.id_jugador` combina **REFERENCES** y **NOT NULL**: toda compra debe pertenecer a un jugador existente. Una FK nullable permite que la referencia esté ausente; la clave ajena por sí sola no obliga a rellenarla.

Al definir `REFERENCES ... ON DELETE CASCADE`, borrar la fila referenciada también elimina las filas dependientes. Con `NO ACTION`, la operación falla si al comprobar la restricción quedan referencias sin destino. No apliques cascada a todas las relaciones por costumbre.

## 2.3 ALTER TABLE

Sirve para cambiar una tabla existente:

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

## 2.4 DROP TABLE

!!! example practica "Pruébalo: Eliminar una tabla que ya no necesitamos"

    Elimina únicamente `lineas_demo` y actualiza el navegador. Conserva `productos_demo` y `categorias_demo`: las utilizaremos después en los ejemplos de índices y vistas.

    ```sql
    DROP TABLE lineas_demo;
    ```

Borra primero las tablas dependientes. `IF EXISTS` evita el error de objeto inexistente, pero no protege datos. `DROP TABLE ... CASCADE` elimina también objetos dependientes; no es equivalente a `ON DELETE CASCADE`, que actúa sobre filas. Usa `pruebas` para estos ejemplos.

## 2.5 Índices

Un índice puede facilitar búsquedas y ordenaciones, a costa de espacio y trabajo adicional al modificar datos. PostgreSQL ya crea índices para PK y UNIQUE; no crea automáticamente uno para cada FK.

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

Una vista guarda una consulta, no una copia estática de sus filas.

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

## 2.7 Secuencias, dominios y tipos

### Secuencias

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

### Dominios

Un dominio reutiliza un tipo y sus restricciones:

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

### Tipos enumerados

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

Continúa con la [práctica guiada de Moviles](3_crear_moviles.md) y después con la [práctica de Juegos](4_crear_juegos.md), que reúne los ejercicios de creación de tablas, restricciones, índices, vistas y otros objetos.
