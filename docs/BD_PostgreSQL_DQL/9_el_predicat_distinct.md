# 9. El predicado DISTINCT

Por defecto, si no especificamos lo contrario, saldrán _todas_ las filas de la tabla o tablas que cumplan las condiciones. Así, por ejemplo, si de la tabla de móviles quisiéramos sacar únicamente el ID de la empresa, nos saldría por ejemplo el 1 (Apple) en tantas filas como móviles de Apple tengamos (concretamente 3 en nuestros datos iniciales).

    SELECT ALL id_empresa  
      FROM moviles;

Este resultado no es el más útil si queremos una lista de "Empresas que tienen móviles en el catálogo". Sería mejor si saliera el ID 1 solo una vez. Esto lo conseguiremos con el predicado **DISTINCT**.

En definitiva lo que hará el predicado DISTINCT será sacar las filas distintas
del resultado que pedimos. Si sólo pedimos un campo, sacará los valores
diferentes de este campo. Si pedimos más de un campo, sacará los valores diferentes
para el conjunto de los campos (es decir las filas diferentes, que en un campo pueden
coincidir, pero no en el conjunto de todos los campos)

**<u>Sintaxis</u>**

    SELECT DISTINCT <columnas>  
      FROM <tablas>;

Así, en el ejemplo anterior:

    SELECT DISTINCT id_empresa  
      FROM moviles;

Existe una variante del DISTINCT que soporta PostgreSQL: poner el DISTINCT dentro de una función de agregado, como por ejemplo **COUNT**. El resultado es que contará los valores diferentes del campo.

Así, por ejemplo, si queremos contar cuántas empresas diferentes tienen móviles en el catálogo, la consulta es:

    SELECT COUNT(DISTINCT id_empresa)  
      FROM moviles;

**<u>Ejemplos</u>**

  1) Sacar las sedes (países/ciudades) donde se encuentran las empresas.

    SELECT DISTINCT sede  
      FROM empresas;

  2) Sacar los distintos países que tienen empresas registradas.

    SELECT DISTINCT id_pais  
      FROM empresas;

  3) Sacar las distintas combinaciones de país y sede de las empresas.

    SELECT DISTINCT id_pais, sede  
      FROM empresas  
      ORDER BY 1;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **GameHub**, conectando como usuario **alumno**:

**Ex_39** Sacar los **vendedores** que atendieron alguna compra en enero de 2024, sin repetirlos.

**Ex_40** Sacar los distintos **descuentos de línea** aplicados por cada vendedor en enero de 2024.

**Ex_41** Sacar los diferentes **jefes de vendedores**, evitando el valor nulo.

**Ex_42** Sacar los distintos descuentos de línea aplicados a productos cuyo nombre comienza por **RZ**, mostrando `id_producto` y `descuento_linea`.

**Ex_43** Contar en cuántas **ciudades** diferentes viven los jugadores.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

