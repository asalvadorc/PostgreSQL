# DBeaver: conexión y ejecución de SQL

**DBeaver Community** será el cliente con el que crearás tablas y ejecutarás consultas. PostgreSQL se ejecuta en el contenedor preparado en [PostgreSQL local con Docker Compose](../entorno_postgresql.md).

## Instalar y conectar

Descarga [DBeaver Community](https://dbeaver.io/download/) y crea una conexión PostgreSQL:

| Campo | Valor |
| --- | --- |
| Host | `localhost` |
| Puerto | `5433` |
| Usuario | `alumno` |
| Contraseña | `alumno` |
| Base de datos inicial | `postgres` |

Pulsa **Probar conexión**, descarga el controlador si se solicita y guarda. Después de crear las bases en DDL, configura otras dos conexiones: una a `mundomoviles` y otra a `gamehub`. Usa `pruebas` para los ejemplos que crean o borran objetos auxiliares.

## Trabajar en la base correcta

Abre un editor SQL desde la conexión que necesitas y verifica:

```sql
SELECT current_database(), current_user;
```

En los ejemplos de DQL debe aparecer `mundomoviles`; en los ejercicios, `gamehub`. Cambiar el nombre de la conexión no cambia la base a la que está conectada: revisa el campo **Base de datos**.

## Ejecutar sentencias y scripts

- **Ctrl+Enter** ejecuta la sentencia actual o el texto seleccionado.
- **Alt+X** ejecuta el script completo. Es el modo que debes usar para cargar los archivos de datos.
- Lee el primer error antes de continuar. Si una transacción queda abortada, ejecuta `ROLLBACK;`, corrige el problema y vuelve a intentar la carga en una base limpia.
- `CREATE DATABASE` se ejecuta por separado, con autocommit, conectado a `postgres`.

Para abrir un archivo SQL descargado, ábrelo desde el editor y selecciona la conexión correspondiente. Para ver las tablas, actualiza el navegador y despliega **Schemas → public → Tables**.

## Consultar resultados

El resultado de cada `SELECT` aparece en una pestaña. Revisa los nombres de las columnas, las filas y los valores nulos. Un resultado vacío puede ser correcto: compara los filtros con los datos realmente cargados, no con capturas de otra base de datos.
