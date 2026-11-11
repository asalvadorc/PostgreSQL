# 11. Crear una tabla a partir de una consulta

Después de estudiar DDL y DML, puedes utilizar el resultado de un `SELECT` para crear una copia de trabajo. PostgreSQL admite `SELECT ... INTO`, pero para crear tablas suele ser más claro `CREATE TABLE ... AS SELECT`.

```sql
CREATE TEMP TABLE empresas_copia AS
SELECT * FROM empresas;

SELECT * FROM empresas_copia;
DROP TABLE empresas_copia;
```

Ejecuta el ejemplo en `mundomoviles`. `TEMP` limita la tabla a la sesión actual. Los campos y los datos proceden de la consulta; no se copian automáticamente las PK, FK, índices o valores por defecto de las tablas originales.

Otro ejemplo en MundoMoviles:

```sql
CREATE TEMP TABLE resumen_empresas AS
SELECT id_empresa, COUNT(*) AS moviles,
       MIN(precio) AS precio_minimo, MAX(precio) AS precio_maximo
FROM moviles
GROUP BY id_empresa;

SELECT * FROM resumen_empresas ORDER BY id_empresa;
DROP TABLE resumen_empresas;
```

Puedes utilizar alias para definir nombres de columnas legibles. Si la tabla destino ya existe, PostgreSQL devuelve un error; no abre un diálogo para reemplazarla. Para preparar la consulta, ejecuta primero solo el `SELECT` y comprueba sus resultados.

## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **GameHub**, conectando como usuario **alumno**:

**Ex_49** Crear **PRODUCTO_999x**, sustituyendo 999 por las tres últimas cifras de tu DNI y x por su letra, como copia de **productos**, con los nulos de `stock` y `stock_minimo` sustituidos por 0 mediante `COALESCE`.

**Ex_50** Usar la tabla anterior para calcular el máximo, mínimo y media de **stock**. Comparar con **productos**, donde los valores nulos no entran en los cálculos.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

