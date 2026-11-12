# Soluciones y resultados: DQL básico

Estas soluciones utilizan **Juegos** con su carga inicial: 8 jugadores, 12 compras y 28 líneas. Los resultados se han calculado ejecutando las consultas en un motor PostgreSQL. Los decimales largos se muestran con un máximo de cuatro cifras decimales; los cálculos usan su precisión completa.

Si has modificado los datos, [restaura la carga inicial](../BD_PostgreSQL_DML/1_introducci.md) antes de comparar. Un resultado vacío también puede ser correcto. No se utilizan capturas de otra base de datos.

El ejercicio 50 utiliza la tabla temporal creada en el 49: ejecútalos en la misma conexión. Si repites el 49, elimina antes la copia temporal. Los ejercicios con varias tablas anticipan contenidos que se desarrollan en DQL avanzado.

## Ejercicio 1

Sacar toda la información de los **productos**.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM productos
    ORDER BY id_producto;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 1 | Elden Ring | 59.99 | 20 | 5 | 1 |
    | 2 | Minecraft | 29.99 | 30 | 5 | 1 |
    | 3 | PlayStation 5 | 499.99 | 6 | 2 | 2 |
    | 4 | Nintendo Switch | 299.99 | 5 | 2 | 2 |
    | 5 | RZ Mouse: DeathAdder | 45.00 | 8 | 2 | 3 |
    | 6 | RZ Teclado: BlackWidow | 89.99 | 5 | 2 | 3 |
    | 7 | Auriculares: HyperX Cloud | 69.99 | NULL | 2 | 3 |
    | 8 | Mando: Xbox Wireless | 59.99 | 7 | NULL | 3 |
    | 9 | Camiseta: Creeper | 19.99 | 15 | 3 | 4 |
    | 10 | Figura: Hollow Knight | 24.99 | 10 | 2 | 4 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 3 | 1 | 2 |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 2 | 1 | 2 |

    *12 filas.*

## Ejercicio 2

Sacar el código, el nombre y la ciudad de todos los **vendedores**, por ese orden.

??? success "Consulta y resultado"

    ```sql
    SELECT id_vendedor, nombre, id_ciudad
    FROM vendedores
    ORDER BY id_vendedor;
    ```

    | id_vendedor | nombre | id_ciudad |
    | --- | --- | --- |
    | 1 | Alicia Damborenea | 1 |
    | 2 | Marcos Vidal | 3 |
    | 3 | Elena García | 5 |

    *3 filas.*

## Ejercicio 3

Sacar el código, el nombre, el precio y el precio incrementado en un 5 % de todos los **productos**.

??? success "Consulta y resultado"

    ```sql
    SELECT id_producto, nombre, precio, precio * 1.05 AS precio_incrementado
    FROM productos
    ORDER BY id_producto;
    ```

    | id_producto | nombre | precio | precio_incrementado |
    | --- | --- | --- | --- |
    | 1 | Elden Ring | 59.99 | 62.9895 |
    | 2 | Minecraft | 29.99 | 31.4895 |
    | 3 | PlayStation 5 | 499.99 | 524.9895 |
    | 4 | Nintendo Switch | 299.99 | 314.9895 |
    | 5 | RZ Mouse: DeathAdder | 45.00 | 47.2500 |
    | 6 | RZ Teclado: BlackWidow | 89.99 | 94.4895 |
    | 7 | Auriculares: HyperX Cloud | 69.99 | 73.4895 |
    | 8 | Mando: Xbox Wireless | 59.99 | 62.9895 |
    | 9 | Camiseta: Creeper | 19.99 | 20.9895 |
    | 10 | Figura: Hollow Knight | 24.99 | 26.2395 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 1363.9500 |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 1993.9500 |

    *12 filas.*

## Ejercicio 4

Mostrar los datos de los **jugadores** en una sola columna con el formato **Juan Pérez López. Calle Mayor 10 (28001)**, concatenando nombre, dirección y código postal.

??? success "Consulta y resultado"

    ```sql
    SELECT nombre || '. ' || COALESCE(direccion, '(sin dirección)') || ' (' || COALESCE(codigo_postal, 'sin CP') || ')' AS jugador
    FROM jugadores
    ORDER BY id_jugador;
    ```

    | jugador |
    | --- |
    | Juan Pérez López. Calle Mayor 10 (28001) |
    | Marta Sánchez Vidal. Avinguda Diagonal 50 (08001) |
    | Luis Villalonga García. Calle del Mar 5 (12001) |
    | Sara Vidal Villalonga. (sin dirección) (28002) |
    | Álex García Torres. Calle Sol 8 (sin CP) |
    | Noa López Serra. (sin dirección) (12002) |
    | Hugo Martín Ruiz. Calle Luna 4 (08002) |
    | Paula Serra Gil. Calle Estación 2 (28801) |

    *8 filas.*

