# 10. La cláusula LIMIT .. OFFSET

Por medio de la cláusula **LIMIT - OFFSET** podremos hacer que no aparezcan todas
las filas que devuelve la sentencia, sino unas cuantas.

  * **LIMIT número** : especificaremos cuántas filas queremos que se devuelvan
  * **OFFSET número** : especificaremos a partir de qué posición queremos que se devuelvan las filas

Si no ponemos la parte del OFFSET, aparecerán las primeras, y si especificamos
OFFSET, se saltarán las primeras, tantas como se indica en OFFSET. Para que
realmente tenga sentido esta cláusula, es conveniente ordenar la información,
ya que al decir las primeras ya se está asumiendo que serán las primeras respeto
algún orden. Así, por ejemplo, nos podremos plantear sacar cosas como las
poblaciones más altas, o las más habitadas.

El orden implícito que acabamos de comentar deberá realizarse por medio de la cláusula
ORDER BY. Así, si queremos sacar a los jugadores más jóvenes tendremos que ordenar por la
fecha de nacimiento en orden descendente, para después sacar los primeros. Por
tanto es muy difícil ver una cláusula LIMIT si no tenemos una cláusula ORDER
BY.

!!! note "Nota"
    En SQL de Access no existe la cláusula LIMIT. Para hacer cosas similar
    dispone del predicado <b>TOP</b> , que se pone inmediatamente después del SELECT,
    pero siempre sacará las primeras, no tiene posibilidad de OFFSET.


**<u>Sintaxi</u>**

    SELECT <columnes>  
      FROM <taules>  
      [LIMITE _n_] [OFFSET _m_]

El número _**n**_ debe ser un entero, y se seleccionarán únicamente las _**n**_
primeras filas (las de arriba). En caso de puesto OFFSET se saltarán _**m**_
filas. En caso de no poner **LIMIT** , se saltarán _**m** _files y se sacarán
todas las demás hasta el final.

Por ejemplo, si queremos sacar los 10 móviles más caros, deberemos coger los 10 primeros, ordenando por precio en forma descendente:

    SELECT modelo, precio  
      FROM moviles  
      ORDER BY precio DESC  
      LIMIT 10;

Si quisiéramos saltar algunos resultados, podemos usar OFFSET. Por ejemplo, sacar los móviles del 4º al 13º más caros (saltando los 3 primeros):

    SELECT modelo, precio  
      FROM moviles  
      ORDER BY precio DESC  
      LIMIT 10 OFFSET 3;

Aunque es mejor asegurarse de que los valores no sean nulos si no queremos sorpresas:

    SELECT modelo, precio  
      FROM moviles  
      WHERE precio IS NOT NULL  
      ORDER BY precio DESC  
      LIMIT 10;

Si quisiéramos sacar todos los móviles excepto los 3 más caros, podemos poner OFFSET sin LIMIT:

    SELECT modelo, precio  
      FROM moviles  
      ORDER BY precio DESC  
      OFFSET 3;

**<u>Ejemplos</u>**

  1) Sacar los 5 móviles con mayor precio.

    SELECT modelo, precio  
      FROM moviles  
      ORDER BY precio DESC  
      LIMIT 5;

  2) Sacar las 4 empresas con más móviles en el catálogo.

    SELECT id_empresa, COUNT(*)  
      FROM moviles  
      GROUP BY id_empresa  
      ORDER BY 2 DESC  
      LIMIT 4;

  3) Sacar las 10 empresas con más móviles, saltándonos los 3 primeros.

    SELECT id_empresa, COUNT(*)  
      FROM moviles  
      GROUP BY id_empresa  
      ORDER BY 2 DESC  
      LIMIT 10 OFFSET 3;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **GameHub**, conectando como usuario **gamehub_alu**:

**Ex_44** Sacar toda la información de los dos **productos** más caros.

**Ex_45** Sacar las tres **ciudades** con más **jugadores**.

**Ex_46** Sacar el **vendedor** que ha atendido menos **compras**, incluyendo a quienes no han atendido ninguna.

**Ex_47** Sacar las tres **compras** con mayor base sin descuentos ni IVA, sumando `precio_unitario * cantidad` en sus líneas.

**Ex_48** Repetir lo anterior para sacar todas las compras excepto las tres de mayor base.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

