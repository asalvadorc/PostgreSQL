# 7. La cláusula HAVING
![alt text](image.png)

Esta cláusula acompaña normalmente a la de **GROUP BY**, y servirá pera
poder elegir algunos grupos que cumplan una determinada condición.

**Funciones numéricas**{.azul}

También podríamos decir que el HAVING está en el GROUP BY, lo que el WHERE está en el SELECT

**<u>Sintaxi</u>**

    SELECT <columnes>  
      FROM <taules>  
      [GROUP BY <columnes>]  
      HAVING <condició>

Únicamente comentaremos el caso en el que acompaña al GROUP BY. Y como hemos dicho, el
que hace es filtrar los grupos: de los grupos resultantes del GROUP BY, sólo saldrán
quienes cumplan la condición.

Esta condición contendrá alguna función de agregado o contendrá columnas
incluidas en el GROUP BY. Fíjese que es lógico, ya que sirve para elegir
grupos una vez hechos, y entonces ya no se podrá ir a un elemento del grupo.

Por ejemplo, esta sentencia servirá para sacar las empresas que tienen más de 2 móviles registrados en la plataforma:

    SELECT id_empresa, COUNT(*)  
      FROM moviles  
      GROUP BY id_empresa  
      HAVING COUNT(*) > 2;

**<u>Ejemplos</u>**

  1) Sacar aquellas empresas que tienen más de un móvil que comienza por la palabra 'iPhone'. De momento solo sacaremos el ID de la empresa.

    SELECT id_empresa, COUNT(*)  
      FROM moviles  
      WHERE modelo LIKE 'iPhone%'  
      GROUP BY id_empresa  
      HAVING COUNT(*) > 1;

  2) Calcular el precio máximo, el mínimo y el precio medio de los móviles de aquellas empresas que tienen más de 2 móviles en el catálogo.

    SELECT id_empresa, COUNT(*) AS "Número de móviles", MAX(precio) AS Máximo, MIN(precio) AS Mínimo, AVG(precio) AS Media  
      FROM moviles  
      GROUP BY id_empresa  
      HAVING COUNT(*) > 2;

  3) Sacar el precio medio de aquellas empresas cuya media de precios de móviles es superior a 50 €.

    SELECT id_empresa, AVG(precio) AS "Precio Medio"  
      FROM moviles  
      GROUP BY id_empresa  
      HAVING AVG(precio) > 50;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **GameHub**, conectando como usuario **gamehub_alu**:

**Ex_28** Calcular la media de cantidades vendidas de los **productos** que aparecen en más de dos líneas de compra.

**Ex_29** Sacar las **ciudades** con entre 3 y 7 **jugadores**, mostrando el nombre de la ciudad y el número de jugadores.

**Ex_30** Sacar las **categorías** con más de un producto de precio superior a **500 €**.

**Ex_31** Sacar los **jugadores** con más de una **compra**, mostrando su número de compras.

**Ex_32** Repetir lo anterior considerando solo las compras del primer trimestre de 2024.

**Ex_33** Para las **compras** con 10 o más líneas, calcular su base sin descuentos y su base aplicando el descuento de cada línea. Usar `precio_unitario * cantidad * (1 - COALESCE(descuento_linea, 0) / 100.0)`. No aplicar todavía el descuento general ni el IVA.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

