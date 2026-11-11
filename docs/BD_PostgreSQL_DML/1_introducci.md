# 1. DML: cargar y modificar los datos

En DDL has creado **mundomoviles** y **gamehub**, con sus tablas vacías. Ahora utilizarás `INSERT`, `UPDATE` y `DELETE`. Cada alumno mantiene sus propios datos en el [servidor Docker local](../entorno_postgresql.md).

## 1.1 Cargar primero MundoMoviles

Conéctate a `mundomoviles` en DBeaver y comprueba:

```sql
SELECT current_database();
```

Descarga [mundomoviles-datos.sql](../recursos/postgresql/sql/mundomoviles-datos.sql), ábrelo con esa conexión y ejecuta el archivo completo con **Alt+X**. Contiene únicamente inserciones, agrupadas en una transacción; no vuelve a crear las tablas.

Si usas la terminal del paquete Docker, esta es una alternativa a DBeaver:

```bash
docker compose exec -T postgres psql -U alumno -d mundomoviles -v ON_ERROR_STOP=1 -f /sql/mundomoviles-datos.sql
```

Ejecuta la carga una sola vez y verifica:

```sql
SELECT 'paises' AS tabla, COUNT(*) AS filas FROM paises
UNION ALL SELECT 'empresas', COUNT(*) FROM empresas
UNION ALL SELECT 'moviles', COUNT(*) FROM moviles;
```

Resultado: **4 países, 4 empresas y 8 móviles**.

## 1.2 Cargar después GameHub

Cambia a la conexión `gamehub`. Comprueba `SELECT current_database();`, abre [gamehub-datos.sql](../recursos/postgresql/sql/gamehub-datos.sql) y ejecútalo completo con **Alt+X**.

Alternativa desde la terminal:

```bash
docker compose exec -T postgres psql -U alumno -d gamehub -v ON_ERROR_STOP=1 -f /sql/gamehub-datos.sql
```

No ejecutes la alternativa de terminal si ya hiciste la carga en DBeaver.

```sql
SELECT 'provincias' AS tabla, COUNT(*) AS filas FROM provincias
UNION ALL SELECT 'ciudades', COUNT(*) FROM ciudades
UNION ALL SELECT 'categorias', COUNT(*) FROM categorias
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'jugadores', COUNT(*) FROM jugadores
UNION ALL SELECT 'vendedores', COUNT(*) FROM vendedores
UNION ALL SELECT 'compras', COUNT(*) FROM compras
UNION ALL SELECT 'lineas_compra', COUNT(*) FROM lineas_compra;
```

| Tabla | Filas esperadas |
| --- | ---: |
| provincias | 3 |
| ciudades | 6 |
| categorias | 4 |
| productos | 12 |
| jugadores | 8 |
| vendedores | 3 |
| compras | 12 |
| lineas_compra | 28 |

## 1.3 Evitar cargas duplicadas

Los archivos de datos se ejecutan sobre tablas vacías. Al ejecutarlos dos veces, las filas con claves generadas por secuencia pueden duplicarse y las líneas pueden fallar por su PK compuesta. Una transacción abortada no permite seguir ejecutando sentencias hasta `ROLLBACK`.

Si cometiste errores durante la carga, consulta el primer mensaje. Para recuperar los datos iniciales en **tu base local**, utiliza una sola de estas opciones:

- Crea una base nueva vacía y ejecuta su estructura y después sus datos.
- Si estás seguro de querer perder todos los datos de la base de prácticas, vacía **todas sus tablas** y reinicia sus secuencias antes de cargar de nuevo.

Para restablecer solo GameHub, conectado a `gamehub`:

```sql
TRUNCATE lineas_compra, compras, jugadores, vendedores,
         productos, categorias, ciudades, provincias RESTART IDENTITY;
```

Para restablecer solo MundoMoviles, conectado a `mundomoviles`:

```sql
TRUNCATE moviles, empresas, paises RESTART IDENTITY;
```

Estas sentencias eliminan los datos de las tablas indicadas. Después ejecuta únicamente el archivo `*-datos.sql` correspondiente. No uses `docker compose down -v`: borraría también las otras bases.

## 1.4 Conservar los datos para DQL

Realiza los ejercicios de modificación dentro de una transacción y termina con `ROLLBACK` cuando quieras conservar el conjunto inicial. Así las consultas y los resultados del tema DQL seguirán siendo reproducibles. Las secuencias pueden avanzar aunque se reviertan las filas: no supongas que los códigos nuevos son consecutivos.

Continúa con [INSERT, UPDATE y DELETE](2_consultes_dactualitzaci.md).