## Ejercicio 5

Sacar `id_compra`, `fecha` e `id_vendedor` de **compras** con las cabeceras **Número Compra**, **Fecha** y **Código Vendedor**.

??? success "Consulta y resultado"

    ```sql
    SELECT id_compra AS "Número Compra", fecha AS "Fecha", id_vendedor AS "Código Vendedor"
    FROM compras
    ORDER BY id_compra;
    ```

    | Número Compra | Fecha | Código Vendedor |
    | --- | --- | --- |
    | 1 | 2024-01-10 | 2 |
    | 2 | 2024-01-15 | 3 |
    | 3 | 2024-02-05 | 2 |
    | 4 | 2024-03-04 | 3 |
    | 5 | 2024-03-12 | 2 |
    | 6 | 2024-03-20 | 3 |
    | 7 | 2024-07-02 | 2 |
    | 8 | 2024-09-10 | 3 |
    | 9 | 2024-10-01 | 2 |
    | 10 | 2024-10-15 | 3 |
    | 11 | 2024-11-05 | 2 |
    | 12 | 2024-12-02 | 3 |

    *12 filas.*

## Ejercicio 6

Dar alias legibles a los campos de la tabla **productos**.

??? success "Consulta y resultado"

    ```sql
    SELECT id_producto AS "Código", nombre AS "Producto", precio AS "Precio", stock AS "Stock", stock_minimo AS "Stock mínimo", id_categoria AS "Categoría"
    FROM productos
    ORDER BY id_producto;
    ```

    | Código | Producto | Precio | Stock | Stock mínimo | Categoría |
    | --- | --- | --- | --- | --- | --- |
    | 1 | Elden Ring | 59.99 | 20 | 5 | 1 |
    | 2 | Minecraft | 29.99 | 30 | 5 | 1 |
    | 3 | PlayStation 5 | 499.99 | 6 | 2 | 2 |
    | 4 | Nintendo Switch | 299.99 | 5 | 2 | 2 |
    | 5 | RZ Mouse: DeathAdder | 45.00 | 8 | 2 | 3 |
    | 6 | RZ Teclado: BlackWidow | 89.99 | 5 | 2 | 3 |
    | 7 | Auriculares: HyperX Cloud | 69.99 | NULL | 2 | 3 |
    | 8 | Mando: Xbox Wireless | 59.99 | 7 | NULL | 3 |
    | 9 | Camiseta: Creeper | 19.99 | 15 | 3 | 4 |
    | 10 | Figura: Hollow Knight | 24.99 | 10 | 2 | 4 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 3 | 1 | 2 |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 2 | 1 | 2 |

    *12 filas.*

## Ejercicio 7

Sacar los **jugadores** que viven en la ciudad **Madrid**. Consultar `ciudades` para localizar su código.

??? success "Consulta y resultado"

    ```sql
    SELECT j.*
    FROM jugadores j
    JOIN ciudades c ON c.id_ciudad=j.id_ciudad
    WHERE c.nombre='Madrid'
    ORDER BY j.id_jugador;
    ```

    | id_jugador | nombre | direccion | codigo_postal | id_ciudad |
    | --- | --- | --- | --- | --- |
    | 1 | Juan Pérez López | Calle Mayor 10 | 28001 | 1 |
    | 4 | Sara Vidal Villalonga | NULL | 28002 | 1 |
    | 5 | Álex García Torres | Calle Sol 8 | NULL | 1 |

    *3 filas.*

## Ejercicio 8

Sacar todas las **compras** de marzo de 2024.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM compras
    WHERE fecha >= DATE '2024-03-01' AND fecha < DATE '2024-04-01'
    ORDER BY id_compra;
    ```

    | id_compra | fecha | id_jugador | id_vendedor | iva | descuento |
    | --- | --- | --- | --- | --- | --- |
    | 4 | 2024-03-04 | 5 | 3 | 21.00 | 5.00 |
    | 5 | 2024-03-12 | 3 | 2 | 21.00 | NULL |
    | 6 | 2024-03-20 | 4 | 3 | 21.00 | 0.00 |

    *3 filas.*

## Ejercicio 9

Sacar los **productos** de la categoría **Consolas** con un **stock** entre **2 y 7** unidades. Localizar el código en `categorias`.

??? success "Consulta y resultado"

    ```sql
    SELECT p.*
    FROM productos p
    JOIN categorias c ON c.id_categoria=p.id_categoria
    WHERE c.descripcion='Consolas' AND p.stock BETWEEN 2 AND 7
    ORDER BY p.id_producto;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 3 | PlayStation 5 | 499.99 | 6 | 2 | 2 |
    | 4 | Nintendo Switch | 299.99 | 5 | 2 | 2 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 3 | 1 | 2 |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 2 | 1 | 2 |

    *4 filas.*

