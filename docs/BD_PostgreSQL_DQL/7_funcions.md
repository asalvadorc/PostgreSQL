# 4.2 Funciones

Como veremos un poco más adelante, en las sentencias SQL, aparte de columnas y
valores constantes, podremos utilizar funciones.

PostgreSQL tiene muchas funciones ya creadas.

Haremos una recopilación de las funciones más importantes de PostgreSQL, de entre la
multitud de funciones que existen. Las agruparemos por categorías.

Evidentemente esta recopilación no es para aprenderlo de memoria, sino que servirá de
consulta.


**Funciones numéricas**{.azul}

Función |  Explicación |  Función |  Explicación   
---|---|---|---  
ABS(n) |  Valor absoluto de n. |  LOG(m,n) |  Logaritmo, base m, de n  
ACOS(n) |  Arcosinoso de n (inverso del coseno) |  MOD(m,n) |  El resto de la división entre m y n  
ASIN(n) |  Arcsinus de n (inverso de seno) |  POWER(m,n) |  m elevado a n  
ATAN(n) |  Arctangente de n (inverso de la tangente) |  RANDOM() |  número aleatorio entre 0 y 1  
CEIL(n) |  Enter inmediatamente superior o igual a n |  Round(n,[m]) |  n redondeado a m cifras decimales (por defecto 0)  
CUERPO(n) |  Primo de n. |  SINO(n) |  Seno de n  
EXP(n) |  Exponencial de n (en) |  SQRT(n) |  Raíz cuadrada de n  
FLOOR(n) |  Enter inmediatamente inferior o igual a n |  TAN(n) |  Tangente de n  
LN(n) |  Logaritmo neperiano de n |  Trunco(n,[m]) |  n truncado a m cifras decimales (por defecto 0)  
  
Por ejemplo, podríamos simular el lanzamiento de un dado de esta forma:
```
SELECT TRUNC(RANDOM()*6+1);
```

**Funciones de caracteres**{.azul}

Función |  Explicación 
---|---
ASCII(c) |  Vuelve el código ASCII correspondiente al carácter c 
REPLACE(c1,c2,c3) |  Reemplaza en **c1** cada ocurrencia de **c2** por **c3**  
CHR(n) |  Vuelve el carácter con código ASCII n. 
RPAD(c1,n[c2]) |  Vuelve **c1** rellenada por la derecha hasta **n** caracteres con la cadena **c2**  
CONCADO(c1,c2) |  Concatena las dos cadenas (equivalente al operador ||) RTRIM(c1[,set]) |  Recorta por la derecha mientras encuentra la cadena set (por defecto blancos)  
INITCAP(c1) |  Vuelve la cadena con la primera letra de cada palabra en mayúsculas, y las demás en minúsculas
STRPOS(s,s1) |  Busca la primera ocurrencia de la subcadena s1 dentro de la cadena s  
LENGTH(c1) |  Largo de la cadena. Si c1 es tipo CHAR, incluirá todos los espacios en blanco del final.
SUBSTR(c1,m[,n]) |  Vuelve una subcadena de c1 que comienza en el carácter m y consta de n caracteres (por defecto hasta el final)  
LPAD(c1,n[c2]) |  Vuelve c1 rellenada por la izquierda hasta n caracteres con la cadena c2
TRANSLATE(c1,c2,c3) |  Vuelve c1 con cada carácter de c2 sustituido por el correspondiente (en orden) de c3.  
LTRIM(c1[,siete]) |  Recorta por la izquierda mientras encuentra la cadena set (por defecto blancos)
LOWER(c1) |  Vuelve la cadena en minúsculas  
UPPER(c1) |  Vuelve la cadena en mayúsculas  
  
Por ejemplo, vamos a extraer la primera palabra del modelo de los móviles. 
Para ello, cogeremos los caracteres desde el inicio hasta el primer espacio.
```sql
SELECT modelo, SUBSTR(modelo, 1, STRPOS(modelo, ' ') - 1)  
FROM moviles;
```
Esto podríamos mejorarlo para que sea más genérico. Imaginemos que tenemos productos con un formato de nombre "Marca: Modelo" y queremos extraer solo la marca (lo que va antes de los dos puntos).
```sql
SELECT nombre, SUBSTR(nombre, 1, STRPOS(nombre, ':') - 1)  
FROM productos;
```
Si quisiéramos extraer el modelo (lo que va después de ": "), tendríamos que empezar en la posición del ":" más 2.
```sql
SELECT nombre, SUBSTR(nombre, STRPOS(nombre, ':') + 2)  
FROM productos;
```
También podemos jugar con las comillas si el nombre tuviera formatos especiales. Por ejemplo, si un producto se llamara `Pack 'Gamer' "Premium"`, para buscar las comillas simples tendríamos que escaparlas (poner dos comillas simples seguidas dentro de la cadena).

```sql
SELECT 'Pack ''Gamer'' "Premium"', 
       STRPOS('Pack ''Gamer'' "Premium"', ''''), -- Busca la comilla simple
       STRPOS('Pack ''Gamer'' "Premium"', '"');  -- Busca la comilla doble
```

**Funciones de fecha**{.azul}

