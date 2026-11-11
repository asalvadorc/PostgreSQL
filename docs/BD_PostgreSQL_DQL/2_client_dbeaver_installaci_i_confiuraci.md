# DBeaver

## 2.1 Instalación y configuración

Como ya se ha comentado, en este tema utilizaremos el Sistema Gestor de Bases de
Datos **PostgreSQL**. Este SGBD utiliza la arquitectura **cliente-servidor**.
Esto significa que existe un servidor central con el PostgreSQL instalado, y
habrá muchos clientes que se conectarán a ese servidor. Se puede hacer desde
la misma máquina en la que está instalado el servidor, o desde otra.

En nuestro caso, el servidor está ya en marcha y funcionando. Podremos acceder a
él tanto desde dentro del Instituto como desde fuera.

A nosotros, para poder conectar con el servidor PostgreSQL nos hace falta el
**cliente de PostgreSQL**.

Instalaremos **DBeaver** , un programa que está pegando muy fuerte y nos permite
acceder a cualquier Sistema Gestor de Bases de Datos muy cómodamente.

En los ordenadores del Institut ya lo tenemos instalado. En casa se lo habrá
de instalar pero su instalación no ofrece ningún problema.

Deberá ir a la página de DBeaver, concretamente a la de Downloads:
<https://dbeaver.io/download/>

Escogeremos la versión **Comunity Edition** , con ella tendremos de sobra y es
totalmente libre. Como ve se puede instalar sin problemas en Windows, Mac
y/o Linux

![](T6_1_3_1.png)

La versión Enterprise Edition también nos permitiría acceder a muchísimas Bases
de Datos NoSQL. Cómo ve muy interesante.

Como hemos dicho con la versión Comunity Edition, tendremos más que suficiente.

Tanto en Linux como en Windows tenemos la posibilidad de descargarnos un archivo
comprimido (zip o tar.gz respectivamente) que sólo deberemos descomprimir y
buscar el ejecutable. También tenemos la posibilidad de descargarnos el instalador,
que en Windows sería un ejecutable y en Linux un paquete. Pero la primera opción
del archivo comprimido nos irá bien.

La versión en el momento de realizar estos apuntes es la 21.2.4

Una vez hecha la instalación deberemos realizar la conexión con el SGBD que en
nuestro caso será PostgreSQL. Pero conectar a cualquier otro SGBD sería
exactamente igual.

La primera vez que arranquemos el programa, seguramente nos pedirá por hacer
la primera conexión. Llegaremos a la misma ventana cada vez que vayamos a
hacer una nueva conexión.

**Primera conexión a PostgreSQL: geo**{.azul}

Especificaremos que queremos conectar a PostgreSQL y a continuación daremos las
datos de conexión, que son estas:

  * Servidor (**Host**): **89.36.214.106**
  * Base de Datos (**Database**): **geo**
  * Usuario (**Username**): **geo**
  * Contraseña (**Password**): **geo**

En esta Base de Datos tendremos unas tablas que nos servirán para hacer
ejercicios de SQL. Comentaremos su estructura más adelante.

Éstas son las ventanas donde especificaríamos la anterior:

![](T6_1_3_2.png) | ![](T6_1_3_3.png)  
---|---  
  
**Segunda conexión a PostgreSQL: factura**{.azul}

Para los ejercicios trabajaremos sobre otra Base de Datos más completa que
nos dé más juego a la hora de realizar las sentencias SQL. La Base de Datos
se llama factura, y debe conectarse con el usuario factura con contraseña
factura. Comentaremos su estructura más adelante. Estos son los datos de
conexión:

  * Servidor (**Host**): **89.36.214.106**
  * Base de Datos (**Database**): **factura**
  * Usuario (**Username**): **factura_alu**
  * Contraseña (**Password**): **factura_alu**

Éstas son las pantallas donde haríamos la conexión:

![](T6_1_3_2.png) | ![](T6_1_3_4.png) 
---|---  

<!--
**<u>Ejemplo de conexión a Access: Empresa.accdb</u>**

Únicamente a modo ilustrativo vamos a mostrar otra conexión diferente a las
de PostgreSQL. Como de momento sólo habíamos trabajado con **Access**, vamos
a intentar conectar con la Base de Datos **Empresa.accdb** hecha en el tema
anterior.

La conexión deberemos realizarla en **MS Access (UCanAccess)**. Después sólo habremos
de navegar para encontrar la Base de Datos **Empresa.accdb**

Aquí presentamos las pantallas para realizar la conexión:

![](T6_1_1_4.png) | ![](T6_1_1_5.png)  
---|---  
-->  

## 2.2 Utilización

Una vez hecha la conexión, **DBeaver** nos permitirá navegar por las tablas y
otros objetos de la Base de Datos, inspeccionar las tablas, y lo más
importante para nosotros, ejecutar sentencias SQL de forma cómoda.

En la siguiente imagen se presentan algunas de sus partes y
características. En ella se ha hecho doble clic sobre una mesa, COMARCAS, por
ver sus características:

![](T6_1_4_1.png)

También podemos ver los datos, e incluso añadir nuevas filas, borrar o
modificar las existentes. Se puede ordenar las filas y realizar filtros:

![](T6_1_4_2.png)

Y también tendremos la posibilidad de ejecutar consultas SQL (en la primera imagen
se muestra cómo llegar). En la ventana de sentencias SQL podremos editar la
consulta de forma cómoda (nos da mucha ayuda para no cometer errores
sintácticos) y también nos muestra el resultado. Podemos modificar cuántas veces
queramos. y desde el menú **File** podremos guardar la consulta, lo que haremos
para todos los ejercicios del tema:

![](T6_1_4_3.png)


Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