## Ejercicio 10

Sacar los **jugadores** que no tienen introducida la **dirección**.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM jugadores
    WHERE direccion IS NULL
    ORDER BY id_jugador;
    ```

    | id_jugador | nombre | direccion | codigo_postal | id_ciudad |
    | --- | --- | --- | --- | --- |
    | 4 | Sara Vidal Villalonga | NULL | 28002 | 1 |
    | 6 | Noa López Serra | NULL | 12002 | 5 |

    *2 filas.*

## Ejercicio 11

Sacar los **productos** con `stock` informado y `stock_minimo` nulo.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM productos
    WHERE stock IS NOT NULL AND stock_minimo IS NULL
    ORDER BY id_producto;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 8 | Mando: Xbox Wireless | 59.99 | 7 | NULL | 3 |

    *1 filas.*

## Ejercicio 12

Sacar los **jugadores** cuyo nombre completo contiene el apellido **Villalonga**.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM jugadores
    WHERE nombre ILIKE '%Villalonga%'
    ORDER BY id_jugador;
    ```

    | id_jugador | nombre | direccion | codigo_postal | id_ciudad |
    | --- | --- | --- | --- | --- |
    | 3 | Luis Villalonga García | Calle del Mar 5 | 12001 | 5 |
    | 4 | Sara Vidal Villalonga | NULL | 28002 | 1 |

    *2 filas.*

## Ejercicio 13

