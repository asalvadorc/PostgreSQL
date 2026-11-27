---
hide:
  - toc
---

# Dominios

Un dominio reutiliza un tipo de dato y sus restricciones en distintas columnas. `CREATE DOMAIN` lo define; `ALTER DOMAIN` cambia sus valores por defecto o sus restricciones, y `DROP DOMAIN` lo elimina, teniendo en cuenta los objetos que lo utilizan.

!!! quote sintaxis "Sintaxis básica"

    <div class="syntax-table-wrap">
    <table class="syntax-table syntax-completa">
    <tbody>
    <tr><td><code>CREATE DOMAIN [<span class="ddl-table">esquema</span>.]<span class="ddl-table">nombre</span> AS <span class="ddl-type">tipo_dato</span></code><br/><code>    [ <span class="ddl-default">DEFAULT</span> <span class="ddl-default">expresion</span> ]</code><br/><code>    [ <span class="ddl-constraint">NOT NULL</span> ]</code><br/><code>    [ [ <span class="ddl-constraint">CONSTRAINT</span> <span class="ddl-constraint">nombre_restriccion</span> ] <span class="ddl-constraint">CHECK</span> (<span class="ddl-constraint">condicion</span>) ];</code></td></tr>
    <tr><td><code>ALTER DOMAIN [<span class="ddl-table">esquema</span>.]<span class="ddl-table">nombre</span></code><br/><code>    { <span class="ddl-option">SET</span> <span class="ddl-default">DEFAULT</span> <span class="ddl-default">expresion</span></code><br/><code>    | <span class="ddl-option">DROP</span> <span class="ddl-default">DEFAULT</span></code><br/><code>    | <span class="ddl-option">SET</span> <span class="ddl-constraint">NOT NULL</span></code><br/><code>    | <span class="ddl-option">DROP</span> <span class="ddl-constraint">NOT NULL</span></code><br/><code>    | <span class="ddl-option">ADD</span> [ <span class="ddl-constraint">CONSTRAINT</span> <span class="ddl-constraint">nombre</span> ] <span class="ddl-constraint">CHECK</span> (<span class="ddl-constraint">condicion</span>)</code><br/><code>    | <span class="ddl-option">DROP</span> <span class="ddl-constraint">CONSTRAINT</span> <span class="ddl-constraint">nombre</span> };</code></td></tr>
    <tr><td><code>DROP DOMAIN [ <span class="ddl-option">IF EXISTS</span> ] [<span class="ddl-table">esquema</span>.]<span class="ddl-table">nombre</span> [, ...]</code><br/><code>    [ <span class="ddl-option">CASCADE</span> | <span class="ddl-option">RESTRICT</span> ];</code></td></tr>
    </tbody></table>
    </div>

    **Opciones**

    **<code>CREATE DOMAIN</code>**

    - <code><span class="ddl-default">DEFAULT</span></code>: valor por defecto.
    - <code><span class="ddl-constraint">NOT NULL</span></code>: exige un valor.
    - <code><span class="ddl-constraint">CHECK</span></code>: comprueba una condición sobre <code><span class="ddl-option">VALUE</span></code>.
    - <code><span class="ddl-constraint">CONSTRAINT</span></code>: asigna un nombre a la restricción.

    **<code>ALTER DOMAIN</code>**

    - <code><span class="ddl-option">SET</span> / <span class="ddl-option">DROP</span></code>: establece o elimina el valor por defecto o la obligatoriedad.
    - <code><span class="ddl-option">ADD</span> / <span class="ddl-option">DROP</span> <span class="ddl-constraint">CONSTRAINT</span></code>: añade o elimina restricciones.

    **<code>DROP DOMAIN</code>**

    - <code><span class="ddl-option">IF EXISTS</span></code>: evita el error si no existe.
    - <code><span class="ddl-option">RESTRICT</span></code>: impide borrar si hay dependencias (por defecto).
    - <code><span class="ddl-option">CASCADE</span></code>: elimina también objetos dependientes.


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

Actualiza la conexión **Empresa** y despliega las tablas. Esta imagen orientativa muestra el estado al terminar el ejemplo:

![Empresa tras eliminar promociones_demo y porcentaje_demo: las cinco tablas originales se conservan](../img/empresa/07-empresa-completa.png){ width="800" }


La práctica que combina un dominio con un tipo enumerado se realizará en el [ejercicio 14 del apartado siguiente](tipos_enumerados.md#ejercicios-juegos). Conserva esa actividad para después de estudiar los tipos enumerados.
