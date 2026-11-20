-- Conexión: juegos. Carga inicial; ejecutar cada ejercicio por separado.

-- Ejercicio 1
SELECT * FROM productos ORDER BY id_producto;

-- Ejercicio 2
SELECT id_vendedor, nombre, id_ciudad FROM vendedores ORDER BY id_vendedor;

-- Ejercicio 3
SELECT id_producto, nombre, precio, precio * 1.05 AS precio_incrementado FROM productos ORDER BY id_producto;

-- Ejercicio 4
SELECT nombre || '. ' || COALESCE(direccion, '(sin dirección)') || ' (' || COALESCE(codigo_postal, 'sin CP') || ')' AS jugador FROM jugadores ORDER BY id_jugador;

-- Ejercicio 5
SELECT id_compra AS "Número Compra", fecha AS "Fecha", id_vendedor AS "Código Vendedor" FROM compras ORDER BY id_compra;

-- Ejercicio 6
SELECT id_producto AS "Código", nombre AS "Producto", precio AS "Precio", stock AS "Stock", stock_minimo AS "Stock mínimo", id_categoria AS "Categoría" FROM productos ORDER BY id_producto;

-- Ejercicio 7
SELECT j.* FROM jugadores j JOIN ciudades c ON c.id_ciudad=j.id_ciudad WHERE c.nombre='Madrid' ORDER BY j.id_jugador;

-- Ejercicio 8
SELECT * FROM compras WHERE fecha >= DATE '2024-03-01' AND fecha < DATE '2024-04-01' ORDER BY id_compra;

-- Ejercicio 9
SELECT p.* FROM productos p JOIN categorias c ON c.id_categoria=p.id_categoria WHERE c.descripcion='Consolas' AND p.stock BETWEEN 2 AND 7 ORDER BY p.id_producto;

-- Ejercicio 10
SELECT * FROM jugadores WHERE direccion IS NULL ORDER BY id_jugador;

-- Ejercicio 11
SELECT * FROM productos WHERE stock IS NOT NULL AND stock_minimo IS NULL ORDER BY id_producto;

-- Ejercicio 12
SELECT * FROM jugadores WHERE nombre ILIKE '%Villalonga%' ORDER BY id_jugador;

-- Ejercicio 13
SELECT * FROM jugadores WHERE nombre NOT ILIKE '%Villalonga%' ORDER BY id_jugador;

-- Ejercicio 14
SELECT * FROM productos WHERE nombre LIKE 'RZ%' AND precio BETWEEN 20 AND 100 AND stock>stock_minimo ORDER BY id_producto;

-- Ejercicio 15
SELECT COUNT(*) AS jugadores_sin_datos FROM jugadores WHERE direccion IS NULL OR codigo_postal IS NULL;

-- Ejercicio 16
SELECT COUNT(*) AS apariciones, SUM(cantidad) AS unidades FROM lineas_compra WHERE id_producto=10;

-- Ejercicio 17
SELECT AVG(stock) AS stock_medio FROM productos;

-- Ejercicio 18
SELECT AVG(COALESCE(stock,0)) AS stock_medio FROM productos;

-- Ejercicio 19
SELECT COUNT(*) AS compras FROM compras WHERE id_jugador=5;

-- Ejercicio 20
SELECT MAX(descuento) AS maximo, MIN(descuento) AS minimo, AVG(descuento) AS media FROM compras;

-- Ejercicio 21
SELECT p.nombre AS provincia, COUNT(*) AS jugadores FROM jugadores j JOIN ciudades c ON c.id_ciudad=j.id_ciudad JOIN provincias p ON p.id_provincia=c.id_provincia GROUP BY p.id_provincia ORDER BY p.id_provincia;

-- Ejercicio 22
SELECT c.nombre AS ciudad, j.codigo_postal, COUNT(*) AS jugadores FROM jugadores j JOIN ciudades c ON c.id_ciudad=j.id_ciudad GROUP BY c.id_ciudad,j.codigo_postal ORDER BY c.id_ciudad,j.codigo_postal;

-- Ejercicio 23
SELECT id_vendedor,id_jugador,COUNT(*) AS compras FROM compras GROUP BY id_vendedor,id_jugador ORDER BY id_vendedor,id_jugador;

-- Ejercicio 24
SELECT TO_CHAR(fecha,'Q') AS trimestre,COUNT(*) AS compras FROM compras GROUP BY TO_CHAR(fecha,'Q') ORDER BY trimestre;

-- Ejercicio 25
SELECT id_producto, COUNT(*) AS lineas, SUM(cantidad) AS unidades, MAX(cantidad) AS maxima, MIN(cantidad) AS minima FROM lineas_compra GROUP BY id_producto ORDER BY id_producto;

-- Ejercicio 26
SELECT c.id_categoria,c.descripcion,COUNT(p.id_producto) AS productos,AVG(p.precio) AS precio_medio FROM categorias c LEFT JOIN productos p ON p.id_categoria=c.id_categoria GROUP BY c.id_categoria ORDER BY c.id_categoria;

-- Ejercicio 27
SELECT id_compra,SUM(precio_unitario*cantidad) AS base FROM lineas_compra GROUP BY id_compra ORDER BY id_compra;

-- Ejercicio 28
SELECT id_producto,AVG(cantidad) AS media FROM lineas_compra GROUP BY id_producto HAVING COUNT(*)>2 ORDER BY id_producto;

