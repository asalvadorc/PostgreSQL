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

A continuación, para practicar la creación de tablas, crearemos **departamentos** y **empleados** dentro de la base de datos **pruebas**. Un departamento puede tener varios empleados: la relación será **1:N**. Empezaremos con tablas sin restricciones y, en el siguiente apartado, incorporaremos las claves y las reglas de validación.

![Esquema de departamentos y empleados con una relación uno a muchos mediante codigo_departamento](../departamentos-empleados-relacion.png){ width="800" }

!!! example practica "Pruébalo: Crear tablas sin restricciones"

    Desde la conexión a **pruebas**, ejecuta estas sentencias. Por ahora solo definimos los nombres y tipos de las columnas; todavía no añadimos claves ni otras restricciones.

    ```sql
    CREATE TABLE departamentos (
        codigo INTEGER,
        nombre VARCHAR(100)
    );

    CREATE TABLE empleados (
        codigo INTEGER,
        nombre VARCHAR(150),
        fecha_nacimiento DATE,
        salario NUMERIC(10,2),
        correo VARCHAR(150),
        codigo_departamento INTEGER
    );
    ```

    Actualiza el navegador de DBeaver y comprueba que aparecen las dos tablas. Están vacías y todavía no tienen claves primarias ni ajenas. Conserva ambas: en el apartado siguiente las recrearemos para incorporar restricciones.

<a id="ejercicios-juegos"></a>

## Ejercicios: Crear las primeras tablas

Antes de empezar, completa [la creación de Juegos y su conexión](crear_bases_datos.md#crear-juegos-y-su-conexion). Los campos y tipos necesarios aparecen en cada ejercicio. Guarda las sentencias en `02_juegos.sql`.

??? info "Referencia general de campos y tipos de Juegos"

    | Tabla | Campos y tipos |
    | --- | --- |
    | categorias | id_categoria SERIAL, descripcion VARCHAR(100). |
    | productos | id_producto SERIAL, nombre VARCHAR(200), precio DECIMAL(10,2), stock INTEGER, stock_minimo INTEGER, id_categoria INTEGER. |
    | provincias | id_provincia SERIAL, nombre VARCHAR(100). |
    | ciudades | id_ciudad SERIAL, nombre VARCHAR(100), id_provincia INTEGER. |
    | vendedores | id_vendedor SERIAL, nombre VARCHAR(150), direccion VARCHAR(200), codigo_postal VARCHAR(10), id_ciudad INTEGER, id_jefe INTEGER. |
    | jugadores | id_jugador SERIAL, nombre VARCHAR(150), direccion VARCHAR(200), codigo_postal VARCHAR(10), id_ciudad INTEGER. |
    | compras | id_compra SERIAL, fecha DATE, id_jugador INTEGER, id_vendedor INTEGER, iva DECIMAL(5,2), descuento DECIMAL(5,2). |
    | lineas_compra | id_compra INTEGER, num_linea INTEGER, id_producto INTEGER, cantidad INTEGER, precio_unitario DECIMAL(10,2), descuento_linea DECIMAL(5,2). |

    Recuerda:

    - `SERIAL` genera códigos, pero no añade una PK por sí solo. Para las claves ajenas utiliza `INTEGER`.
    - La PK de `lineas_compra` será `(id_compra, num_linea)`; no añadas otro código autonumérico.
    - `vendedores.id_jefe` puede ser nulo y referencia a la propia tabla. Añadirás esa FK en el ejercicio 12.
    - La FK de las líneas hacia las compras llevará `ON DELETE CASCADE`; las demás referencias conservarán `NO ACTION`, como indica el ejercicio 13.
    - Después de cada ejercicio, actualiza el navegador de DBeaver y revisa las columnas y restricciones que hayas añadido.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 1: Crear categorias</span></span> {#ejercicio-1-crear-categorias}

!!! ejercicio "Juegos"

    **Campos de `categorias`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_categoria` | `SERIAL` |
    | `descripcion` | `VARCHAR(100)` |

    Crea `categorias` con los campos y tipos indicados arriba. Utiliza `SERIAL` en `id_categoria`, pero no añadas todavía la clave primaria ni otras restricciones explícitas.

### <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 2: Crear productos</span></span> {#ejercicio-2-crear-productos}

!!! ejercicio "Juegos"

    **Campos de `productos`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_producto` | `SERIAL` |
    | `nombre` | `VARCHAR(200)` |
    | `precio` | `DECIMAL(10,2)` |
    | `stock` | `INTEGER` |
    | `stock_minimo` | `INTEGER` |
    | `id_categoria` | `INTEGER` |

    Crea `productos` con todos sus campos. Utiliza `SERIAL` en `id_producto`, pero deja pendientes su clave primaria y su clave ajena hacia `categorias`. No añadas todavía restricciones de validación.

**Antes de continuar:** Al terminar deben existir `categorias` y `productos`, todavía sin PK ni FK. No las borres: continuarás con ellas después de estudiar las restricciones.

Actualiza la conexión **Juegos** en DBeaver y despliega **Bases de datos → juegos → Esquemas → public → Tablas**. Abre las columnas de cada tabla para comprobar sus nombres y tipos. El árbol quedará como en esta imagen orientativa:

![Árbol de DBeaver con las tablas categorias y productos de juegos y sus columnas, tras los ejercicios 1 y 2](../juegos-arbol-primeras-tablas.png){ width="600" }

