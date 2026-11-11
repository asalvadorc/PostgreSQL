# 1. Introducción a DDL

Con **DDL** definirás la estructura de las bases de datos: tablas, columnas, claves y restricciones. Después, en **DML**, insertarás y modificarás los datos; finalmente, en **DQL**, los consultarás.

Antes de empezar, completa la preparación de [PostgreSQL con Docker Compose](../entorno_postgresql.md) y la [conexión con DBeaver](../BD_PostgreSQL_DQL/2_client_dbeaver_installaci_i_confiuraci.md), disponibles en Inicio. Debes tener el servidor local funcionando y una conexión a `postgres`.

## Orden de las prácticas

1. Estudia [CREATE, ALTER, DROP y otros objetos](2_ddl.md), utilizando `pruebas` para los ejemplos auxiliares.
2. Crea [MundoMoviles](3_crear_mundomoviles.md): tres tablas, con dos relaciones 1:N.
3. Crea [GameHub](4_crear_gamehub.md): ocho tablas, una clave compuesta y una relación reflexiva.
4. Completa los [ejercicios DDL](exercicis_de_tot_el_tema.md).

Al finalizar DDL tendrás las tablas creadas y **vacías**. La carga se realiza en [DML](../BD_PostgreSQL_DML/1_introducci.md), primero MundoMoviles y después GameHub. El contenedor no crea las tablas ni carga los datos automáticamente.

Guarda tus sentencias en `01_mundomoviles.sql` y `02_gamehub.sql`. El paquete de trabajo contiene el Compose y los datos; las soluciones completas de creación están separadas en el apartado Soluciones.
