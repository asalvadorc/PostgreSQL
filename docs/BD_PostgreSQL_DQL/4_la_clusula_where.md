# 4. La cláusula WHERE

Nos servirá para establecer filtros. Sólo saldrán las filas que satisfagan la
condición del filtro.

**<u>Sintaxi</u>**


    SELECT <columnes>  
      FROM <taules>  
      WHERE <condició>;

La condición podrá ser una o más de una, unidas en este caso por los operadores
lógicos **AND** , **OR** y **NOT**. Cada condición será una comparación entre
expresiones, donde pueden entrar columnas, constantes, parámetros, funciones válidas
de PostgreSQL, ... unidas por operadores aritméticos. Los operadores que se pueden
utilizar para hacer las comparaciones son:

![](where.png)
<!--
  * **<  <=    =   >= > <> (!=)** (distinto)

  * **BETWEEN** _valor1_**AND** _valor2_ (los valores comprendidos entre valor1 y valor2)

  * **IN** (_lista_de_valors_) si el valor con el que se compara está en la lista de valores (entre paréntesis y valores separados por comas)

  * También podemos utilizar **LIKE** en la condición. En los ejemplos 4, 7 y 8 se ve su utilización. El operador LIKE se utiliza junto con los caracteres "**comodino**": 
  * **%** (equivale a 0 o más caracteres, los que sea)
  * **_** (1 y sólo un carácter, eso sí, lo que sea).

  * **IS [NOT]** es un operador especial para comparar con el valor nulo (**NULL**).
-->
Recordemos por otro lado cómo se escriben las constantes:

  * las constantes **numéricas** van tal cual, sin comillas ni nada (con el **punto** decimal, y no coma decimal)

  * las constantes **alfanuméricas** (de texto) van entre comillas simples

  * las constantes de fecha van entre comillas simples, y PostgreSQL ya hará la conversión

  * por último el valor nulo se escribe **NULL**

**<u>Ejemplos</u>**

1) Sacar las empresas cuya sede está en **Japón**.

    SELECT *  
      FROM empresas  
      WHERE sede LIKE '%Japón%';

2) Sacar todas las empresas de **Corea del Sur** (id_pais = 2).

    SELECT *  
      FROM empresas  
      WHERE id_pais = 2;

3) Sacar los móviles de la empresa **Xiaomi** con un precio superior a **40 €**.

    SELECT *  
      FROM moviles  
      WHERE id_empresa = 3 AND precio > 40;

4) Sacar los productos de las categorías **1, 2 o 3**.

    SELECT *  
      FROM productos  
      WHERE id_categoria = 1 OR id_categoria = 2 OR id_categoria = 3;

    SELECT *  
      FROM productos  
      WHERE id_categoria >= 1 AND id_categoria <= 3;

    SELECT *  
      FROM productos  
      WHERE id_categoria BETWEEN 1 AND 3;

    SELECT *  
      FROM productos  
      WHERE id_categoria IN (1, 2, 3);

5) Sacar los móviles de la empresa **O'Reilly Mobile** (Ejemplo de cómo manejar la comilla simple doblándola).

    SELECT *  
      FROM empresas  
      WHERE nombre = 'O''Reilly Mobile';

6) Sacar el modelo de los móviles que comienzan por **i**.

    SELECT modelo  
      FROM moviles  
      WHERE modelo LIKE 'i%';

7) Sacar los móviles que tienen exactamente **5** caracteres en su modelo (usando `_`).

    SELECT *  
      FROM moviles  
      WHERE modelo LIKE '_____';

8) Sacar todos los móviles cuyo modelo solo consta de una palabra (no tienen espacios en blanco).

    SELECT *  
      FROM moviles  
      WHERE modelo NOT LIKE '% %';

9) Sacar a los vendedores que no tienen asignado un jefe (id_jefe es nulo).

    SELECT *  
      FROM vendedores  
      WHERE id_jefe IS NULL;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **GameHub**, conectando como usuario **alumno**:

**Ex_7** Sacar los **jugadores** que viven en la ciudad **Madrid**. Consultar `ciudades` para localizar su código.

**Ex_8** Sacar todas las **compras** de marzo de 2024.

**Ex_9** Sacar los **productos** de la categoría **Consolas** con un **stock** entre **2 y 7** unidades. Localizar el código en `categorias`.

**Ex_10** Sacar los **jugadores** que no tienen introducida la **dirección**.

**Ex_11** Sacar los **productos** con `stock` informado y `stock_minimo` nulo.

**Ex_12** Sacar los **jugadores** cuyo nombre completo contiene el apellido **Villalonga**.

**Ex_13** Sacar los jugadores cuyo nombre completo **no** contiene el apellido **Villalonga**.

**Ex_14** Sacar los **productos** cuyo nombre comienza por **RZ**, cuyo **precio** está entre **20 y 100 €** y cuyo **stock** supera el **stock mínimo**.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

