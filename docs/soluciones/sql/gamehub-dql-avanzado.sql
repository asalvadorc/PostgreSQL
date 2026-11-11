-- Conexión: gamehub. Carga inicial; ejecutar cada ejercicio por separado.

CREATE OR REPLACE VIEW resumen_compras AS
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

-- Ejercicio 51
SELECT j.nombre,c.id_compra,c.fecha FROM jugadores j JOIN compras c ON c.id_jugador=j.id_jugador ORDER BY c.id_compra;

-- Ejercicio 52
SELECT j.nombre,p.id_producto,p.nombre AS producto FROM jugadores j JOIN compras c ON c.id_jugador=j.id_jugador JOIN lineas_compra l ON l.id_compra=c.id_compra JOIN productos p ON p.id_producto=l.id_producto ORDER BY j.id_jugador,c.id_compra,l.num_linea;

-- Ejercicio 53
SELECT DISTINCT j.id_jugador,j.nombre,p.id_producto,p.nombre AS producto FROM jugadores j JOIN compras c ON c.id_jugador=j.id_jugador JOIN lineas_compra l ON l.id_compra=c.id_compra JOIN productos p ON p.id_producto=l.id_producto ORDER BY j.id_jugador,p.id_producto;

-- Ejercicio 54
SELECT j.id_jugador,j.nombre,COUNT(c.id_compra) AS compras FROM jugadores j LEFT JOIN compras c ON c.id_jugador=j.id_jugador GROUP BY j.id_jugador ORDER BY j.id_jugador;

-- Ejercicio 55
SELECT c.id_compra,c.fecha,c.id_jugador,SUM(l.precio_unitario*l.cantidad) AS base FROM compras c JOIN lineas_compra l ON l.id_compra=c.id_compra GROUP BY c.id_compra ORDER BY c.id_compra;

-- Ejercicio 56
SELECT c.id_compra,SUM(l.precio_unitario*l.cantidad*(1-COALESCE(l.descuento_linea,0)/100.0))*(1-COALESCE(c.descuento,0)/100.0)*(1+COALESCE(c.iva,0)/100.0) AS total FROM compras c JOIN lineas_compra l ON l.id_compra=c.id_compra GROUP BY c.id_compra ORDER BY c.id_compra;

-- Ejercicio 57
SELECT DISTINCT jefe.id_vendedor,jefe.nombre FROM vendedores jefe JOIN vendedores empleado ON empleado.id_jefe=jefe.id_vendedor ORDER BY jefe.id_vendedor;

-- Ejercicio 58
SELECT p.id_producto,p.nombre,c.descripcion AS categoria FROM productos p LEFT JOIN categorias c ON c.id_categoria=p.id_categoria ORDER BY p.id_producto;

-- Ejercicio 59
SELECT c.id_categoria,c.descripcion,COUNT(p.id_producto) AS productos FROM categorias c LEFT JOIN productos p ON p.id_categoria=c.id_categoria GROUP BY c.id_categoria ORDER BY c.id_categoria;

-- Ejercicio 60
SELECT j.id_jugador,j.nombre FROM jugadores j LEFT JOIN compras c ON c.id_jugador=j.id_jugador WHERE c.id_compra IS NULL ORDER BY j.id_jugador;

-- Ejercicio 61
SELECT p.id_producto,p.nombre,COALESCE(SUM(l.cantidad),0) AS unidades FROM productos p LEFT JOIN lineas_compra l ON l.id_producto=p.id_producto GROUP BY p.id_producto ORDER BY p.id_producto;

-- Ejercicio 62
SELECT c.id_ciudad,c.nombre,COUNT(j.id_jugador) AS jugadores FROM ciudades c LEFT JOIN jugadores j ON j.id_ciudad=c.id_ciudad GROUP BY c.id_ciudad ORDER BY c.id_ciudad;

-- Ejercicio 63
SELECT c.id_categoria,c.descripcion FROM categorias c LEFT JOIN productos p ON p.id_categoria=c.id_categoria WHERE p.id_producto IS NULL ORDER BY c.id_categoria;