-- Ejercicio 29
SELECT c.nombre, COUNT(*) AS jugadores FROM ciudades c JOIN jugadores j ON j.id_ciudad=c.id_ciudad GROUP BY c.id_ciudad HAVING COUNT(*) BETWEEN 3 AND 7 ORDER BY c.id_ciudad;

-- Ejercicio 30
SELECT c.id_categoria,c.descripcion,COUNT(*) AS productos_caros FROM categorias c JOIN productos p ON p.id_categoria=c.id_categoria WHERE p.precio>500 GROUP BY c.id_categoria HAVING COUNT(*)>1 ORDER BY c.id_categoria;

-- Ejercicio 31
SELECT id_jugador,COUNT(*) AS compras FROM compras GROUP BY id_jugador HAVING COUNT(*)>1 ORDER BY id_jugador;

-- Ejercicio 32
SELECT id_jugador,COUNT(*) AS compras FROM compras WHERE fecha>=DATE '2024-01-01' AND fecha<DATE '2024-04-01' GROUP BY id_jugador HAVING COUNT(*)>1 ORDER BY id_jugador;

-- Ejercicio 33
SELECT id_compra,SUM(precio_unitario*cantidad) AS base, SUM(precio_unitario*cantidad*(1-COALESCE(descuento_linea,0)/100.0)) AS base_con_descuentos FROM lineas_compra GROUP BY id_compra HAVING COUNT(*)>=10 ORDER BY id_compra;

-- Ejercicio 34
SELECT * FROM jugadores ORDER BY id_ciudad,codigo_postal,id_jugador;

-- Ejercicio 35
SELECT * FROM productos ORDER BY id_categoria,stock,precio DESC,id_producto;

-- Ejercicio 36
SELECT id_compra,SUM(precio_unitario*cantidad) AS base,SUM(precio_unitario*cantidad*(1-COALESCE(descuento_linea,0)/100.0)) AS base_con_descuentos FROM lineas_compra GROUP BY id_compra HAVING COUNT(*)>=10 ORDER BY base_con_descuentos DESC,id_compra;

-- Ejercicio 37
SELECT * FROM productos ORDER BY COALESCE(stock,0)-COALESCE(stock_minimo,0) DESC,id_producto;

-- Ejercicio 38
SELECT id_vendedor,COUNT(*) AS compras FROM compras WHERE fecha>=DATE '2024-07-01' AND fecha<DATE '2025-01-01' GROUP BY id_vendedor ORDER BY compras DESC,id_vendedor;

-- Ejercicio 39
SELECT DISTINCT v.id_vendedor,v.nombre FROM vendedores v JOIN compras c ON c.id_vendedor=v.id_vendedor WHERE c.fecha>=DATE '2024-01-01' AND c.fecha<DATE '2024-02-01' ORDER BY v.id_vendedor;

-- Ejercicio 40
SELECT DISTINCT c.id_vendedor,l.descuento_linea FROM compras c JOIN lineas_compra l ON l.id_compra=c.id_compra WHERE c.fecha>=DATE '2024-01-01' AND c.fecha<DATE '2024-02-01' ORDER BY c.id_vendedor,l.descuento_linea;

-- Ejercicio 41
SELECT DISTINCT id_jefe FROM vendedores WHERE id_jefe IS NOT NULL ORDER BY id_jefe;

-- Ejercicio 42
SELECT DISTINCT p.id_producto,l.descuento_linea FROM productos p JOIN lineas_compra l ON l.id_producto=p.id_producto WHERE p.nombre LIKE 'RZ%' ORDER BY p.id_producto,l.descuento_linea;

-- Ejercicio 43
SELECT COUNT(DISTINCT id_ciudad) AS ciudades FROM jugadores;

-- Ejercicio 44
SELECT * FROM productos ORDER BY precio DESC,id_producto LIMIT 2;

-- Ejercicio 45
SELECT c.id_ciudad,c.nombre,COUNT(*) AS jugadores FROM ciudades c JOIN jugadores j ON j.id_ciudad=c.id_ciudad GROUP BY c.id_ciudad ORDER BY jugadores DESC,c.id_ciudad LIMIT 3;

-- Ejercicio 46
SELECT v.id_vendedor,v.nombre,COUNT(c.id_compra) AS compras FROM vendedores v LEFT JOIN compras c ON c.id_vendedor=v.id_vendedor GROUP BY v.id_vendedor ORDER BY compras,v.id_vendedor LIMIT 1;

-- Ejercicio 47
SELECT id_compra,SUM(precio_unitario*cantidad) AS base FROM lineas_compra GROUP BY id_compra ORDER BY base DESC,id_compra LIMIT 3;

-- Ejercicio 48
SELECT id_compra,SUM(precio_unitario*cantidad) AS base FROM lineas_compra GROUP BY id_compra ORDER BY base DESC,id_compra OFFSET 3;

-- Ejercicio 49
CREATE TEMP TABLE producto_999x AS SELECT id_producto,nombre,precio,COALESCE(stock,0) AS stock,COALESCE(stock_minimo,0) AS stock_minimo,id_categoria FROM productos; SELECT COUNT(*) AS filas_copiadas FROM producto_999x;

-- Ejercicio 50
SELECT MAX(stock) AS maximo,MIN(stock) AS minimo,AVG(stock) AS media FROM producto_999x;
