# 8. La cláusula ORDER BY

Ordena las filas del resultado respecto al orden especificado

**<u>Sintaxi</u>**

    SELECT <columnes>  
      FROM <taules>  
      ORDER BY camp1 [ASC | DESC] { , campo2 [ASC | DESC] }

Aquí tenemos un ejemplo:

    SELECT nombre, sede  
      FROM empresas  
      ORDER BY nombre;

Se ordenarán las filas por el campo, en el orden marcado: ascendente o descendente (por defecto, ascendente). Si hubiera un segundo campo de ordenación, éste entraría en móvil en caso de valores iguales del primero. Este segundo podrá ser en orden ascendente o descendente, independientemente del orden del primer campo.

    SELECT nombre, sede  
      FROM empresas  
      ORDER BY sede DESC, nombre;

Se podrá ordenar por cualquier campo de la tabla, esté indexada por éste
campo o no. La ventaja de estar indexada respecto a un campo es la rapidez en
la ordenación. Así, si tenemos una mesa grande y ordenamos por un determinado campo,
se perderá tiempo en esta ordenación. Si continuamente estamos ordenando por
este campo, vamos a perder este tiempo muchas veces. Entonces sería conveniente
crear un índice. Pero debemos recordar que la creación de un índice ocupa espacio.
Por tanto no es buena solución indexar por todos los campos. Únicamente, en todo caso,
para aquellos que más se ordenen. Veremos la creación de índice en la tercera parte
de ese tema.

Y se puede especificar en la ordenación, una expresión que combine uno o más campos con operadores y funciones. Se puede poner un campo o una expresión que no esté en la lista de campos o expresiones que se quieren visualizar (al lado del SELECT), aunque normalmente sí que lo visualizaremos para poder comprobar que realmente está ordenado. Por ejemplo, si queremos ordenar por el precio de los móviles incrementado en un 21% de IVA:

    SELECT modelo, precio  
      FROM moviles  
      ORDER BY precio * 1.21 DESC;

Opcionalmente, si la expresión aparece en la lista de columnas a visualizar, podremos poner simplemente el número de orden de la columna. Así, por ejemplo, podemos hacer lo siguiente:

    SELECT modelo, precio, precio * 1.21  
      FROM moviles  
      ORDER BY 3 DESC;

> Donde estamos indicando que se ordene de forma descendente por la tercera columna que va a visualizarse, es decir, por el precio con IVA.

Debemos observar que la cláusula ORDER BY es la última, y que en caso de haber
cláusula GROUP BY, se intentará ordenar después de haber agrupado. Por tanto en
caso de que la sentencia contenga un GROUP BY o se haya utilizado alguna función
de agregado (que implica hacer grupos), sólo podremos poner en el ORDER BY campos que
estén en el GROUP BY o que forman parte de una función de agregado. El razonamiento
es lo mismo que el hecho en la cláusula GROUP BY o HAVING y el error en caso de
no respetar esto sería lo mismo que lo visto en aquel apartado.

**<u>Ejemplos</u>**

  1) Sacar toda la información de los móviles ordenados por el modelo de forma alfabética.

    SELECT *  
      FROM moviles  
      ORDER BY modelo;

  2) Sacar toda la información de los móviles, ordenados por el ID de empresa, y dentro de éste por el precio (de forma descendente).

    SELECT *  
      FROM moviles  
      ORDER BY id_empresa, precio DESC;

  3) Sacar las empresas con el número de móviles y el total de la suma de sus precios, para aquellas empresas que tienen más de 2 móviles, ordenados por el número de móviles, y dentro de éste por la suma total de forma descendente.

    SELECT id_empresa, COUNT(*), SUM(precio)  
      FROM moviles  
      GROUP BY id_empresa  
      HAVING COUNT(*) > 2  
      ORDER BY COUNT(*) , SUM(precio) DESC;




## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **Juegos**, conectando como usuario **alumno**:

**Ex_34** Sacar los **jugadores** ordenados por **ciudad** y, dentro de esta, por **código postal**.

**Ex_35** Sacar los **productos** ordenados por **categoría**, después por **stock** y finalmente por **precio descendente**.

**Ex_36** Ordenar los resultados de **Ex_33** por la base con descuentos de línea, de mayor a menor.

**Ex_37** Sacar los **productos** ordenados por la diferencia entre **stock** y **stock mínimo**, de mayor a menor, tratando los nulos como 0 con `COALESCE`.

**Ex_38** Sacar los códigos de **vendedor** y su número de **compras** atendidas en el segundo semestre de 2024, ordenados por ese número de mayor a menor.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

