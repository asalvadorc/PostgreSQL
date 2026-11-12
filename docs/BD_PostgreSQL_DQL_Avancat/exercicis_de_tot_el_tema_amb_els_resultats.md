# Soluciones y resultados: DQL avanzado

Estas soluciones utilizan **Juegos** con su carga inicial: 8 jugadores, 12 compras y 28 líneas. Los resultados se han calculado ejecutando las consultas en un motor PostgreSQL. Los decimales largos se muestran con un máximo de cuatro cifras decimales; los cálculos usan su precisión completa.

Si has modificado los datos, [restaura la carga inicial](../BD_PostgreSQL_DML/1_introducci.md) antes de comparar. Un resultado vacío también puede ser correcto. No se utilizan capturas de otra base de datos.

Los ejercicios de importes utilizan esta vista. Si ya existe la vista del tema DDL con la misma definición, no vuelvas a crearla.

```sql
CREATE VIEW resumen_compras AS
SELECT c.id_compra, c.fecha, c.id_jugador, c.id_vendedor,
       SUM(l.cantidad * l.precio_unitario) AS base_sin_descuentos,
       SUM(l.cantidad * l.precio_unitario *
           (1 - COALESCE(l.descuento_linea, 0) / 100.0)) AS base_descuento_lineas,
       SUM(l.cantidad * l.precio_unitario *
           (1 - COALESCE(l.descuento_linea, 0) / 100.0)) *
           (1 - COALESCE(c.descuento, 0) / 100.0) AS base_descuento_general,
       SUM(l.cantidad * l.precio_unitario *
           (1 - COALESCE(l.descuento_linea, 0) / 100.0)) *
           (1 - COALESCE(c.descuento, 0) / 100.0) *
           (1 + COALESCE(c.iva, 0) / 100.0) AS total
FROM compras AS c
JOIN lineas_compra AS l ON l.id_compra = c.id_compra
GROUP BY c.id_compra;
```

## Ejercicio 51

Sacar el nombre del jugador, el código y la fecha de cada compra.

??? success "Consulta y resultado"

    ```sql
    SELECT j.nombre,c.id_compra,c.fecha
    FROM jugadores j
    JOIN compras c ON c.id_jugador=j.id_jugador
    ORDER BY c.id_compra;
    ```

    | nombre | id_compra | fecha |
    | --- | --- | --- |
    | Juan Pérez López | 1 | 2024-01-10 |
    | Álex García Torres | 2 | 2024-01-15 |
    | Marta Sánchez Vidal | 3 | 2024-02-05 |
    | Álex García Torres | 4 | 2024-03-04 |
    | Luis Villalonga García | 5 | 2024-03-12 |
    | Sara Vidal Villalonga | 6 | 2024-03-20 |
    | Álex García Torres | 7 | 2024-07-02 |
    | Noa López Serra | 8 | 2024-09-10 |
    | Hugo Martín Ruiz | 9 | 2024-10-01 |
    | Juan Pérez López | 10 | 2024-10-15 |
    | Marta Sánchez Vidal | 11 | 2024-11-05 |
    | Álex García Torres | 12 | 2024-12-02 |

    *12 filas.*

## Ejercicio 52

Sacar el nombre de cada jugador y los productos que ha comprado, permitiendo repeticiones.

??? success "Consulta y resultado"

    ```sql
    SELECT j.nombre,p.id_producto,p.nombre AS producto
    FROM jugadores j
    JOIN compras c ON c.id_jugador=j.id_jugador
    JOIN lineas_compra l ON l.id_compra=c.id_compra
    JOIN productos p ON p.id_producto=l.id_producto
    ORDER BY j.id_jugador,c.id_compra,l.num_linea;
    ```

    | nombre | id_producto | producto |
    | --- | --- | --- |
    | Juan Pérez López | 1 | Elden Ring |
    | Juan Pérez López | 5 | RZ Mouse: DeathAdder |
    | Juan Pérez López | 12 | PC Gaming: RTX 4080 |
    | Marta Sánchez Vidal | 2 | Minecraft |
    | Marta Sánchez Vidal | 8 | Mando: Xbox Wireless |
    | Marta Sánchez Vidal | 3 | PlayStation 5 |
    | Luis Villalonga García | 3 | PlayStation 5 |
    | Luis Villalonga García | 4 | Nintendo Switch |
    | Sara Vidal Villalonga | 2 | Minecraft |
    | Sara Vidal Villalonga | 10 | Figura: Hollow Knight |
    | Álex García Torres | 3 | PlayStation 5 |
    | Álex García Torres | 10 | Figura: Hollow Knight |
    | Álex García Torres | 1 | Elden Ring |
    | Álex García Torres | 6 | RZ Teclado: BlackWidow |
    | Álex García Torres | 11 | PC Gaming: RTX 4070 |
    | Álex García Torres | 5 | RZ Mouse: DeathAdder |
    | Álex García Torres | 1 | Elden Ring |
    | Álex García Torres | 2 | Minecraft |
    | Álex García Torres | 3 | PlayStation 5 |
    | Álex García Torres | 4 | Nintendo Switch |
    | Álex García Torres | 5 | RZ Mouse: DeathAdder |
    | Álex García Torres | 6 | RZ Teclado: BlackWidow |
    | Álex García Torres | 7 | Auriculares: HyperX Cloud |
    | Álex García Torres | 8 | Mando: Xbox Wireless |
    | Álex García Torres | 9 | Camiseta: Creeper |
    | Álex García Torres | 10 | Figura: Hollow Knight |
    | Noa López Serra | 5 | RZ Mouse: DeathAdder |
    | Hugo Martín Ruiz | 4 | Nintendo Switch |

    *28 filas.*

