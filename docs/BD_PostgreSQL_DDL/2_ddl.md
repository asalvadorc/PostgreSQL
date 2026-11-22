# 2. Definición de Datos (DDL) en PostgreSQL

**DDL** (*Data Definition Language*) permite crear, modificar y eliminar bases de datos, tablas, restricciones y otros objetos. `CREATE` crea, `ALTER` modifica y `DROP` elimina. 

!!! warning "Antes de empezar: conecta a empresa y ejecuta los ejemplos"
    Abre un editor SQL desde la conexión **Empresa** de DBeaver. Comprueba que estás en la base correcta ejecutando:

    ```sql
    SELECT current_database();
    ```

    El resultado debe ser **empresa**. **No te limites a leer los ejemplos: escribe y ejecuta cada sentencia**, observa el resultado y revisa los cambios en las tablas. Todos los ejemplos de este apartado se realizan en **empresa**, siguiendo el orden en que aparecen.

**Cómo leer los bloques de sintaxis**

Los bloques de **sintaxis** sirven como referencia: sustituye los nombres genéricos y elige las opciones que necesites. No se ejecutan literalmente.

| Notación | Significado |
| --- | --- |
| `[ ... ]` | Parte opcional. |
| `{ opcion1 \| opcion2 }` | Debes elegir una de las alternativas. |
| `[, ...]` | Se pueden repetir elementos separados por comas. |
| `[esquema.]nombre` | El esquema es opcional; en nuestro entorno se utiliza `public` por defecto. Por ejemplo, `public.productos_demo`. |

Los recuadros **Pruébalo** contienen las sentencias concretas que sí debes ejecutar, en el orden indicado.

## 2.1 Bases de datos y esquemas

- [Crear bases de datos](crear_bases_datos.md)
- [Esquemas](esquemas.md)

## 2.2 Gestión de tablas

- [Tipos de datos](tipos_datos.md)
- [CREATE TABLE](tablas.md)
- [Restricciones](restricciones.md)
- [ALTER TABLE](alter_table.md)
- [DROP TABLE](drop_table.md)

## 2.3 Dominios y tipos enumerados

- [Dominios](dominios.md)
- [Tipos enumerados](tipos_enumerados.md)

## Otros contenidos del tema

- [Usuarios y privilegios](3_usuarios_roles_privilegios.md)

Los [índices](../BD_PostgreSQL_DQL/indices.md), las [vistas](../BD_PostgreSQL_DQL/vistas.md) y las [secuencias](../BD_PostgreSQL_DQL/secuencias.md) se estudiarán en un bloque específico de DQL.

**Referencias de sintaxis**

- [Gestión de bases de datos y objetos: material de referencia](https://nbeltran-gva.github.io/asgbd/ud3/03-basesdatos-objetos/).
- [Órdenes SQL de PostgreSQL 17](https://www.postgresql.org/docs/17/sql-commands.html), con las variantes completas, incluidas opciones avanzadas de particionamiento y almacenamiento.
