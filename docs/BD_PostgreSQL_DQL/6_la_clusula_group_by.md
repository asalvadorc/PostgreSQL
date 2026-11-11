# 6. La cláusula GROUP BY

Agrupa todas las filas con valores iguales de una o unas columnas

**<u>Sintaxi</u>**

    SELECT <columnes>  
      FROM <taules>  
      GROUP BY <columnes>

Por cada fila con valores iguales de las columnas de la cláusula **GROUP BY** ,
saca sólo una, es decir, las agrupa.

Las **funciones de agregado** cogen todo su sentido y potencia combinadas con **GROUP BY**: devolverán un valor por cada grupo. Así, por ejemplo, esta sentencia sacará cuántos juegos hay en cada estudio:

    SELECT id_estudio, COUNT(*)  
      FROM juegos  
      GROUP BY id_estudio;

> Si queremos excluir filas para que no entren en las agrupaciones, lo haremos por medio de la cláusula **WHERE**. Por ejemplo, contar solo los juegos con un precio superior a 30 € por cada estudio:

    SELECT id_estudio, COUNT(*)  
      FROM juegos  
      WHERE precio > 30  
      GROUP BY id_estudio;

Cuando tenemos agrupaciones de filas, bien porque utilizamos la cláusula GROUP BY, bien porque entre las columnas que se eligen en el SELECT hay alguna función de agregado, o ambas cosas a la vez, se pueden cometer errores con una relativa facilidad. Cuando hay una agrupación **todas las columnas que seleccionamos con el SELECT tendrán que estar en el GROUP BY, o bien estar dentro de una función de agregado**. De lo contrario nos dará error.

Por ejemplo, esta consulta funciona bien, puesto que nos dice el estudio y el número de juegos que tiene cada uno:

    SELECT id_estudio, COUNT(*)  
      FROM juegos  
      GROUP BY id_estudio;

Pero ésta no:

    SELECT id_estudio, COUNT(*), titulo  
      FROM juegos  
      GROUP BY id_estudio;

Es sintácticamente incorrecta: si agrupamos todos los juegos del mismo estudio, ¿cómo podemos sacar el título individual de cada juego en la misma fila?

Por ejemplo, esta consulta nos da el precio del juego más caro de cada estudio:

    SELECT id_estudio, MAX(precio)  
      FROM juegos  
      GROUP BY id_estudio;

Pero si intentamos sacar también el título del juego más caro de cada estudio:

    SELECT id_estudio, MAX(precio), titulo  
      FROM juegos  
      GROUP BY id_estudio;

Nos daría un error de sintaxis porque `titulo` no está en la cláusula GROUP BY ni en una función de agregado.

**<u>Ejemplos</u>**

  1) Contar el número de juegos de cada género.

    SELECT id_genero, COUNT(*)  
      FROM juegos  
      GROUP BY id_genero;

  2) Contar el número de estudios en cada sede (país/ciudad).

    SELECT sede, COUNT(*)  
      FROM estudios  
      GROUP BY sede;

  3) Calcular el precio máximo, mínimo y medio de los juegos de cada estudio.

    SELECT id_estudio, MAX(precio), MIN(precio), AVG(precio)  
      FROM juegos  
      GROUP BY id_estudio;

  4) Agrupar por múltiples campos: Contar productos por marca y categoría.

    SELECT marca, id_categoria, COUNT(*)  
      FROM productos  
      GROUP BY marca, id_categoria;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **TecnoTienda**, conectando como usuario **tech_alu**:

**Ex_21** Contar el número de **clientes** de cada **provincia**.

**Ex_22** Contar el número de **clientes** en cada **población** y **código postal**.

**Ex_23** Contar el número de **pedidos** de cada **empleado** a cada **cliente**.

**Ex_24** Contar el número de **pedidos** de cada trimestre. Para extraer el trimestre, podemos utilizar la función `TO_CHAR(fecha, 'Q')`.

**Ex_25** Calcular cuántas veces se ha vendido cada **producto** (en cuántas líneas aparece), la suma de unidades vendidas, la cantidad máxima y la cantidad mínima en un mismo pedido. (Utilice la tabla **lineas_pedido**).

**Ex_26** Contar el número de **productos** de cada **categoría** y su precio medio.

**Ex_27** Calcular el total de cada **pedido**, sin aplicar descuentos ni IVA. Solo hace falta la tabla **lineas_pedido**, sumando el resultado de multiplicar **precio_unitario** por **cantidad** agrupando por **id_pedido**.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