Sacar los jugadores cuyo nombre completo **no** contiene el apellido **Villalonga**.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM jugadores
    WHERE nombre NOT ILIKE '%Villalonga%'
    ORDER BY id_jugador;
    ```

    | id_jugador | nombre | direccion | codigo_postal | id_ciudad |
    | --- | --- | --- | --- | --- |
    | 1 | Juan Pérez López | Calle Mayor 10 | 28001 | 1 |
    | 2 | Marta Sánchez Vidal | Avinguda Diagonal 50 | 08001 | 3 |
    | 5 | Álex García Torres | Calle Sol 8 | NULL | 1 |
    | 6 | Noa López Serra | NULL | 12002 | 5 |
    | 7 | Hugo Martín Ruiz | Calle Luna 4 | 08002 | 3 |
    | 8 | Paula Serra Gil | Calle Estación 2 | 28801 | 2 |

    *6 filas.*

## Ejercicio 14

Sacar los **productos** cuyo nombre comienza por **RZ**, cuyo **precio** está entre **20 y 100 €** y cuyo **stock** supera el **stock mínimo**.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM productos
    WHERE nombre LIKE 'RZ%' AND precio BETWEEN 20 AND 100 AND stock>stock_minimo
    ORDER BY id_producto;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 5 | RZ Mouse: DeathAdder | 45.00 | 8 | 2 | 3 |
    | 6 | RZ Teclado: BlackWidow | 89.99 | 5 | 2 | 3 |

    *2 filas.*

## Ejercicio 15

Contar los **jugadores** con la dirección o el código postal nulos.

??? success "Consulta y resultado"

    ```sql
    SELECT COUNT(*) AS jugadores_sin_datos
    FROM jugadores
    WHERE direccion IS NULL OR codigo_postal IS NULL;
    ```

    | jugadores_sin_datos |
    | --- |
    | 3 |

    *1 filas.*

## Ejercicio 16

Contar cuántas veces aparece el producto **10** en **lineas_compra** y sumar sus unidades vendidas.

??? success "Consulta y resultado"

    ```sql
    SELECT COUNT(*) AS apariciones, SUM(cantidad) AS unidades
    FROM lineas_compra
    WHERE id_producto=10;
    ```

    | apariciones | unidades |
    | --- | --- |
    | 3 | 4 |

    *1 filas.*

## Ejercicio 17

Calcular la media del **stock** de los productos.

??? success "Consulta y resultado"

    ```sql
    SELECT AVG(stock) AS stock_medio
    FROM productos;
    ```

    | stock_medio |
    | --- |
    | 10.0909 |

    *1 filas.*

## Ejercicio 18

Repetir lo anterior tratando los valores nulos como 0 mediante `COALESCE(stock, 0)`.

??? success "Consulta y resultado"

    ```sql
    SELECT AVG(COALESCE(stock,0)) AS stock_medio
    FROM productos;
    ```

    | stock_medio |
    | --- |
    | 9.2500 |

    *1 filas.*

## Ejercicio 19

Contar cuántas **compras** tiene el jugador con ID **5**.

??? success "Consulta y resultado"

    ```sql
    SELECT COUNT(*) AS compras
    FROM compras
    WHERE id_jugador=5;
    ```

    | compras |
    | --- |
    | 4 |

    *1 filas.*

## Ejercicio 20

Calcular el **descuento máximo**, **mínimo** y **medio** de las **compras**.

??? success "Consulta y resultado"

    ```sql
    SELECT MAX(descuento) AS maximo, MIN(descuento) AS minimo, AVG(descuento) AS media
    FROM compras;
    ```

    | maximo | minimo | media |
    | --- | --- | --- |
    | 15.00 | 0.00 | 4.0909 |

    *1 filas.*

## Ejercicio 21

Contar los **jugadores** de cada **provincia**, relacionando jugadores, ciudades y provincias.

??? success "Consulta y resultado"

    ```sql
    SELECT p.nombre AS provincia, COUNT(*) AS jugadores
    FROM jugadores j
    JOIN ciudades c ON c.id_ciudad=j.id_ciudad
    JOIN provincias p ON p.id_provincia=c.id_provincia
    GROUP BY p.id_provincia
    ORDER BY p.id_provincia;
    ```

    | provincia | jugadores |
    | --- | --- |
    | Madrid | 4 |
    | Barcelona | 2 |
    | Castellón | 2 |

    *3 filas.*

## Ejercicio 22

Contar los **jugadores** por **ciudad** y **código postal**.

??? success "Consulta y resultado"

    ```sql
    SELECT c.nombre AS ciudad, j.codigo_postal, COUNT(*) AS jugadores
    FROM jugadores j
    JOIN ciudades c ON c.id_ciudad=j.id_ciudad
    GROUP BY c.id_ciudad,j.codigo_postal
    ORDER BY c.id_ciudad,j.codigo_postal;
    ```

    | ciudad | codigo_postal | jugadores |
    | --- | --- | --- |
    | Madrid | 28001 | 1 |
    | Madrid | 28002 | 1 |
    | Madrid | NULL | 1 |
    | Alcalá de Henares | 28801 | 1 |
    | Barcelona | 08001 | 1 |
    | Barcelona | 08002 | 1 |
    | Castellón de la Plana | 12001 | 1 |
    | Castellón de la Plana | 12002 | 1 |

    *8 filas.*

## Ejercicio 23

Contar las **compras** atendidas por cada **vendedor** a cada **jugador**.

??? success "Consulta y resultado"

    ```sql
    SELECT id_vendedor,id_jugador,COUNT(*) AS compras
    FROM compras
    GROUP BY id_vendedor,id_jugador
    ORDER BY id_vendedor,id_jugador;
    ```

    | id_vendedor | id_jugador | compras |
    | --- | --- | --- |
    | 2 | 1 | 1 |
    | 2 | 2 | 2 |
    | 2 | 3 | 1 |
    | 2 | 5 | 1 |
    | 2 | 7 | 1 |
    | 3 | 1 | 1 |
    | 3 | 4 | 1 |
    | 3 | 5 | 3 |
    | 3 | 6 | 1 |

    *9 filas.*

## Ejercicio 24

Contar las **compras** de cada trimestre usando `TO_CHAR(fecha, 'Q')`.

??? success "Consulta y resultado"

    ```sql
    SELECT TO_CHAR(fecha,'Q') AS trimestre,COUNT(*) AS compras
    FROM compras
    GROUP BY TO_CHAR(fecha,'Q')
    ORDER BY trimestre;
    ```

    | trimestre | compras |
    | --- | --- |
    | 1 | 6 |
    | 3 | 2 |
    | 4 | 4 |

    *3 filas.*

## Ejercicio 25

Para cada **producto**, contar sus líneas de compra, sumar las unidades vendidas y calcular las cantidades máxima y mínima en una línea.

??? success "Consulta y resultado"

    ```sql
    SELECT id_producto, COUNT(*) AS lineas, SUM(cantidad) AS unidades, MAX(cantidad) AS maxima, MIN(cantidad) AS minima
    FROM lineas_compra
    GROUP BY id_producto
    ORDER BY id_producto;
    ```

    | id_producto | lineas | unidades | maxima | minima |
    | --- | --- | --- | --- | --- |
    | 1 | 3 | 3 | 1 | 1 |
    | 2 | 3 | 4 | 2 | 1 |
    | 3 | 4 | 4 | 1 | 1 |
    | 4 | 3 | 3 | 1 | 1 |
    | 5 | 4 | 5 | 2 | 1 |
    | 6 | 2 | 2 | 1 | 1 |
    | 7 | 1 | 1 | 1 | 1 |
    | 8 | 2 | 2 | 1 | 1 |
    | 9 | 1 | 2 | 2 | 2 |
    | 10 | 3 | 4 | 2 | 1 |
    | 11 | 1 | 1 | 1 | 1 |
    | 12 | 1 | 1 | 1 | 1 |

    *12 filas.*

## Ejercicio 26

Contar los **productos** de cada **categoría** y calcular su precio medio.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_categoria,c.descripcion,COUNT(p.id_producto) AS productos,AVG(p.precio) AS precio_medio
    FROM categorias c
    LEFT
    JOIN productos p ON p.id_categoria=c.id_categoria
    GROUP BY c.id_categoria
    ORDER BY c.id_categoria;
    ```

    | id_categoria | descripcion | productos | precio_medio |
    | --- | --- | --- | --- |
    | 1 | Videojuegos | 2 | 44.9900 |
    | 2 | Consolas | 4 | 999.4950 |
    | 3 | Periféricos | 4 | 66.2425 |
    | 4 | Merchandising | 2 | 22.4900 |

    *4 filas.*