## Ejercicio 53

Repetir la consulta anterior sin repetir una combinación de jugador y producto.

??? success "Consulta y resultado"

    ```sql
    SELECT DISTINCT j.id_jugador,j.nombre,p.id_producto,p.nombre AS producto
    FROM jugadores j
    JOIN compras c ON c.id_jugador=j.id_jugador
    JOIN lineas_compra l ON l.id_compra=c.id_compra
    JOIN productos p ON p.id_producto=l.id_producto
    ORDER BY j.id_jugador,p.id_producto;
    ```

    | id_jugador | nombre | id_producto | producto |
    | --- | --- | --- | --- |
    | 1 | Juan Pérez López | 1 | Elden Ring |
    | 1 | Juan Pérez López | 5 | RZ Mouse: DeathAdder |
    | 1 | Juan Pérez López | 12 | PC Gaming: RTX 4080 |
    | 2 | Marta Sánchez Vidal | 2 | Minecraft |
    | 2 | Marta Sánchez Vidal | 3 | PlayStation 5 |
    | 2 | Marta Sánchez Vidal | 8 | Mando: Xbox Wireless |
    | 3 | Luis Villalonga García | 3 | PlayStation 5 |
    | 3 | Luis Villalonga García | 4 | Nintendo Switch |
    | 4 | Sara Vidal Villalonga | 2 | Minecraft |
    | 4 | Sara Vidal Villalonga | 10 | Figura: Hollow Knight |
    | 5 | Álex García Torres | 1 | Elden Ring |
    | 5 | Álex García Torres | 2 | Minecraft |
    | 5 | Álex García Torres | 3 | PlayStation 5 |
    | 5 | Álex García Torres | 4 | Nintendo Switch |
    | 5 | Álex García Torres | 5 | RZ Mouse: DeathAdder |
    | 5 | Álex García Torres | 6 | RZ Teclado: BlackWidow |
    | 5 | Álex García Torres | 7 | Auriculares: HyperX Cloud |
    | 5 | Álex García Torres | 8 | Mando: Xbox Wireless |
    | 5 | Álex García Torres | 9 | Camiseta: Creeper |
    | 5 | Álex García Torres | 10 | Figura: Hollow Knight |
    | 5 | Álex García Torres | 11 | PC Gaming: RTX 4070 |
    | 6 | Noa López Serra | 5 | RZ Mouse: DeathAdder |
    | 7 | Hugo Martín Ruiz | 4 | Nintendo Switch |

    *23 filas.*

## Ejercicio 54

Sacar todos los jugadores con su número de compras, incluyendo quienes no han comprado.

??? success "Consulta y resultado"

    ```sql
    SELECT j.id_jugador,j.nombre,COUNT(c.id_compra) AS compras
    FROM jugadores j
    LEFT
    JOIN compras c ON c.id_jugador=j.id_jugador
    GROUP BY j.id_jugador
    ORDER BY j.id_jugador;
    ```

    | id_jugador | nombre | compras |
    | --- | --- | --- |
    | 1 | Juan Pérez López | 2 |
    | 2 | Marta Sánchez Vidal | 2 |
    | 3 | Luis Villalonga García | 1 |
    | 4 | Sara Vidal Villalonga | 1 |
    | 5 | Álex García Torres | 4 |
    | 6 | Noa López Serra | 1 |
    | 7 | Hugo Martín Ruiz | 1 |
    | 8 | Paula Serra Gil | 0 |

    *8 filas.*

