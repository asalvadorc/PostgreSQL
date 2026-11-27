# Enunciados de todos los ejercicios

Aquí tienes reunidos los ejercicios de DDL, en el mismo orden y con la misma numeración que en los apartados del tema. No es una práctica adicional: son los mismos ejercicios.

Realiza los ejercicios **0–13 en `juegos`** y el **14 en `empresa`**. Conserva las tablas de Juegos para la carga de datos de DML.


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 0: Preparar Juegos y su conexión</span></span> {#ejercicio-0-preparar-juegos-y-su-conexion}

!!! ejercicio "Juegos"

    1. Desde la conexión a **postgres**, abre **Editor SQL → Nuevo script SQL** y ejecuta:

        ```sql
        CREATE DATABASE juegos;
        ```

    2. Actualiza **Bases de datos / Databases** y comprueba que aparece `juegos`. También puedes crearla en modo gráfico, como explicamos al [crear empresa](crear_bases_datos.md#crear-la-base-de-datos-empresa): elige una de las dos opciones, no ambas.
    3. Crea una **nueva conexión PostgreSQL** siguiendo los [mismos pasos de la conexión a empresa](crear_bases_datos.md#crear-la-conexion-a-empresa). Mantén `localhost`, puerto `5433`, usuario y contraseña `alumno`, pero escribe **juegos** en el campo **Base de datos**. Guarda la conexión como **Juegos**.
    4. Abre un editor SQL desde esta nueva conexión y comprueba:

        ```sql
        SELECT current_database();
        ```

        El resultado debe ser **juegos**.

[Ver en el tema](crear_bases_datos.md#ejercicio-0-preparar-juegos-y-su-conexion)


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

## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 1: Crear categorias</span></span> {#ejercicio-1-crear-categorias}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, escribe y ejecuta una sentencia `CREATE TABLE` para crear `categorias`, donde se guardarán las categorías que clasifican los productos de la tienda.

    **Modelo relacional**

    **CATEGORIAS** (<u>id_categoria</u>, descripcion)

    - PK: (id_categoria)

    Define las columnas con los tipos indicados en la tabla siguiente. `SERIAL` generará automáticamente los códigos de `id_categoria`.

    Aunque el modelo indica una clave primaria, **no la declares todavía ni añadas otras restricciones explícitas**. En este ejercicio practicaremos la definición de columnas y tipos; incorporaremos la PK en el ejercicio 11.

    **Campos de `categorias`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_categoria` | `SERIAL` |
    | `descripcion` | `VARCHAR(100)` |


[Ver en el tema](tablas.md#ejercicio-1-crear-categorias)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 2: Crear productos</span></span> {#ejercicio-2-crear-productos}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, crea `productos` para guardar los artículos que vende la tienda. Utiliza los campos y tipos de la tabla siguiente.

    **Modelo relacional**

    **PRODUCTOS** (<u>id_producto</u>, nombre, precio, stock, stock_minimo, <mark>id_categoria</mark>)

    - PK: (id_producto)
    - FK: id_categoria → CATEGORIAS(id_categoria)

    El modelo muestra las claves que tendrá la tabla al completar los ejercicios. **Por ahora no declares la PK ni la FK, ni añadas otras restricciones de validación**. `SERIAL` generará los códigos de `id_producto`; las claves se añadirán en el ejercicio 12.

    **Campos de `productos`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_producto` | `SERIAL` |
    | `nombre` | `VARCHAR(200)` |
    | `precio` | `DECIMAL(10,2)` |
    | `stock` | `INTEGER` |
    | `stock_minimo` | `INTEGER` |
    | `id_categoria` | `INTEGER` |

[Ver en el tema](tablas.md#ejercicio-2-crear-productos)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 3: Crear provincias</span></span> {#ejercicio-3-crear-provincias}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, crea `provincias` para registrar las provincias de las ciudades. Utiliza los campos y tipos de la tabla siguiente y define `id_provincia` como clave primaria.

    **Modelo relacional**

    **PROVINCIAS** (<u>id_provincia</u>, nombre)

    - PK: (id_provincia)

    **Campos de `provincias`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_provincia` | `SERIAL` |
    | `nombre` | `VARCHAR(100)` |

[Ver en el tema](restricciones.md#ejercicio-3-crear-provincias)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 4: Crear ciudades</span></span> {#ejercicio-4-crear-ciudades}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, crea `ciudades` para registrar las ciudades y la provincia a la que pertenece cada una. Define su clave primaria y la clave ajena hacia `provincias`, que ya debe existir.

    **Modelo relacional**

    **CIUDADES** (<u>id_ciudad</u>, nombre, <mark>id_provincia</mark>)

    - PK: (id_ciudad)
    - FK: id_provincia → PROVINCIAS(id_provincia)

    **Campos de `ciudades`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_ciudad` | `SERIAL` |
    | `nombre` | `VARCHAR(100)` |
    | `id_provincia` | `INTEGER` |

[Ver en el tema](restricciones.md#ejercicio-4-crear-ciudades)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 5: Crear vendedores</span></span> {#ejercicio-5-crear-vendedores}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, crea `vendedores` para guardar los datos de los vendedores y la ciudad a la que están asociados. Define la clave primaria y la clave ajena hacia `ciudades`.

    **Modelo relacional**

    **VENDEDORES** (<u>id_vendedor</u>, nombre, direccion, codigo_postal, <mark>id_ciudad</mark>, <mark>id_jefe</mark>)

    - PK: (id_vendedor)
    - FK: id_ciudad → CIUDADES(id_ciudad)
    - FK: id_jefe → VENDEDORES(id_vendedor)

    El modelo incluye la relación reflexiva con el jefe. Añade la columna `id_jefe`, pero **deja pendiente su FK hasta el ejercicio 12**. Por ahora solo debes crear la FK de `id_ciudad`.

    **Campos de `vendedores`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_vendedor` | `SERIAL` |
    | `nombre` | `VARCHAR(150)` |
    | `direccion` | `VARCHAR(200)` |
    | `codigo_postal` | `VARCHAR(10)` |
    | `id_ciudad` | `INTEGER` |
    | `id_jefe` | `INTEGER` |

[Ver en el tema](restricciones.md#ejercicio-5-crear-vendedores)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 6: Crear jugadores</span></span> {#ejercicio-6-crear-jugadores}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, crea `jugadores` para guardar los datos de los clientes de la tienda. Define la clave primaria y la clave ajena hacia `ciudades`, siguiendo el modelo y los tipos indicados.

    **Modelo relacional**

    **JUGADORES** (<u>id_jugador</u>, nombre, direccion, codigo_postal, <mark>id_ciudad</mark>)

    - PK: (id_jugador)
    - FK: id_ciudad → CIUDADES(id_ciudad)

    **Campos de `jugadores`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_jugador` | `SERIAL` |
    | `nombre` | `VARCHAR(150)` |
    | `direccion` | `VARCHAR(200)` |
    | `codigo_postal` | `VARCHAR(10)` |
    | `id_ciudad` | `INTEGER` |

[Ver en el tema](restricciones.md#ejercicio-6-crear-jugadores)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 7: Crear compras</span></span> {#ejercicio-7-crear-compras}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, crea `compras` para registrar la fecha, el jugador que compra y el vendedor que lo atiende, junto con el IVA y el descuento. Define la clave primaria y las dos claves ajenas del modelo.

    **Modelo relacional**

    **COMPRAS** (<u>id_compra</u>, fecha, <mark>id_jugador</mark>, <mark>id_vendedor</mark>, iva, descuento)

    - PK: (id_compra)
    - FK: id_jugador → JUGADORES(id_jugador) <span class="tag-no-nulo">[no nulo]</span>
    - FK: id_vendedor → VENDEDORES(id_vendedor) <span class="tag-no-nulo">[no nulo]</span>

    Define `id_jugador` e `id_vendedor` como **NOT NULL**: toda compra debe estar asociada a un jugador y a un vendedor existentes.

    **Campos de `compras`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_compra` | `SERIAL` |
    | `fecha` | `DATE` |
    | `id_jugador` | `INTEGER` |
    | `id_vendedor` | `INTEGER` |
    | `iva` | `DECIMAL(5,2)` |
    | `descuento` | `DECIMAL(5,2)` |

[Ver en el tema](restricciones.md#ejercicio-7-crear-compras)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 8: Crear lineas_compra</span></span> {#ejercicio-8-crear-lineas_compra}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, crea `lineas_compra` para detallar los productos de cada compra, sus cantidades, precios y descuentos. Una compra puede tener varias líneas, identificadas por su número dentro de esa compra.

    **Modelo relacional**

    **LINEAS_COMPRA** (<u><mark>id_compra</mark>, num_linea</u>, <mark>id_producto</mark>, cantidad, precio_unitario, descuento_linea)

    - PK: (id_compra, num_linea)
    - FK: id_compra → COMPRAS(id_compra)
    - FK: id_producto → PRODUCTOS(id_producto) <span class="tag-no-nulo">[no nulo]</span>

    Declara la PK compuesta `(id_compra, num_linea)` como **restricción de tabla** y exige un valor en `id_producto`. El modelo muestra también las dos FK, pero **no las añadas todavía**: las incorporaremos en el ejercicio 13. No añadas otro código autonumérico.

    **Campos de `lineas_compra`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_compra` | `INTEGER` |
    | `num_linea` | `INTEGER` |
    | `id_producto` | `INTEGER` |
    | `cantidad` | `INTEGER` |
    | `precio_unitario` | `DECIMAL(10,2)` |
    | `descuento_linea` | `DECIMAL(5,2)` |

[Ver en el tema](restricciones.md#ejercicio-8-crear-lineas_compra)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 9: Añadir alias</span></span> {#ejercicio-9-anadir-alias}

!!! ejercicio "Juegos"

    Añade a `vendedores` una columna `alias VARCHAR(40) NOT NULL UNIQUE`. La tabla todavía está vacía; explica qué habría que preparar si ya tuviera filas.

[Ver en el tema](alter_table.md#ejercicio-9-anadir-alias)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 10: Eliminar alias</span></span> {#ejercicio-10-eliminar-alias}

!!! ejercicio "Juegos"

    Elimina la columna `alias`.

[Ver en el tema](alter_table.md#ejercicio-10-eliminar-alias)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 11: Añadir la PK de categorias</span></span> {#ejercicio-11-anadir-la-pk-de-categorias}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, utiliza `ALTER TABLE` para añadir a `categorias` la clave primaria que dejamos pendiente en el ejercicio 1. No vuelvas a crear la tabla.

    **Modelo relacional que debe quedar**

    **CATEGORIAS** (<u>id_categoria</u>, descripcion)

    - PK: (id_categoria)

[Ver en el tema](alter_table.md#ejercicio-11-anadir-la-pk-de-categorias)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 12: Completar productos y la relación reflexiva</span></span> {#ejercicio-12-completar-productos-y-la-relacion-reflexiva}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, completa con `ALTER TABLE` las claves pendientes de `productos` y la relación reflexiva de `vendedores`. Conserva sus columnas y las restricciones que ya tienen.

    **Modelos relacionales que deben quedar**

    **PRODUCTOS** (<u>id_producto</u>, nombre, precio, stock, stock_minimo, <mark>id_categoria</mark>)

    - PK: (id_producto)
    - FK: id_categoria → CATEGORIAS(id_categoria)

    **VENDEDORES** (<u>id_vendedor</u>, nombre, direccion, codigo_postal, <mark>id_ciudad</mark>, <mark>id_jefe</mark>)

    - PK: (id_vendedor)
    - FK: id_ciudad → CIUDADES(id_ciudad)
    - FK: id_jefe → VENDEDORES(id_vendedor)

    Añade la PK de `productos` y su FK hacia `categorias`. En `vendedores`, añade únicamente la FK de `id_jefe` hacia `id_vendedor`; la PK y la FK de `id_ciudad` ya existen. `id_jefe` debe admitir nulos para los vendedores sin jefe.

[Ver en el tema](alter_table.md#ejercicio-12-completar-productos-y-la-relacion-reflexiva)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 13: Añadir las FK de lineas_compra</span></span> {#ejercicio-13-anadir-las-fk-de-lineas_compra}

!!! ejercicio "Juegos"

    Desde la conexión **Juegos**, utiliza `ALTER TABLE` para completar las dos claves ajenas de `lineas_compra`, pendientes desde el ejercicio 8. Conserva la PK compuesta y la obligatoriedad de `id_producto`.

    **Modelo relacional que debe quedar**

    **LINEAS_COMPRA** (<u><mark>id_compra</mark>, num_linea</u>, <mark>id_producto</mark>, cantidad, precio_unitario, descuento_linea)

    - PK: (id_compra, num_linea)
    - FK: id_compra → COMPRAS(id_compra)
    - FK: id_producto → PRODUCTOS(id_producto) <span class="tag-no-nulo">[no nulo]</span>

    Define la FK hacia `compras` con **ON DELETE CASCADE**, para que al borrar una compra se borren sus líneas. La FK hacia `productos` debe usar **NO ACTION**. Al terminar, comprueba que Juegos tiene ocho PK y nueve FK.

[Ver en el tema](alter_table.md#ejercicio-13-anadir-las-fk-de-lineas_compra)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 14: Combinar dominio, tipo y restricciones</span></span> {#ejercicio-14-combinar-dominio-tipo-y-restricciones}

!!! ejercicio "Empresa"

    En la conexión **Empresa**, crea los objetos auxiliares necesarios para definir esta tabla y comprobar sus restricciones. Al terminar, elimina solo esos objetos de demostración.

    **Modelo relacional**

    **PRODUCTOS_DEMO** (<u>id_producto</u>, nombre, precio, stock, stock_minimo, codigo_barras, estado)

    - PK: (id_producto)

    Realiza estos pasos:

    1. **Crea el dominio `codigo_barras_demo`**, basado en `VARCHAR(13)`, para admitir únicamente textos formados por exactamente 13 dígitos.

    2. **Crea el tipo enumerado `estado_producto_demo`**, con los valores `Disponible`, `Agotado` y `En espera`.

    3. **Crea la tabla `productos_demo`** con los campos del modelo. Utiliza `SERIAL` en `id_producto` y decláralo como clave primaria. Aplica el dominio a `codigo_barras` y el tipo enumerado a `estado`.

    4. **Añade las validaciones**: precio, stock y stock mínimo deben ser no negativos. Define además `stock >= stock_minimo` como **restricción de tabla con nombre**.

    5. **Comprueba las restricciones** insertando una fila válida y varias que deban rechazarse. Ejecuta las inserciones por separado.

    6. **Reflexiona**: explica por qué en un inventario real puede ser útil permitir que el stock esté por debajo del mínimo.

    7. **Elimina los objetos de demostración**: primero la tabla y después el tipo enumerado y el dominio.

    El dominio solo comprueba el formato de 13 dígitos: no verifica el dígito de control del código de barras ni indica el país de fabricación.

[Ver en el tema](tipos_enumerados.md#ejercicio-14-combinar-dominio-tipo-y-restricciones)