## Ejercicio 27

Calcular la base de cada **compra**, sin descuentos ni IVA, sumando `precio_unitario * cantidad` en **lineas_compra** y agrupando por `id_compra`.

??? success "Consulta y resultado"

    ```sql
    SELECT id_compra,SUM(precio_unitario*cantidad) AS base
    FROM lineas_compra
    GROUP BY id_compra
    ORDER BY id_compra;
    ```

    | id_compra | base |
    | --- | --- |
    | 1 | 104.99 |
    | 2 | 524.98 |
    | 3 | 119.97 |
    | 4 | 149.98 |
    | 5 | 799.98 |
    | 6 | 79.97 |
    | 7 | 1344.00 |
    | 8 | 90.00 |
    | 9 | 299.99 |
    | 10 | 1899.00 |
    | 11 | 499.99 |
    | 12 | 1219.90 |

    *12 filas.*

## Ejercicio 28

Calcular la media de cantidades vendidas de los **productos** que aparecen en más de dos líneas de compra.

??? success "Consulta y resultado"

    ```sql
    SELECT id_producto,AVG(cantidad) AS media
    FROM lineas_compra
    GROUP BY id_producto
    HAVING COUNT(*)>2
    ORDER BY id_producto;
    ```

    | id_producto | media |
    | --- | --- |
    | 1 | 1.0000 |
    | 2 | 1.3333 |
    | 3 | 1.0000 |
    | 4 | 1.0000 |
    | 5 | 1.2500 |
    | 10 | 1.3333 |

    *6 filas.*

## Ejercicio 29

Sacar las **ciudades** con entre 3 y 7 **jugadores**, mostrando el nombre de la ciudad y el número de jugadores.

??? success "Consulta y resultado"

    ```sql
    SELECT c.nombre, COUNT(*) AS jugadores
    FROM ciudades c
    JOIN jugadores j ON j.id_ciudad=c.id_ciudad
    GROUP BY c.id_ciudad
    HAVING COUNT(*) BETWEEN 3 AND 7
    ORDER BY c.id_ciudad;
    ```

    | nombre | jugadores |
    | --- | --- |
    | Madrid | 3 |

    *1 filas.*

## Ejercicio 30

