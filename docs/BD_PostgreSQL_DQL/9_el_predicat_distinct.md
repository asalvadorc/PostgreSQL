# 9. El predicado DISTINCT

Por defecto, si no especificamos lo contrario, saldrán _todas_ las filas de la tabla o tablas que cumplan las condiciones. Así, por ejemplo, si de la tabla de juegos quisiéramos sacar únicamente el ID del estudio, nos saldría por ejemplo el 1 (Valve) en tantas filas como juegos de Valve tengamos (concretamente 3 en nuestros datos iniciales).

    SELECT ALL id_estudio  
      FROM juegos;

Este resultado no es el más útil si queremos una lista de "Estudios que tienen juegos en el catálogo". Sería mejor si saliera el ID 1 solo una vez. Esto lo conseguiremos con el predicado **DISTINCT**.

En definitiva lo que hará el predicado DISTINCT será sacar las filas distintas
del resultado que pedimos. Si sólo pedimos un campo, sacará los valores
diferentes de este campo. Si pedimos más de un campo, sacará los valores diferentes
para el conjunto de los campos (es decir las filas diferentes, que en un campo pueden
coincidir, pero no en el conjunto de todos los campos)

**<u>Sintaxis</u>**

    SELECT DISTINCT <columnas>  
      FROM <tablas>;

Así, en el ejemplo anterior:

    SELECT DISTINCT id_estudio  
      FROM juegos;

Existe una variante del DISTINCT que soporta PostgreSQL: poner el DISTINCT dentro de una función de agregado, como por ejemplo **COUNT**. El resultado es que contará los valores diferentes del campo.

Así, por ejemplo, si queremos contar cuántos estudios diferentes tienen juegos en el catálogo, la consulta es:

    SELECT COUNT(DISTINCT id_estudio)  
      FROM juegos;

**<u>Ejemplos</u>**

  1) Sacar las sedes (países/ciudades) donde se encuentran los estudios.

    SELECT DISTINCT sede  
      FROM estudios;

  2) Sacar los distintos géneros que tienen juegos asignados.

    SELECT DISTINCT id_genero  
      FROM juegos;

  3) Sacar las distintas combinaciones de estudio y género disponibles.

    SELECT DISTINCT id_estudio, id_genero  
      FROM juegos  
      ORDER BY 1;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **TecnoTienda**, conectando como usuario **tech_alu**:

**Ex_39** Sacar a los **empleados** que han realizado algún pedido en el mes de enero de 2024.

**Ex_40** Sacar los diferentes descuentos que se han aplicado en las líneas de pedido de cada empleado durante el mes de enero de 2024.

**Ex_41** Sacar los diferentes **jefes** de empleados (evite que aparezca el valor nulo).

**Ex_42** Sacar los diferentes descuentos que se han aplicado a los **productos** cuyo nombre comienza por 'RZ'. Sacar tanto el ID de producto como el descuento.

**Ex_43** Contar en cuántas **poblaciones** diferentes tenemos clientes.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

