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


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 1: Crear categorias</span></span> {#ejercicio-1-crear-categorias}

!!! ejercicio "Juegos"

    **Campos de `categorias`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_categoria` | `SERIAL` |
    | `descripcion` | `VARCHAR(100)` |

    Crea `categorias` con los campos y tipos indicados arriba. Utiliza `SERIAL` en `id_categoria`, pero no añadas todavía la clave primaria ni otras restricciones explícitas.

[Ver en el tema](tablas.md#ejercicio-1-crear-categorias)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 2: Crear productos</span></span> {#ejercicio-2-crear-productos}

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

[Ver en el tema](tablas.md#ejercicio-2-crear-productos)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 3: Crear provincias</span></span> {#ejercicio-3-crear-provincias}

!!! ejercicio "Juegos"

    **Campos de `provincias`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_provincia` | `SERIAL` |
    | `nombre` | `VARCHAR(100)` |

    Crea `provincias` con sus dos campos y define `id_provincia` como clave primaria.

[Ver en el tema](restricciones.md#ejercicio-3-crear-provincias)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 4: Crear ciudades</span></span> {#ejercicio-4-crear-ciudades}

!!! ejercicio "Juegos"

    **Campos de `ciudades`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_ciudad` | `SERIAL` |
    | `nombre` | `VARCHAR(100)` |
    | `id_provincia` | `INTEGER` |

    Crea `ciudades`. Define `id_ciudad` como clave primaria y `id_provincia` como clave ajena hacia `provincias(id_provincia)`.

[Ver en el tema](restricciones.md#ejercicio-4-crear-ciudades)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 5: Crear vendedores</span></span> {#ejercicio-5-crear-vendedores}

!!! ejercicio "Juegos"

    **Campos de `vendedores`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_vendedor` | `SERIAL` |
    | `nombre` | `VARCHAR(150)` |
    | `direccion` | `VARCHAR(200)` |
    | `codigo_postal` | `VARCHAR(10)` |
    | `id_ciudad` | `INTEGER` |
    | `id_jefe` | `INTEGER` |

    Crea `vendedores` con su clave primaria y la clave ajena `id_ciudad` hacia `ciudades(id_ciudad)`. Incluye la columna `id_jefe`, pero **deja pendiente su clave ajena reflexiva** hasta el ejercicio 12.

[Ver en el tema](restricciones.md#ejercicio-5-crear-vendedores)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 6: Crear jugadores</span></span> {#ejercicio-6-crear-jugadores}

!!! ejercicio "Juegos"

    **Campos de `jugadores`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_jugador` | `SERIAL` |
    | `nombre` | `VARCHAR(150)` |
    | `direccion` | `VARCHAR(200)` |
    | `codigo_postal` | `VARCHAR(10)` |
    | `id_ciudad` | `INTEGER` |

    Crea `jugadores` con su clave primaria y la clave ajena `id_ciudad` hacia `ciudades(id_ciudad)`.

[Ver en el tema](restricciones.md#ejercicio-6-crear-jugadores)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 7: Crear compras</span></span> {#ejercicio-7-crear-compras}

!!! ejercicio "Juegos"

    **Campos de `compras`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_compra` | `SERIAL` |
    | `fecha` | `DATE` |
    | `id_jugador` | `INTEGER` |
    | `id_vendedor` | `INTEGER` |
    | `iva` | `DECIMAL(5,2)` |
    | `descuento` | `DECIMAL(5,2)` |

    Crea `compras` con su clave primaria y las claves ajenas hacia `jugadores` y `vendedores`. Define `id_jugador` e `id_vendedor` como **NOT NULL**: toda compra debe tener un jugador y un vendedor.

[Ver en el tema](restricciones.md#ejercicio-7-crear-compras)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 8: Crear lineas_compra</span></span> {#ejercicio-8-crear-lineas_compra}

!!! ejercicio "Juegos"

    **Campos de `lineas_compra`**

    | Campo | Tipo de dato |
    | --- | --- |
    | `id_compra` | `INTEGER` |
    | `num_linea` | `INTEGER` |
    | `id_producto` | `INTEGER` |
    | `cantidad` | `INTEGER` |
    | `precio_unitario` | `DECIMAL(10,2)` |
    | `descuento_linea` | `DECIMAL(5,2)` |

    Crea `lineas_compra` con la clave primaria compuesta `(id_compra, num_linea)` y con `id_producto` obligatorio. **No añadas todavía ninguna de sus dos claves ajenas**: las incorporarás en el ejercicio 13. La PK compuesta debe declararse como restricción de tabla.

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

    Añade mediante `ALTER TABLE` la clave primaria de `categorias`, que debe estar formada por `id_categoria`.

[Ver en el tema](alter_table.md#ejercicio-11-anadir-la-pk-de-categorias)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 12: Completar productos y la relación reflexiva</span></span> {#ejercicio-12-completar-productos-y-la-relacion-reflexiva}

!!! ejercicio "Juegos"

    En `productos`, añade la clave primaria sobre `id_producto` y la clave ajena `id_categoria` hacia `categorias(id_categoria)`. Completa también la relación reflexiva pendiente: `vendedores.id_jefe` debe referenciar a `vendedores.id_vendedor` y admitir nulos para los vendedores sin jefe.

[Ver en el tema](alter_table.md#ejercicio-12-completar-productos-y-la-relacion-reflexiva)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 13: Añadir las FK de lineas_compra</span></span> {#ejercicio-13-anadir-las-fk-de-lineas_compra}

!!! ejercicio "Juegos"

    Añade las FK de `lineas_compra`: hacia `compras` con `ON DELETE CASCADE`, y hacia `productos` con `NO ACTION`. Revisa que hay ocho PK y nueve FK.

[Ver en el tema](alter_table.md#ejercicio-13-anadir-las-fk-de-lineas_compra)


## <span class="exercise-title"><span class="exercise-icon">📝</span><span>Ejercicio 14: Combinar dominio, tipo y restricciones</span></span> {#ejercicio-14-combinar-dominio-tipo-y-restricciones}

!!! ejercicio "Empresa"

    Trabaja en la base de datos **`empresa`** y realiza estos pasos:

    1. **Crea el dominio `codigo_barras_demo`**, basado en `VARCHAR(13)`, para admitir únicamente textos formados por exactamente 13 dígitos.

    2. **Crea el tipo enumerado `estado_producto_demo`**, con los valores `Disponible`, `Agotado` y `En espera`.

    3. **Crea la tabla `productos_demo`** con código, nombre, precio, stock, stock mínimo, código de barras y estado. Utiliza el dominio y el tipo enumerado que acabas de definir.

    4. **Añade las validaciones**: precio, stock y stock mínimo deben ser no negativos. Define además `stock >= stock_minimo` como **restricción de tabla con nombre**.

    5. **Comprueba las restricciones** insertando una fila válida y varias que deban rechazarse. Ejecuta las inserciones por separado.

    6. **Reflexiona**: explica por qué en un inventario real puede ser útil permitir que el stock esté por debajo del mínimo.

    7. **Elimina los objetos de demostración**: primero la tabla y después el tipo enumerado y el dominio.

    El dominio solo comprueba el formato de 13 dígitos: no verifica el dígito de control del código de barras ni indica el país de fabricación.

[Ver en el tema](tipos_enumerados.md#ejercicio-14-combinar-dominio-tipo-y-restricciones)