Sacar las **categorías** con más de un producto de precio superior a **500 €**.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_categoria,c.descripcion,COUNT(*) AS productos_caros
    FROM categorias c
    JOIN productos p ON p.id_categoria=c.id_categoria
    WHERE p.precio>500
    GROUP BY c.id_categoria
    HAVING COUNT(*)>1
    ORDER BY c.id_categoria;
    ```

    | id_categoria | descripcion | productos_caros |
    | --- | --- | --- |
    | 2 | Consolas | 2 |

    *1 filas.*

## Ejercicio 31

Sacar los **jugadores** con más de una **compra**, mostrando su número de compras.

??? success "Consulta y resultado"

    ```sql
    SELECT id_jugador,COUNT(*) AS compras
    FROM compras
    GROUP BY id_jugador
    HAVING COUNT(*)>1
    ORDER BY id_jugador;
    ```

    | id_jugador | compras |
    | --- | --- |
    | 1 | 2 |
    | 2 | 2 |
    | 5 | 4 |

    *3 filas.*

## Ejercicio 32

Repetir lo anterior considerando solo las compras del primer trimestre de 2024.

??? success "Consulta y resultado"

    ```sql
    SELECT id_jugador,COUNT(*) AS compras
    FROM compras
    WHERE fecha>=DATE '2024-01-01' AND fecha<DATE '2024-04-01'
    GROUP BY id_jugador
    HAVING COUNT(*)>1
    ORDER BY id_jugador;
    ```

    | id_jugador | compras |
    | --- | --- |
    | 5 | 2 |

    *1 filas.*

## Ejercicio 33

Para las **compras** con 10 o más líneas, calcular su base sin descuentos y su base aplicando el descuento de cada línea. Usar `precio_unitario * cantidad * (1 - COALESCE(descuento_linea, 0) / 100.0)`. No aplicar todavía el descuento general ni el IVA.

??? success "Consulta y resultado"

    ```sql
    SELECT id_compra,SUM(precio_unitario*cantidad) AS base, SUM(precio_unitario*cantidad*(1-COALESCE(descuento_linea,0)/100.0)) AS base_con_descuentos
    FROM lineas_compra
    GROUP BY id_compra
    HAVING COUNT(*)>=10
    ORDER BY id_compra;
    ```

    | id_compra | base | base_con_descuentos |
    | --- | --- | --- |
    | 12 | 1219.90 | 1212.1515 |

    *1 filas.*

## Ejercicio 34

Sacar los **jugadores** ordenados por **ciudad** y, dentro de esta, por **código postal**.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM jugadores
    ORDER BY id_ciudad,codigo_postal,id_jugador;
    ```

    | id_jugador | nombre | direccion | codigo_postal | id_ciudad |
    | --- | --- | --- | --- | --- |
    | 1 | Juan Pérez López | Calle Mayor 10 | 28001 | 1 |
    | 4 | Sara Vidal Villalonga | NULL | 28002 | 1 |
    | 5 | Álex García Torres | Calle Sol 8 | NULL | 1 |
    | 8 | Paula Serra Gil | Calle Estación 2 | 28801 | 2 |
    | 2 | Marta Sánchez Vidal | Avinguda Diagonal 50 | 08001 | 3 |
    | 7 | Hugo Martín Ruiz | Calle Luna 4 | 08002 | 3 |
    | 3 | Luis Villalonga García | Calle del Mar 5 | 12001 | 5 |
    | 6 | Noa López Serra | NULL | 12002 | 5 |

    *8 filas.*

## Ejercicio 35

Sacar los **productos** ordenados por **categoría**, después por **stock** y finalmente por **precio descendente**.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM productos
    ORDER BY id_categoria,stock,precio DESC,id_producto;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 1 | Elden Ring | 59.99 | 20 | 5 | 1 |
    | 2 | Minecraft | 29.99 | 30 | 5 | 1 |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 2 | 1 | 2 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 3 | 1 | 2 |
    | 4 | Nintendo Switch | 299.99 | 5 | 2 | 2 |
    | 3 | PlayStation 5 | 499.99 | 6 | 2 | 2 |
    | 6 | RZ Teclado: BlackWidow | 89.99 | 5 | 2 | 3 |
    | 8 | Mando: Xbox Wireless | 59.99 | 7 | NULL | 3 |
    | 5 | RZ Mouse: DeathAdder | 45.00 | 8 | 2 | 3 |
    | 7 | Auriculares: HyperX Cloud | 69.99 | NULL | 2 | 3 |
    | 10 | Figura: Hollow Knight | 24.99 | 10 | 2 | 4 |
    | 9 | Camiseta: Creeper | 19.99 | 15 | 3 | 4 |

    *12 filas.*

## Ejercicio 36

Ordenar los resultados de **Ex_33** por la base con descuentos de línea, de mayor a menor.

??? success "Consulta y resultado"

    ```sql
    SELECT id_compra,SUM(precio_unitario*cantidad) AS base,SUM(precio_unitario*cantidad*(1-COALESCE(descuento_linea,0)/100.0)) AS base_con_descuentos
    FROM lineas_compra
    GROUP BY id_compra
    HAVING COUNT(*)>=10
    ORDER BY base_con_descuentos DESC,id_compra;
    ```

    | id_compra | base | base_con_descuentos |
    | --- | --- | --- |
    | 12 | 1219.90 | 1212.1515 |

    *1 filas.*

