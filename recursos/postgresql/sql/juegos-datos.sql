-- Datos de juegos. Ejecutar después de crear sus tablas.
BEGIN;

INSERT INTO provincias (nombre) VALUES
('Madrid'), ('Barcelona'), ('Castellón');

INSERT INTO ciudades (nombre, id_provincia) VALUES
('Madrid', 1), ('Alcalá de Henares', 1),
('Barcelona', 2), ('Terrassa', 2),
('Castellón de la Plana', 3), ('Vila-real', 3);

INSERT INTO categorias (descripcion) VALUES
('Videojuegos'), ('Consolas'), ('Periféricos'), ('Merchandising');

INSERT INTO productos (nombre, precio, stock, stock_minimo, id_categoria) VALUES
('Elden Ring', 59.99, 20, 5, 1),
('Minecraft', 29.99, 30, 5, 1),
('PlayStation 5', 499.99, 6, 2, 2),
('Nintendo Switch', 299.99, 5, 2, 2),
('RZ Mouse: DeathAdder', 45.00, 8, 2, 3),
('RZ Teclado: BlackWidow', 89.99, 5, 2, 3),
('Auriculares: HyperX Cloud', 69.99, NULL, 2, 3),
('Mando: Xbox Wireless', 59.99, 7, NULL, 3),
('Camiseta: Creeper', 19.99, 15, 3, 4),
('Figura: Hollow Knight', 24.99, 10, 2, 4),
('PC Gaming: RTX 4070', 1299.00, 3, 1, 2),
('PC Gaming: RTX 4080', 1899.00, 2, 1, 2);

INSERT INTO jugadores (nombre, direccion, codigo_postal, id_ciudad) VALUES
('Juan Pérez López', 'Calle Mayor 10', '28001', 1),
('Marta Sánchez Vidal', 'Avinguda Diagonal 50', '08001', 3),
('Luis Villalonga García', 'Calle del Mar 5', '12001', 5),
('Sara Vidal Villalonga', NULL, '28002', 1),
('Álex García Torres', 'Calle Sol 8', NULL, 1),
('Noa López Serra', NULL, '12002', 5),
('Hugo Martín Ruiz', 'Calle Luna 4', '08002', 3),
('Paula Serra Gil', 'Calle Estación 2', '28801', 2);

INSERT INTO vendedores (nombre, direccion, codigo_postal, id_ciudad, id_jefe) VALUES
('Alicia Damborenea', 'Calle Central 1', '28001', 1, NULL),
('Marcos Vidal', 'Avinguda Mar 3', '08001', 3, 1),
('Elena García', 'Calle Norte 5', '12001', 5, 1);

INSERT INTO compras (fecha, id_jugador, id_vendedor, iva, descuento) VALUES
('2024-01-10', 1, 2, 21, 0), ('2024-01-15', 5, 3, 21, 10),
('2024-02-05', 2, 2, 21, 0), ('2024-03-04', 5, 3, 21, 5),
('2024-03-12', 3, 2, 21, NULL), ('2024-03-20', 4, 3, 21, 0),
('2024-07-02', 5, 2, 21, 10), ('2024-09-10', 6, 3, 21, 0),
('2024-10-01', 7, 2, 21, 5), ('2024-10-15', 1, 3, 21, 0),
('2024-11-05', 2, 2, 21, 15), ('2024-12-02', 5, 3, 21, 0);

INSERT INTO lineas_compra (id_compra, num_linea, id_producto, cantidad, precio_unitario, descuento_linea) VALUES
(1, 1, 1, 1, 59.99, 0), (1, 2, 5, 1, 45, 5),
(2, 1, 3, 1, 499.99, 10), (2, 2, 10, 1, 24.99, 0),
(3, 1, 2, 2, 29.99, 0), (3, 2, 8, 1, 59.99, 5),
(4, 1, 1, 1, 59.99, 5), (4, 2, 6, 1, 89.99, NULL),
(5, 1, 3, 1, 499.99, 0), (5, 2, 4, 1, 299.99, 0),
(6, 1, 2, 1, 29.99, 0), (6, 2, 10, 2, 24.99, 10),
(7, 1, 11, 1, 1299, 0), (7, 2, 5, 1, 45, 5),
(8, 1, 5, 2, 45, 0), (9, 1, 4, 1, 299.99, 0),
(10, 1, 12, 1, 1899, 10), (11, 1, 3, 1, 499.99, 0),
(12, 1, 1, 1, 59.99, 5), (12, 2, 2, 1, 29.99, 0),
(12, 3, 3, 1, 499.99, 0), (12, 4, 4, 1, 299.99, 0),
(12, 5, 5, 1, 45, 5), (12, 6, 6, 1, 89.99, NULL),
(12, 7, 7, 1, 69.99, 0), (12, 8, 8, 1, 59.99, 0),
(12, 9, 9, 2, 19.99, 0), (12, 10, 10, 1, 24.99, 10);

COMMIT;
