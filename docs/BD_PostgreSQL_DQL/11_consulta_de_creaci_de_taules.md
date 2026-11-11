
# 11. Consulta de creación de tablas


Aparte de poder consultar información de una o más de una tabla, la sentencia
SELECT puede servir para crear una nueva tabla, con estructura y datos (los que
vienen de la propia sentencia SELECT). Eso sí, no podremos definir de ésta
modo ni clave principal, ni claves externas, ni ninguna otra restricción de las
conocidas.

Además, esta característica escapa del estándar ANSI SQL, por lo que
no le daremos excesiva importancia.

**<u>Sintaxi</u>**

    SELECT <columnes> INTO nueva_tabla  
      FROM <taules>

La sentencia puede llevar cualquier cláusula o predicado de los vistos hasta ahora, y el
resultado que dé esta sentencia, se guardará en una nueva mesa, con el nombre
especificado.

El nombre de los campos de la nueva tabla serán los especificados en el apartado
<columnes>. Por tanto es especialmente recomendable la utilización de alias, ya
que si lo ponemos serán el nombre de los campos de la nueva mesa.

Los tipos de datos de los campos serán los heredados de la consulta SELECT.

En caso de existir ya una tabla con el nombre especificado nos avisará de este hecho,
dándonos la posibilidad de borrar la tabla anterior y crear la nueva o
cancelar.
!!! note "Nota"
    Es muy recomendable, como otras sentencias de manipulación de datos que
    veremos más adelante, ejecutar primero la sentencia sin el <b>INTO</b> , para
    no crear la mesa todavía. Cuando estemos seguros de que el resultado es el que
    deseamos, añadimos el INTO, y la mesa se creará a más garantías.


**<u>Ejemplos</u>**

  1) Crear una copia de la tabla **estudios** llamada **estudios_copia**.

    SELECT * INTO estudios_copia  
      FROM estudios;

Para no "ensuciar" la Base de Datos, podemos borrarla después de haber visto
su creación con la sentencia

    DROP TABLE COMARCAS_COPIA

  2) Crear una tabla llamada **RESUM_COMARQUES** que contenga el nombre de la comarca, el número de pueblos, el total de población y la altura media

    SELECT nombre_c, COUNT(*) AS num_pueblos, SUM(poblacion) AS poblacion , SUM(extension) AS extension , AVG(altura) AS altura_media INTO RESUMEN_COMARCAS  
      FROM POBLACIONES  
      GROUP BY nombre_c

Al igual que en lo anterior, después de haber visto su creación y contenido,
podemos borrarla con la sentencia

  DROP TABLE RESUMEN_COMARCAS


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **TecnoTienda**, conectando como usuario **tech_alu**:

**Ex_49** Crear una tabla llamada **PRODUCTO_999x**, donde 999 deben ser las 3 últimas cifras de tu DNI, y x la letra, que sea una copia de la tabla **productos**, pero sustituyendo los valores nulos de **stock** y **stock_min** por ceros utilizando `COALESCE`.

**Ex_50** Utilizar la tabla anterior para sacar el stock máximo, el mínimo y la media de stocks. Observa que si utilizas la tabla **productos** original, los resultados no serían los mismos (especialmente la media), ya que los valores nulos no entrarían en los cálculos.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

