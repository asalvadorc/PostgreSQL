# 5. Funciones de agregado

Las **funciones de agregado**, o funciones de dominio agregado, son aquellas que
sacan un resultado a partir de los valores de un determinado campo en un conjunto de
filas. Así tendremos una función para **sumar** los valores de una columna, o
**contar** -los, o sacar la **media** , o el **máximo** , ...

Actuarán sobre un conjunto de filas determinado, que en principio supondremos que
es toda la mesa (todas las filas de la mesa). En la siguiente pregunta, veremos
que el conjunto de filas sobre el que se calcula una función de agregado, el
podremos cambiar con la cláusula **GROUP BY**.

**<u>Sintaxi</u>**

  * **COUNT (* | <expressió> )**: cuenta el número de filas; si se pone una columna o expresión, no se contarán los valores nulos.

  * **SUM ( <expressió> )**: devuelve la suma de la columna o expresión especificada. Ignora los valores nulos.

  * **AVG ( <expressió> )**: calcula la media aritmética de la columna o expresión especificada. Ignora los valores nulos.

  * **VAR_SAMP ( <expressió> )**: calcula la varianza de una muestra a partir de la columna o expresión especificada.

  * **STDDEV ( <expressió> )**: desviación típica de una muestra.

  * **MAX ( <expressió> )**: calcula el máximo.

  * **MIN ( <expressió> )**: calcula el mínimo.

Por ejemplo, si queremos saber el número de juegos en la plataforma:

    SELECT COUNT(*) AS "Número de Juegos"  
      FROM juegos;


!!! note "Nota"
      Es interesante la utilización de alias, para que no aparezcan cabeceras como _**count**_
  

  1) Contar el número total de juegos registrados.

    SELECT Count(*)  
      FROM juegos;

  2) Contar el número de juegos del estudio con ID **1** (Valve).

    SELECT Count(*)  
      FROM juegos  
      WHERE id_estudio = 1;

  3) Calcular el precio medio de los juegos de los estudios **2** y **3**.

    SELECT AVG(precio)  
      FROM juegos  
      WHERE id_estudio = 2 OR id_estudio = 3;

  4) Calcular el precio medio de todos los juegos aplicando un descuento teórico del 10%.

    SELECT AVG(precio * 0.9)  
      FROM juegos;

  5) Calcular el precio máximo y mínimo de todos los juegos.

    SELECT MAX(precio), MIN(precio)  
      FROM juegos;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **TecnoTienda**, conectando como usuario **tech_alu**:

**Ex_15** Contar el número de **clientes** que tienen la **dirección nula** (o el código postal).

**Ex_16** Contar el número de veces que el producto **10** (id_producto) aparece en las **líneas de pedido**, y el número total de unidades vendidas de este producto. Solo le hace falta la tabla **lineas_pedido**.

**Ex_17** Sacar la **media** del **stock** de los productos.

**Ex_18** Modificar lo anterior para **tener en cuenta los valores nulos, como si fueran 0**. Utilice la función **COALESCE** de esta manera: `COALESCE(stock, 0)`.

**Ex_19** Contar **cuántos pedidos** tiene el cliente con ID **5**.

**Ex_20** Calcular el **descuento máximo**, el **mínimo** y el descuento **medio** de los **pedidos**.


Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