## Ejercicio 55

Sacar el código, la fecha, el jugador y la base sin descuentos ni IVA de cada compra.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_compra,c.fecha,c.id_jugador,SUM(l.precio_unitario*l.cantidad) AS base
    FROM compras c
    JOIN lineas_compra l ON l.id_compra=c.id_compra
    GROUP BY c.id_compra
    ORDER BY c.id_compra;
    ```

    | id_compra | fecha | id_jugador | base |
    | --- | --- | --- | --- |
    | 1 | 2024-01-10 | 1 | 104.99 |
    | 2 | 2024-01-15 | 5 | 524.98 |
    | 3 | 2024-02-05 | 2 | 119.97 |
    | 4 | 2024-03-04 | 5 | 149.98 |
    | 5 | 2024-03-12 | 3 | 799.98 |
    | 6 | 2024-03-20 | 4 | 79.97 |
    | 7 | 2024-07-02 | 5 | 1344.00 |
    | 8 | 2024-09-10 | 6 | 90.00 |
    | 9 | 2024-10-01 | 7 | 299.99 |
    | 10 | 2024-10-15 | 1 | 1899.00 |
    | 11 | 2024-11-05 | 2 | 499.99 |
    | 12 | 2024-12-02 | 5 | 1219.90 |

    *12 filas.*

## Ejercicio 56

Calcular el total final de cada compra: descuento de líneas, descuento general y finalmente IVA.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_compra,SUM(l.precio_unitario*l.cantidad*(1-COALESCE(l.descuento_linea,0)/100.0))*(1-COALESCE(c.descuento,0)/100.0)*(1+COALESCE(c.iva,0)/100.0) AS total
    FROM compras c
    JOIN lineas_compra l ON l.id_compra=c.id_compra
    GROUP BY c.id_compra
    ORDER BY c.id_compra;
    ```

    | id_compra | total |
    | --- | --- |
    | 1 | 124.3154 |
    | 2 | 517.2543 |
    | 3 | 141.5343 |
    | 4 | 168.9541 |
    | 5 | 967.9758 |
    | 6 | 90.7161 |
    | 7 | 1461.1658 |
    | 8 | 108.9000 |
    | 9 | 344.8385 |
    | 10 | 2068.0110 |
    | 11 | 514.2397 |
    | 12 | 1466.7033 |

    *12 filas.*

## Ejercicio 57

Sacar el código y nombre de los vendedores que supervisan a otro vendedor.

??? success "Consulta y resultado"

    ```sql
    SELECT DISTINCT jefe.id_vendedor,jefe.nombre
    FROM vendedores jefe
    JOIN vendedores empleado ON empleado.id_jefe=jefe.id_vendedor
    ORDER BY jefe.id_vendedor;
    ```

    | id_vendedor | nombre |
    | --- | --- |
    | 1 | Alicia Damborenea |

    *1 filas.*

## Ejercicio 58

Sacar los productos y su categoría, incluyendo productos sin categoría.

??? success "Consulta y resultado"

    ```sql
    SELECT p.id_producto,p.nombre,c.descripcion AS categoria
    FROM productos p
    LEFT
    JOIN categorias c ON c.id_categoria=p.id_categoria
    ORDER BY p.id_producto;
    ```

    | id_producto | nombre | categoria |
    | --- | --- | --- |
    | 1 | Elden Ring | Videojuegos |
    | 2 | Minecraft | Videojuegos |
    | 3 | PlayStation 5 | Consolas |
    | 4 | Nintendo Switch | Consolas |
    | 5 | RZ Mouse: DeathAdder | Periféricos |
    | 6 | RZ Teclado: BlackWidow | Periféricos |
    | 7 | Auriculares: HyperX Cloud | Periféricos |
    | 8 | Mando: Xbox Wireless | Periféricos |
    | 9 | Camiseta: Creeper | Merchandising |
    | 10 | Figura: Hollow Knight | Merchandising |
    | 11 | PC Gaming: RTX 4070 | Consolas |
    | 12 | PC Gaming: RTX 4080 | Consolas |

    *12 filas.*

## Ejercicio 59