-- Ejercicio 64
SELECT MAX(n) AS maximo_compras FROM (SELECT COUNT(*) AS n FROM compras GROUP BY id_jugador) AS recuentos;

-- Ejercicio 65
SELECT MAX(total) AS compra_mas_cara,MIN(total) AS compra_mas_barata FROM resumen_compras;

-- Ejercicio 66
SELECT MAX(n) AS maximo_compras FROM (SELECT COUNT(*) AS n FROM compras WHERE fecha>=DATE '2024-07-01' AND fecha<DATE '2025-01-01' GROUP BY id_vendedor) AS recuentos;

-- Ejercicio 67
SELECT * FROM productos WHERE precio>(SELECT AVG(precio) FROM productos) ORDER BY precio DESC,id_producto;

-- Ejercicio 68
SELECT p.* FROM productos p WHERE p.precio>(SELECT AVG(p2.precio) FROM productos p2 WHERE p2.id_categoria=p.id_categoria) ORDER BY p.id_categoria,p.precio DESC,p.id_producto;

-- Ejercicio 69
SELECT c.id_ciudad,c.nombre FROM ciudades c WHERE EXISTS (SELECT 1 FROM jugadores j WHERE j.id_ciudad=c.id_ciudad) AND NOT EXISTS (SELECT 1 FROM vendedores v WHERE v.id_ciudad=c.id_ciudad) ORDER BY c.id_ciudad;

-- Ejercicio 70
SELECT c.id_ciudad,c.nombre FROM ciudades c WHERE (SELECT COUNT(*) FROM vendedores v WHERE v.id_ciudad=c.id_ciudad)>(SELECT COUNT(*) FROM jugadores j WHERE j.id_ciudad=c.id_ciudad) ORDER BY c.id_ciudad;

-- Ejercicio 71
SELECT EXTRACT(QUARTER FROM fecha)::INTEGER AS trimestre,MAX(total) AS total_maximo FROM resumen_compras GROUP BY EXTRACT(QUARTER FROM fecha) ORDER BY trimestre;

-- Ejercicio 72
SELECT v.id_vendedor,v.nombre,(SELECT COUNT(*) FROM compras c WHERE c.id_vendedor=v.id_vendedor) AS compras,COALESCE((SELECT SUM(r.total) FROM resumen_compras r WHERE r.id_vendedor=v.id_vendedor),0) AS total FROM vendedores v ORDER BY v.id_vendedor;

-- Ejercicio 73
SELECT * FROM resumen_compras WHERE total=(SELECT MAX(total) FROM resumen_compras) ORDER BY id_compra;

-- Ejercicio 74
WITH ventas AS (SELECT p.id_categoria,c.id_vendedor,SUM(l.cantidad) AS unidades FROM productos p JOIN lineas_compra l ON l.id_producto=p.id_producto JOIN compras c ON c.id_compra=l.id_compra GROUP BY p.id_categoria,c.id_vendedor) SELECT x.id_categoria,v.nombre,x.unidades FROM ventas x JOIN vendedores v ON v.id_vendedor=x.id_vendedor WHERE x.unidades=(SELECT MAX(y.unidades) FROM ventas y WHERE y.id_categoria=x.id_categoria) ORDER BY x.id_categoria,x.id_vendedor;

-- Ejercicio 75
SELECT j.nombre FROM jugadores j JOIN compras c ON c.id_jugador=j.id_jugador UNION SELECT v.nombre FROM vendedores v JOIN compras c ON c.id_vendedor=v.id_vendedor ORDER BY nombre;

-- Ejercicio 76a
SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN jugadores j ON j.id_ciudad=c.id_ciudad UNION SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN vendedores v ON v.id_ciudad=c.id_ciudad ORDER BY id_ciudad;

-- Ejercicio 76b
SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN jugadores j ON j.id_ciudad=c.id_ciudad INTERSECT SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN vendedores v ON v.id_ciudad=c.id_ciudad ORDER BY id_ciudad;

-- Ejercicio 76c
SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN vendedores v ON v.id_ciudad=c.id_ciudad EXCEPT SELECT c.id_ciudad,c.nombre FROM ciudades c JOIN jugadores j ON j.id_ciudad=c.id_ciudad ORDER BY id_ciudad;
