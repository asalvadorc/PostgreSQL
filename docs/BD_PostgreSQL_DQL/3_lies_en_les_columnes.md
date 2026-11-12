# 3. Alias ​​en las columnas

Tenemos también la posibilidad de dar nombres (_**alias**_) a las columnas que
aparecerán en la cabecera de las columnas correspondientes en el resultado.

**<u>Sintaxi</u>**

    SELECT columna1 [AS alias1] [ , columna2 [AS alias2] ]  
      FROM MESA;

Si queremos que en la cabecera aparezcan más de una palabra, deberemos cerrarlas
con comillas dobles ( **"** ).

Por ejemplo:

    SELECT id_movil AS "Código Móvil" , modelo  
      FROM moviles;
   
Es especialmente útil la utilización de sobrenombre cuando ponemos una expresión, en
cuenta de una única columna. Si no ponemos sobrenombre, aparece en la cabecera una
algo parecido a **?column?**.

    SELECT modelo || ' (' || fecha_lanzamiento || ')' AS "Móvil (Lanzamiento)"  
      FROM moviles;

Y aparte de su valor estético, más adelante veremos sentencias SQL en las que
obligatoriamente deberemos poner alias en las columnas que sean el resultado
de una expresión.

**<u>Ejemplos</u>**

  1) Sacar de los móviles, el modelo y el precio, éste último con el nombre **Costo**.

    SELECT modelo, precio AS Costo  
      FROM moviles;

  2) Sacar todos los campos de la tabla **categorias** de forma elegante.

    SELECT id_categoria AS "Código Categoría", descripcion AS "Categoría"  
      FROM categorias;


## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **Juegos**, conectando como usuario **alumno**:

**Ex_5** Sacar `id_compra`, `fecha` e `id_vendedor` de **compras** con las cabeceras **Número Compra**, **Fecha** y **Código Vendedor**.

**Ex_6** Dar alias legibles a los campos de la tabla **productos**.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

