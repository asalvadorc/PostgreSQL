---
hide:
  - toc
---

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


En [Inicio creamos la base de datos `pruebas`](../crear_pruebas.md) ejecutando `CREATE DATABASE pruebas;` desde la conexión a `postgres`. **No vuelvas a crearla si ya existe.** La creación se ejecuta como sentencia independiente, fuera de un bloque de transacción. También puede realizarse desde el modo gráfico de DBeaver, como vimos en ese apartado.

Crear una base de datos no cambia automáticamente la conexión del editor SQL. Para los ejemplos siguientes utiliza la conexión a **pruebas** y comprueba su destino con `SELECT current_database();`.
