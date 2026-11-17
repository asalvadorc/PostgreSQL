# Crear bases de datos

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


En [Inicio ya creamos la base de datos `pruebas` y su conexión](../crear_pruebas.md). La seguiremos utilizando para ejecutar los ejemplos de la teoría y experimentar con las sentencias SQL; no tienes que volver a crearla.

Ahora vamos a crear **`juegos`**, donde realizaremos los ejercicios del tema. **Construiremos esta base de datos poco a poco en los siguientes apartados**: primero crearemos las tablas, después incorporaremos sus claves y restricciones, y finalmente añadiremos índices y vistas. Conservaremos lo que hagamos en cada ejercicio para continuar en el siguiente.

Así tendremos dos espacios de trabajo: **`pruebas` para los ejemplos** y **`juegos` para los ejercicios de construcción de la base de datos**.

## Ejercicios: Crear Juegos y su conexión {#crear-juegos-y-su-conexion}

**Sigue los mismos pasos que utilizaste para crear `pruebas` en Inicio**, cambiando el nombre de la base de datos a `juegos`.

### Ejercicio 0: Preparar Juegos y su conexión

!!! ejercicio "Juegos"

    1. Desde la conexión a **postgres**, abre **Editor SQL → Nuevo script SQL** y ejecuta:

        ```sql
        CREATE DATABASE juegos;
        ```

    2. Actualiza **Bases de datos / Databases** y comprueba que aparece `juegos`. También puedes crearla en modo gráfico, como explicamos al [crear pruebas](../crear_pruebas.md#41-crear-la-base-de-datos): elige una de las dos opciones, no ambas.
    3. Crea una **nueva conexión PostgreSQL** siguiendo los [mismos pasos de la conexión a pruebas](../crear_pruebas.md#42-crear-la-conexion-a-pruebas). Mantén `localhost`, puerto `5433`, usuario y contraseña `alumno`, pero escribe **juegos** en el campo **Base de datos**. Guarda la conexión como **Juegos**.
    4. Abre un editor SQL desde esta nueva conexión y comprueba:

        ```sql
        SELECT current_database();
        ```

        El resultado debe ser **juegos**.

Si `juegos` ya existe, no vuelvas a crearla. Conserva esta conexión: la utilizarás para los ejercicios de construcción de Juegos. Los ejemplos de los recuadros **Pruébalo** de la teoría se realizan en `pruebas`, salvo que indiquen otra base de datos, como en esta actividad.

Por ahora solo hemos creado la base de datos y su conexión. Empezaremos a crear sus tablas en los [ejercicios 1 y 2 de CREATE TABLE](tablas.md#ejercicios-juegos).