Sacar las categorías y su número de productos, incluyendo las vacías.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_categoria,c.descripcion,COUNT(p.id_producto) AS productos
    FROM categorias c
    LEFT
    JOIN productos p ON p.id_categoria=c.id_categoria
    GROUP BY c.id_categoria
    ORDER BY c.id_categoria;
    ```

    | id_categoria | descripcion | productos |
    | --- | --- | --- |
    | 1 | Videojuegos | 2 |
    | 2 | Consolas | 4 |
    | 3 | Periféricos | 4 |
    | 4 | Merchandising | 2 |

    *4 filas.*

## Ejercicio 60

Sacar los jugadores que no han realizado compras.

??? success "Consulta y resultado"

    ```sql
    SELECT j.id_jugador,j.nombre
    FROM jugadores j
    LEFT
    JOIN compras c ON c.id_jugador=j.id_jugador
    WHERE c.id_compra IS NULL
    ORDER BY j.id_jugador;
    ```

    | id_jugador | nombre |
    | --- | --- |
    | 8 | Paula Serra Gil |

    *1 filas.*

## Ejercicio 61

Sacar todos los productos y sus unidades vendidas, mostrando 0 si no tienen ventas.

??? success "Consulta y resultado"

    ```sql
    SELECT p.id_producto,p.nombre,COALESCE(SUM(l.cantidad),0) AS unidades
    FROM productos p
    LEFT
    JOIN lineas_compra l ON l.id_producto=p.id_producto
    GROUP BY p.id_producto
    ORDER BY p.id_producto;
    ```

    | id_producto | nombre | unidades |
    | --- | --- | --- |
    | 1 | Elden Ring | 3 |
    | 2 | Minecraft | 4 |
    | 3 | PlayStation 5 | 4 |
    | 4 | Nintendo Switch | 3 |
    | 5 | RZ Mouse: DeathAdder | 5 |
    | 6 | RZ Teclado: BlackWidow | 2 |
    | 7 | Auriculares: HyperX Cloud | 1 |
    | 8 | Mando: Xbox Wireless | 2 |
    | 9 | Camiseta: Creeper | 2 |
    | 10 | Figura: Hollow Knight | 4 |
    | 11 | PC Gaming: RTX 4070 | 1 |
    | 12 | PC Gaming: RTX 4080 | 1 |

    *12 filas.*

## Ejercicio 62

Sacar todas las ciudades con su número de jugadores, incluyendo las que no tienen ninguno.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_ciudad,c.nombre,COUNT(j.id_jugador) AS jugadores
    FROM ciudades c
    LEFT
    JOIN jugadores j ON j.id_ciudad=c.id_ciudad
    GROUP BY c.id_ciudad
    ORDER BY c.id_ciudad;
    ```

    | id_ciudad | nombre | jugadores |
    | --- | --- | --- |
    | 1 | Madrid | 3 |
    | 2 | Alcalá de Henares | 1 |
    | 3 | Barcelona | 2 |
    | 4 | Terrassa | 0 |
    | 5 | Castellón de la Plana | 2 |
    | 6 | Vila-real | 0 |

    *6 filas.*

## Ejercicio 63