Función |  Explicación  
---|---  
NOW() (CURRENT_TIMESTAMP) |  Vuelve la fecha-hora actual, con la diferencia de horas respecto a la GMT |  Todas las funciones que vuelven horas (con fecha o sin fecha), lo harán hasta la micra de segundo, a menos que entre paréntesis indiquemos las cifras decimales (de segundo) que queremos  
LOCALTIMESTAMP |  Al igual que el anterior, pero sin la diferencia de la GMT  
CURRENT_DATE |  Vuelve la fecha actual  
CURRENT_TIME |  Vuelve la hora actual (con diferencia GMT)  
LOCALTIMO |  Vuelve la hora actual (sin diferencia GMT)  
AGE(t) |  Vuelve la diferencia de la fecha actual y t  
AGE(t1,t2) |  Vuelve la diferencia entre t1 (posterior) y t2 (anterior)  
EXTRACTO(campo FROM t) |  Saca el número correspondiente al campo (que puede ser year, month, day, hour, minute, second, millisecond, microsecond, dow (day of week), ...  
  
Por ejemplo, ¿cuánto tiempo ha pasado desde el intento de golpe de estado?
```
SELECT AGE('1981/02/23'::DATE);
```
O otro, ¿en qué año estamos?
```
SELECT EXTRACT(year FROM CURRENT_DATE);
```
**<u>Funciones geométricas</u>**

Función |  Explicación |  Función |  Explicación  
---|---|---|---  
AREA(o) |  Área del objeto |  HEIGTH(r) |  Altura del rectángulo  
CENTERO(o) |  Centro del objeto |  RADIVOS(c) |  Radio del círculo  
DIAMETERO(c) |  Diámetro del círculo |  WIDTH(r) |  Anchura del rectángulo  
  
Por ejemplo, el área de un círculo:
```
SELECT AREA('((5,5),2)'::CIRCLE);
```

**Funciones**{.azul}

Función |  Explicación |  Ejemplo |  Resultado  
---|---|---|---  
HOST(ip) |  Saca en formato texto la dirección IP |  HOST('192.168.2.15/24') |  192.168.2.15  
MASKLEN(ip) |  Saca el número de bits de la máscara |  MASKLEN('192.168.2.15/24') |  24  
SET_MASKLEN(ip,n) |  Pone el número de bits de la máscara en los especificados |  SET_MASKLEN('192.168.2.15/24',16) |  192.168.2.15/16  
NETMASK(ip) |  Construye la máscara de red |  NETMASK('192.168.2.15/24') |  255.255.255.0  
  

**Funciones de conversión**{.azul}

Servirán para pasar de un tipo a otro, donde uno de ellos será el tipo de
cadena (VARCHAR)

Función |  Explicación  
---|---  
**TO_CHAR(_fecha, formato_)** |  Convierte una fecha en una tira de caracteres, utilizando el formato especificado (se verá este formato en la siguiente pregunta)  
**TO_CHAR(_número, formato_)** |  Convierte un número en una tira de caracteres  
**TO_NUMBER(_exp., formato_)** |  Convierte una tira de caracteres en un número, suponiendo que estaba en el formato indicado  
**TO_DATE(_exp., formato_)** |  Convierte una tira de caracteres en una fecha  
**TO_DATETIME(_exp., formato_)** |  convierte una tira de caracteres en un fecha-hora  
  
## 4.2.1 Formatos de las fechas

Este tipo es muy versátil en cuanto al formato, bien sea para la introducción
de los datos, o lo que es más habitual, para su presentación. Se habrá
de utilizar una función, **TO_CHAR** , que aceptará 2 parámetros: el primero la
fecha que se desea presentar, y el segundo el formato que queremos. En el formato
indicaremos mediante determinados caracteres el aspecto que queremos. Por ejemplo,
para sacar la fecha de hoy con el formato día-mes-año, pondríamos:
```
SELECT TO_CHAR( NOW(), 'DD-MM-YYYY');
```
El siguiente cuadro resume estos caracteres, agrupado por categorías:

![](T6_f1.png)


En principio los formatos que devuelven letras lo estarán en inglés, pero después
veremos cómo cambiar de idioma.

![](T6_f2.png)

![](T6_f3.png)
  

  
**<u>Ejemplos:</u>**

Si ahora fuera **9/1/16 13:39** (en el servidor, no en su máquina), y
hicimos **SELECT TO_CHAR(NOW(),'_format_****');**

Formato |  Salida  
---|---  
dd-mm-yy hh:mi | **09-01-23 01:39**  
dd-mm-yy hh24:mi | **09-01-16 13:39**  
dd-MON-yyy | **09-JAN-023**  
dd-TMMON-yyy | **09-ENE-023 _(si lo tuvimos configurado en español)_**  
Day, dd "de" month "de" yyyy | **Monday , 09 de january de 2023 de 2016**  
FMDay, dd "de" FMmonth "de" yyyy. | **Monday, 09 de january de 2023.**  
TMDay, dd "de" TMmonth "de" yyyy. | **Lunes, 09 de enero de 2023.**_(si lo tuvimos configurado en español)_  
FMDy PM FMhh-FMmi-FMss | **Mundo PM 1-39-00**  
TMDy PM TMhh-TMmi-TMss | **Lun PM 01-39-00 __**_(si lo tuvimos configurado en español)_  

## 4.2.2 Formatos de los números


También podremos utilizar la función **TO_CHAR** para dar el aspecto que queramos
en los números. En la siguiente tabla tenemos un resumen con los distintos símbolos, uno
comentario descriptivo de cada símbolo, y un ejemplo de formato con el resultado
que daría para un determinado valor. La sentencia sería **SELECT
TO_CHAR(**_valor_**,'**_format_**');** :

![](T6_f4.png)

Licenciado bajo la [Licencia Creative Commons Reconocimiento NoComercial
CompartirIgual 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)

