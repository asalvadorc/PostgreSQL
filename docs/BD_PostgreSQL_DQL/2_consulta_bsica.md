# 2. Consulta básica


Lo mínimo que debe indicarse en una instrucción SELECT es las columnas que queremos
y su procedencia, que puede ser una o más de una mesa.

**<u>Sintaxis</u>**

    SELECT <columnas>
      FROM <clausula>

Opcionalmente la sentencia puede terminar en **punto y coma**. En **psql** es
obligatorio acabar en punto y coma, ya que es la forma que tiene de saber que
termina la instrucción (una instrucción puede ocupar más de una línea)

Y otra consideración importante es que en PostgreSQL los nombres de los objetos
(mesas, columnas, ...) pueden constar de más de una palabra. Si el nombre sólo
consta de una palabra se puede poner sin más problemas, pero si consta de más
de una palabra (con espis en blanco de por medio) o tiene algún carácter especial, o
coincide con alguna palabra reservada (por ejemplo _**año**_), tendrá que ir
entre **comillas dobles**. Para ahorrar problemas, es una buena práctica hacer
los nombres siempre de una palabra (si se quieren poner dos, unidas por el guión bajo).

En **&lt;columnas&gt;** podremos poner (separadas por **comas**):

  * **nombres de las columnas** que queremos; si hay confusión entre nombres de campos de distintas tablas, deberemos poner **Tabla.columna**.

  * `*` : indica todas las columnas.

  * **Tabla.*** : indica todas las columnas de la tabla.

  * **Funciones** (ver apartado _Operadores y Funciones de Postgres_)

  * **Constantes** : son valores que ponemos directamente. Los tipos de constantes son:

    * **Numéricas** : se ponen tal cual, con punto decimal (no puede ir como decimal, porque sirve para separar las columnas)
    * **Alfauméricas** : se ponen entre **comillas simples**
    * Para otros tipos (como por ejemplo fecha-hora), ponemos la constante entre comillas simples, y PostgreSQL hará la conversión
  * **Expresiones** que utilizan operadores para combinar columnas, funciones, constantes numéricas o alfanuméricas, ...

En la **&lt;clausula&gt;** del **FROM** pondremos la mesa o las tablas (separadas
por comas) de dónde vienen los datos.

Así el siguiente ejemplo saca toda la información de la tabla **estudios**, es decir todas las filas y todas las columnas:

    SELECT * FROM estudios;

Mientras que la siguiente sólo saca el nombre:

    SELECT nombre FROM estudios;

En el siguiente ejemplo se saca el título de cada juego y su precio:

    SELECT titulo, precio FROM juegos;

Y en éste sacamos el título de cada juego, su precio y el precio con un descuento del 50% (multiplicado por 0.5):

    SELECT titulo, precio, precio * 0.5 FROM juegos;

Ejemplos adicionales:

  1) Sacar toda la información de la tabla **juegos**.

    SELECT * FROM juegos;

  2) Sacar el título y el precio de todos los juegos.

    SELECT titulo, precio 
      FROM juegos;

  3) Sacar el título de los juegos, su precio, y ese precio incrementado en un 5% por impuestos.

    SELECT titulo, precio, precio * 1.05 
      FROM juegos;

Observa cómo debemos utilizar el punto decimal y no la coma decimal, ya que la
coma sirve para separar los campos de la consulta SQL.

  4) Sacar el título y la primera palabra del título de todos los juegos. Para sacar la primera palabra buscaremos la posición del primer espacio en blanco.

    SELECT titulo, SUBSTR(titulo, 1, STRPOS(titulo, ' ') - 1) 
      FROM juegos;

## :pencil2: Ejercicios {: .ejercicios-header}

En la BD **TecnoTienda**, conectando como usuario **tech_alu**:

> **Ex_1** Sacar toda la información de los **productos**.
>
> **Ex_2** Sacar el código de empleado, el nombre y el puesto, por este orden, de todos los **empleados**.

> **Ex_3** Sacar el código de producto, el nombre, la marca, el precio y el precio incrementado en un 5% de todos los **productos**.

> **Ex_4** Sacar la información de los **clientes** con el siguiente formato (debe ir todo en una columna):
>
> > **Pérez, Juan. Calle Mayor 10 (28001)**
>
> Fíjese que está todo en una columna y, por tanto, tendrá que concatenar de la forma adecuada. Fíjese también que en el nombre solo las iniciales están en mayúsculas.

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

