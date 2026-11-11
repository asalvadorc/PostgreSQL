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

Por ejemplo, si queremos saber el número de móviles en la plataforma:

    SELECT COUNT(*) AS "Número de Juegos"  
      FROM moviles;


!!! note "Nota"
      Es interesante la utilización de alias, para que no aparezcan cabeceras como _**count**_
  

  1) Contar el número total de móviles registrados.

    SELECT Count(*)  
      FROM moviles;

  2) Contar el número de móviles de la empresa con ID **1** (Apple).

    SELECT Count(*)  
      FROM moviles  
      WHERE id_empresa = 1;

  3) Calcular el precio medio de los móviles de las empresas **2** y **3**.

    SELECT AVG(precio)  
      FROM moviles  
      WHERE id_empresa = 2 OR id_empresa = 3;

  4) Calcular el precio medio de todos los móviles aplicando un descuento teórico del 10%.

    SELECT AVG(precio * 0.9)  
      FROM moviles;

  5) Calcular el precio máximo y mínimo de todos los móviles.

    SELECT MAX(precio), MIN(precio)  
      FROM moviles;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **GameHub**, conectando como usuario **alumno**:

**Ex_15** Contar los **jugadores** con la dirección o el código postal nulos.

**Ex_16** Contar cuántas veces aparece el producto **10** en **lineas_compra** y sumar sus unidades vendidas.

**Ex_17** Calcular la media del **stock** de los productos.

**Ex_18** Repetir lo anterior tratando los valores nulos como 0 mediante `COALESCE(stock, 0)`.

**Ex_19** Contar cuántas **compras** tiene el jugador con ID **5**.

**Ex_20** Calcular el **descuento máximo**, **mínimo** y **medio** de las **compras**.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

