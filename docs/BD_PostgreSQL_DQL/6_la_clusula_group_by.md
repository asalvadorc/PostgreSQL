# 6. La cláusula GROUP BY

Agrupa todas las filas con valores iguales de una o unas columnas

**<u>Sintaxi</u>**

    SELECT <columnes>  
      FROM <taules>  
      GROUP BY <columnes>

Por cada fila con valores iguales de las columnas de la cláusula **GROUP BY** ,
saca sólo una, es decir, las agrupa.

Las **funciones de agregado** cogen todo su sentido y potencia combinadas con **GROUP BY**: devolverán un valor por cada grupo. Así, por ejemplo, esta sentencia sacará cuántos móviles hay en cada empresa:

    SELECT id_empresa, COUNT(*)  
      FROM moviles  
      GROUP BY id_empresa;

> Si queremos excluir filas para que no entren en las agrupaciones, lo haremos por medio de la cláusula **WHERE**. Por ejemplo, contar solo los móviles con un precio superior a 30 € por cada empresa:

    SELECT id_empresa, COUNT(*)  
      FROM moviles  
      WHERE precio > 30  
      GROUP BY id_empresa;

Cuando tenemos agrupaciones de filas, bien porque utilizamos la cláusula GROUP BY, bien porque entre las columnas que se eligen en el SELECT hay alguna función de agregado, o ambas cosas a la vez, se pueden cometer errores con una relativa facilidad. Cuando hay una agrupación **todas las columnas que seleccionamos con el SELECT tendrán que estar en el GROUP BY, o bien estar dentro de una función de agregado**. De lo contrario nos dará error.

Por ejemplo, esta consulta funciona bien, puesto que nos dice la empresa y el número de móviles que tiene cada una:

    SELECT id_empresa, COUNT(*)  
      FROM moviles  
      GROUP BY id_empresa;

Pero ésta no:

    SELECT id_empresa, COUNT(*), modelo  
      FROM moviles  
      GROUP BY id_empresa;

Es sintácticamente incorrecta: si agrupamos todos los móviles de la misma empresa, ¿cómo podemos sacar el modelo individual de cada móvil en la misma fila?

Por ejemplo, esta consulta nos da el precio del móvil más caro de cada empresa:

    SELECT id_empresa, MAX(precio)  
      FROM moviles  
      GROUP BY id_empresa;

Pero si intentamos sacar también el modelo del móvil más caro de cada empresa:

    SELECT id_empresa, MAX(precio), modelo  
      FROM moviles  
      GROUP BY id_empresa;

Nos daría un error de sintaxis porque `modelo` no está en la cláusula GROUP BY ni en una función de agregado.

**<u>Ejemplos</u>**

  1) Contar el número de empresas de cada país.

    SELECT id_pais, COUNT(*)  
      FROM empresas  
      GROUP BY id_pais;

  2) Contar el número de empresas en cada sede (país/ciudad).

    SELECT sede, COUNT(*)  
      FROM empresas  
      GROUP BY sede;

  3) Calcular el precio máximo, mínimo y medio de los móviles de cada empresa.

    SELECT id_empresa, MAX(precio), MIN(precio), AVG(precio)  
      FROM moviles  
      GROUP BY id_empresa;

  4) Agrupar por múltiples campos: Contar productos por categoría y nivel de stock.

    SELECT id_categoria, stock, COUNT(*)  
      FROM productos  
      GROUP BY id_categoria, stock;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **Juegos**, conectando como usuario **alumno**:

**Ex_21** Contar los **jugadores** de cada **provincia**, relacionando jugadores, ciudades y provincias.

**Ex_22** Contar los **jugadores** por **ciudad** y **código postal**.

**Ex_23** Contar las **compras** atendidas por cada **vendedor** a cada **jugador**.

**Ex_24** Contar las **compras** de cada trimestre usando `TO_CHAR(fecha, 'Q')`.

**Ex_25** Para cada **producto**, contar sus líneas de compra, sumar las unidades vendidas y calcular las cantidades máxima y mínima en una línea.

**Ex_26** Contar los **productos** de cada **categoría** y calcular su precio medio.

**Ex_27** Calcular la base de cada **compra**, sin descuentos ni IVA, sumando `precio_unitario * cantidad` en **lineas_compra** y agrupando por `id_compra`.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