## Ejercicio 37

Sacar los **productos** ordenados por la diferencia entre **stock** y **stock mínimo**, de mayor a menor, tratando los nulos como 0 con `COALESCE`.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM productos
    ORDER BY COALESCE(stock,0)-COALESCE(stock_minimo,0) DESC,id_producto;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 2 | Minecraft | 29.99 | 30 | 5 | 1 |
    | 1 | Elden Ring | 59.99 | 20 | 5 | 1 |
    | 9 | Camiseta: Creeper | 19.99 | 15 | 3 | 4 |
    | 10 | Figura: Hollow Knight | 24.99 | 10 | 2 | 4 |
    | 8 | Mando: Xbox Wireless | 59.99 | 7 | NULL | 3 |
    | 5 | RZ Mouse: DeathAdder | 45.00 | 8 | 2 | 3 |
    | 3 | PlayStation 5 | 499.99 | 6 | 2 | 2 |
    | 4 | Nintendo Switch | 299.99 | 5 | 2 | 2 |
    | 6 | RZ Teclado: BlackWidow | 89.99 | 5 | 2 | 3 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 3 | 1 | 2 |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 2 | 1 | 2 |
    | 7 | Auriculares: HyperX Cloud | 69.99 | NULL | 2 | 3 |

    *12 filas.*

## Ejercicio 38

Sacar los códigos de **vendedor** y su número de **compras** atendidas en el segundo semestre de 2024, ordenados por ese número de mayor a menor.

??? success "Consulta y resultado"

    ```sql
    SELECT id_vendedor,COUNT(*) AS compras
    FROM compras
    WHERE fecha>=DATE '2024-07-01' AND fecha<DATE '2025-01-01'
    GROUP BY id_vendedor
    ORDER BY compras DESC,id_vendedor;
    ```

    | id_vendedor | compras |
    | --- | --- |
    | 2 | 3 |
    | 3 | 3 |

    *2 filas.*

## Ejercicio 39

Sacar los **vendedores** que atendieron alguna compra en enero de 2024, sin repetirlos.

??? success "Consulta y resultado"

    ```sql
    SELECT DISTINCT v.id_vendedor,v.nombre
    FROM vendedores v
    JOIN compras c ON c.id_vendedor=v.id_vendedor
    WHERE c.fecha>=DATE '2024-01-01' AND c.fecha<DATE '2024-02-01'
    ORDER BY v.id_vendedor;
    ```

    | id_vendedor | nombre |
    | --- | --- |
    | 2 | Marcos Vidal |
    | 3 | Elena García |

    *2 filas.*

## Ejercicio 40

Sacar los distintos **descuentos de línea** aplicados por cada vendedor en enero de 2024.

??? success "Consulta y resultado"

    ```sql
    SELECT DISTINCT c.id_vendedor,l.descuento_linea
    FROM compras c
    JOIN lineas_compra l ON l.id_compra=c.id_compra
    WHERE c.fecha>=DATE '2024-01-01' AND c.fecha<DATE '2024-02-01'
    ORDER BY c.id_vendedor,l.descuento_linea;
    ```

    | id_vendedor | descuento_linea |
    | --- | --- |
    | 2 | 0.00 |
    | 2 | 5.00 |
    | 3 | 0.00 |
    | 3 | 10.00 |

    *4 filas.*

## Ejercicio 41

Sacar los diferentes **jefes de vendedores**, evitando el valor nulo.

??? success "Consulta y resultado"

    ```sql
    SELECT DISTINCT id_jefe
    FROM vendedores
    WHERE id_jefe IS NOT NULL
    ORDER BY id_jefe;
    ```

    | id_jefe |
    | --- |
    | 1 |

    *1 filas.*

## Ejercicio 42

Sacar los distintos descuentos de línea aplicados a productos cuyo nombre comienza por **RZ**, mostrando `id_producto` y `descuento_linea`.

??? success "Consulta y resultado"

    ```sql
    SELECT DISTINCT p.id_producto,l.descuento_linea
    FROM productos p
    JOIN lineas_compra l ON l.id_producto=p.id_producto
    WHERE p.nombre LIKE 'RZ%'
    ORDER BY p.id_producto,l.descuento_linea;
    ```

    | id_producto | descuento_linea |
    | --- | --- |
    | 5 | 0.00 |
    | 5 | 5.00 |
    | 6 | NULL |

    *3 filas.*