Sacar las categorías sin productos. Un resultado vacío puede ser correcto con estos datos.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_categoria,c.descripcion
    FROM categorias c
    LEFT
    JOIN productos p ON p.id_categoria=c.id_categoria
    WHERE p.id_producto IS NULL
    ORDER BY c.id_categoria;
    ```

    *Resultado: 0 filas con los datos iniciales.*

## Ejercicio 64

Sacar el mayor número de compras realizadas por un mismo jugador.

??? success "Consulta y resultado"

    ```sql
    SELECT MAX(n) AS maximo_compras
    FROM (SELECT COUNT(*) AS n
    FROM compras
    GROUP BY id_jugador) AS recuentos;
    ```

    | maximo_compras |
    | --- |
    | 4 |

    *1 filas.*

## Ejercicio 65

Sacar el importe de la compra más cara y de la más barata, usando los totales finales.

??? success "Consulta y resultado"

    ```sql
    SELECT MAX(total) AS compra_mas_cara,MIN(total) AS compra_mas_barata
    FROM resumen_compras;
    ```

    | compra_mas_cara | compra_mas_barata |
    | --- | --- |
    | 2068.0110 | 90.7161 |

    *1 filas.*

## Ejercicio 66

Sacar el mayor número de compras atendidas por un vendedor en el segundo semestre de 2024.

??? success "Consulta y resultado"

    ```sql
    SELECT MAX(n) AS maximo_compras
    FROM (SELECT COUNT(*) AS n
    FROM compras
    WHERE fecha>=DATE '2024-07-01' AND fecha<DATE '2025-01-01'
    GROUP BY id_vendedor) AS recuentos;
    ```

    | maximo_compras |
    | --- |
    | 3 |

    *1 filas.*

## Ejercicio 67

Sacar los productos con precio superior a la media global, ordenados por precio descendente.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM productos
    WHERE precio>(SELECT AVG(precio)
    FROM productos)
    ORDER BY precio DESC,id_producto;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 2 | 1 | 2 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 3 | 1 | 2 |
    | 3 | PlayStation 5 | 499.99 | 6 | 2 | 2 |

    *3 filas.*

## Ejercicio 68

Sacar los productos con precio superior a la media de su propia categoría.

??? success "Consulta y resultado"

    ```sql
    SELECT p.*
    FROM productos p
    WHERE p.precio>(SELECT AVG(p2.precio)
    FROM productos p2
    WHERE p2.id_categoria=p.id_categoria)
    ORDER BY p.id_categoria,p.precio DESC,p.id_producto;
    ```

    | id_producto | nombre | precio | stock | stock_minimo | id_categoria |
    | --- | --- | --- | --- | --- | --- |
    | 1 | Elden Ring | 59.99 | 20 | 5 | 1 |
    | 12 | PC Gaming: RTX 4080 | 1899.00 | 2 | 1 | 2 |
    | 11 | PC Gaming: RTX 4070 | 1299.00 | 3 | 1 | 2 |
    | 6 | RZ Teclado: BlackWidow | 89.99 | 5 | 2 | 3 |
    | 7 | Auriculares: HyperX Cloud | 69.99 | NULL | 2 | 3 |
    | 10 | Figura: Hollow Knight | 24.99 | 10 | 2 | 4 |

    *6 filas.*

## Ejercicio 69

Sacar las ciudades donde hay jugadores pero no vendedores, usando EXISTS y NOT EXISTS.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_ciudad,c.nombre
    FROM ciudades c
    WHERE EXISTS (SELECT 1
    FROM jugadores j
    WHERE j.id_ciudad=c.id_ciudad) AND NOT EXISTS (SELECT 1
    FROM vendedores v
    WHERE v.id_ciudad=c.id_ciudad)
    ORDER BY c.id_ciudad;
    ```

    | id_ciudad | nombre |
    | --- | --- |
    | 2 | Alcalá de Henares |

    *1 filas.*

## Ejercicio 70