## Ejercicio 43

Contar en cuántas **ciudades** diferentes viven los jugadores.

??? success "Consulta y resultado"

    ```sql
    SELECT COUNT(DISTINCT id_ciudad) AS ciudades
    FROM jugadores;
    ```

    | ciudades |
    | --- |
    | 4 |

    *1 filas.*

## Ejercicio 44

Sacar toda la información de los dos **productos** más caros.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM productos
    ORDER BY precio DESC,id_producto LIMIT 2;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 2 | 1 | 2 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 3 | 1 | 2 |

    *2 filas.*

## Ejercicio 45

Sacar las tres **ciudades** con más **jugadores**.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_ciudad,c.nombre,COUNT(*) AS jugadores
    FROM ciudades c
    JOIN jugadores j ON j.id_ciudad=c.id_ciudad
    GROUP BY c.id_ciudad
    ORDER BY jugadores DESC,c.id_ciudad LIMIT 3;
    ```

    | id_ciudad | nombre | jugadores |
    | --- | --- | --- |
    | 1 | Madrid | 3 |
    | 3 | Barcelona | 2 |
    | 5 | Castellón de la Plana | 2 |

    *3 filas.*

## Ejercicio 46

Sacar el **vendedor** que ha atendido menos **compras**, incluyendo a quienes no han atendido ninguna.

??? success "Consulta y resultado"

    ```sql
    SELECT v.id_vendedor,v.nombre,COUNT(c.id_compra) AS compras
    FROM vendedores v
    LEFT
    JOIN compras c ON c.id_vendedor=v.id_vendedor
    GROUP BY v.id_vendedor
    ORDER BY compras,v.id_vendedor LIMIT 1;
    ```

    | id_vendedor | nombre | compras |
    | --- | --- | --- |
    | 1 | Alicia Damborenea | 0 |

    *1 filas.*

## Ejercicio 47

Sacar las tres **compras** con mayor base sin descuentos ni IVA, sumando `precio_unitario * cantidad` en sus líneas.

??? success "Consulta y resultado"

    ```sql
    SELECT id_compra,SUM(precio_unitario*cantidad) AS base
    FROM lineas_compra
    GROUP BY id_compra
    ORDER BY base DESC,id_compra LIMIT 3;
    ```

    | id_compra | base |
    | --- | --- |
    | 10 | 1899.00 |
    | 7 | 1344.00 |
    | 12 | 1219.90 |

    *3 filas.*

## Ejercicio 48

Repetir lo anterior para sacar todas las compras excepto las tres de mayor base.

??? success "Consulta y resultado"

    ```sql
    SELECT id_compra,SUM(precio_unitario*cantidad) AS base
    FROM lineas_compra
    GROUP BY id_compra
    ORDER BY base DESC,id_compra OFFSET 3;
    ```

    | id_compra | base |
    | --- | --- |
    | 5 | 799.98 |
    | 2 | 524.98 |
    | 11 | 499.99 |
    | 9 | 299.99 |
    | 4 | 149.98 |
    | 3 | 119.97 |
    | 1 | 104.99 |
    | 8 | 90.00 |
    | 6 | 79.97 |

    *9 filas.*

## Ejercicio 49

Crear **PRODUCTO_999x**, sustituyendo 999 por las tres últimas cifras de tu DNI y x por su letra, como copia de **productos**, con los nulos de `stock` y `stock_minimo` sustituidos por 0 mediante `COALESCE`.

??? success "Consulta y resultado"

    ```sql
    CREATE TEMP TABLE producto_999x AS SELECT id_producto,nombre,precio,COALESCE(stock,0) AS stock,COALESCE(stock_minimo,0) AS stock_minimo,id_categoria
    FROM productos; SELECT COUNT(*) AS filas_copiadas
    FROM producto_999x;
    ```

    | filas_copiadas |
    | --- |
    | 12 |

    *1 filas.*

## Ejercicio 50

Usar la tabla anterior para calcular el máximo, mínimo y media de **stock**. Comparar con **productos**, donde los valores nulos no entran en los cálculos.

??? success "Consulta y resultado"

    ```sql
    SELECT MAX(stock) AS maximo,MIN(stock) AS minimo,AVG(stock) AS media
    FROM producto_999x;
    ```

    | maximo | minimo | media |
    | --- | --- | --- |
    | 30 | 0 | 9.2500 |

    *1 filas.*

Descarga las [consultas de solución](../soluciones/sql/juegos-dql-basico.sql).