Sacar las ciudades con más vendedores que jugadores. Con los datos iniciales puede no haber ninguna.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_ciudad,c.nombre
    FROM ciudades c
    WHERE (SELECT COUNT(*)
    FROM vendedores v
    WHERE v.id_ciudad=c.id_ciudad)>(SELECT COUNT(*)
    FROM jugadores j
    WHERE j.id_ciudad=c.id_ciudad)
    ORDER BY c.id_ciudad;
    ```

    *Resultado: 0 filas con los datos iniciales.*

## Ejercicio 71

Sacar el importe máximo de compra de cada trimestre.

??? success "Consulta y resultado"

    ```sql
    SELECT EXTRACT(QUARTER
    FROM fecha)::INTEGER AS trimestre,MAX(total) AS total_maximo
    FROM resumen_compras
    GROUP BY EXTRACT(QUARTER
    FROM fecha)
    ORDER BY trimestre;
    ```

    | trimestre | total_maximo |
    | --- | --- |
    | 1 | 967.9758 |
    | 3 | 1461.1658 |
    | 4 | 2068.0110 |

    *3 filas.*

## Ejercicio 72

Sacar todos los vendedores, su número de compras y su importe total vendido, incluyendo ceros.

??? success "Consulta y resultado"

    ```sql
    SELECT v.id_vendedor,v.nombre,(SELECT COUNT(*)
    FROM compras c
    WHERE c.id_vendedor=v.id_vendedor) AS compras,COALESCE((SELECT SUM(r.total)
    FROM resumen_compras r
    WHERE r.id_vendedor=v.id_vendedor),0) AS total
    FROM vendedores v
    ORDER BY v.id_vendedor;
    ```

    | id_vendedor | nombre | compras | total |
    | --- | --- | --- | --- |
    | 1 | Alicia Damborenea | 0 | 0 |
    | 2 | Marcos Vidal | 6 | 3554.0695 |
    | 3 | Elena García | 6 | 4420.5388 |

    *3 filas.*

## Ejercicio 73

Sacar toda la información de la compra de mayor importe. Incluir todas si hay empate.

??? success "Consulta y resultado"

    ```sql
    SELECT *
    FROM resumen_compras
    WHERE total=(SELECT MAX(total)
    FROM resumen_compras)
    ORDER BY id_compra;
    ```

    | id_compra | fecha | id_jugador | id_vendedor | base_sin_descuentos | base_descuento_lineas | base_descuento_general | total |
    | --- | --- | --- | --- | --- | --- | --- | --- |
    | 10 | 2024-10-15 | 1 | 3 | 1899.00 | 1709.1000 | 1709.1000 | 2068.0110 |

    *1 filas.*

## Ejercicio 74

Voluntario: sacar el vendedor con más unidades vendidas de cada categoría, incluyendo empates.

??? success "Consulta y resultado"

    ```sql
    WITH ventas AS (SELECT p.id_categoria,c.id_vendedor,SUM(l.cantidad) AS unidades
    FROM productos p
    JOIN lineas_compra l ON l.id_producto=p.id_producto
    JOIN compras c ON c.id_compra=l.id_compra
    GROUP BY p.id_categoria,c.id_vendedor) SELECT x.id_categoria,v.nombre,x.unidades
    FROM ventas x
    JOIN vendedores v ON v.id_vendedor=x.id_vendedor
    WHERE x.unidades=(SELECT MAX(y.unidades)
    FROM ventas y
    WHERE y.id_categoria=x.id_categoria)
    ORDER BY x.id_categoria,x.id_vendedor;
    ```

    | id_categoria | nombre | unidades |
    | --- | --- | --- |
    | 1 | Elena García | 4 |
    | 2 | Marcos Vidal | 5 |
    | 3 | Elena García | 7 |
    | 4 | Elena García | 6 |

    *4 filas.*

## Ejercicio 75

Sacar sin repeticiones los nombres de jugadores y vendedores que participan en alguna compra.

??? success "Consulta y resultado"

    ```sql
    SELECT j.nombre
    FROM jugadores j
    JOIN compras c ON c.id_jugador=j.id_jugador
    UNION SELECT v.nombre
    FROM vendedores v
    JOIN compras c ON c.id_vendedor=v.id_vendedor
    ORDER BY nombre;
    ```

    | nombre |
    | --- |
    | Elena García |
    | Hugo Martín Ruiz |
    | Juan Pérez López |
    | Luis Villalonga García |
    | Marcos Vidal |
    | Marta Sánchez Vidal |
    | Noa López Serra |
    | Sara Vidal Villalonga |
    | Álex García Torres |

    *9 filas.*

## Ejercicio 76a

Sacar mediante UNION las ciudades donde hay jugadores o vendedores.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_ciudad,c.nombre
    FROM ciudades c
    JOIN jugadores j ON j.id_ciudad=c.id_ciudad
    UNION SELECT c.id_ciudad,c.nombre
    FROM ciudades c
    JOIN vendedores v ON v.id_ciudad=c.id_ciudad
    ORDER BY id_ciudad;
    ```

    | id_ciudad | nombre |
    | --- | --- |
    | 1 | Madrid |
    | 2 | Alcalá de Henares |
    | 3 | Barcelona |
    | 5 | Castellón de la Plana |

    *4 filas.*

## Ejercicio 76b

Sacar mediante INTERSECT las ciudades donde hay jugadores y también vendedores.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_ciudad,c.nombre
    FROM ciudades c
    JOIN jugadores j ON j.id_ciudad=c.id_ciudad
    INTERSECT SELECT c.id_ciudad,c.nombre
    FROM ciudades c
    JOIN vendedores v ON v.id_ciudad=c.id_ciudad
    ORDER BY id_ciudad;
    ```

    | id_ciudad | nombre |
    | --- | --- |
    | 1 | Madrid |
    | 3 | Barcelona |
    | 5 | Castellón de la Plana |

    *3 filas.*

## Ejercicio 76c

Sacar mediante EXCEPT las ciudades donde hay vendedores pero no jugadores.

??? success "Consulta y resultado"

    ```sql
    SELECT c.id_ciudad,c.nombre
    FROM ciudades c
    JOIN vendedores v ON v.id_ciudad=c.id_ciudad
    EXCEPT SELECT c.id_ciudad,c.nombre
    FROM ciudades c
    JOIN jugadores j ON j.id_ciudad=c.id_ciudad
    ORDER BY id_ciudad;
    ```

    *Resultado: 0 filas con los datos iniciales.*

Descarga las [consultas de solución](../soluciones/sql/juegos-dql-avanzado.sql).
