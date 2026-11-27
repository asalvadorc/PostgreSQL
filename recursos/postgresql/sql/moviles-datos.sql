-- Datos de moviles. Ejecutar después de crear sus tablas.
BEGIN;

INSERT INTO paises (nombre_pais) VALUES
('Estados Unidos'), ('Corea del Sur'), ('China'), ('Japón');

INSERT INTO empresas (nombre, sede, id_pais) VALUES
('Apple', 'Cupertino, USA', 1),
('Samsung', 'Suwon, Corea del Sur', 2),
('Xiaomi', 'Pekín, China', 3),
('Sony', 'Tokio, Japón', 4);

INSERT INTO moviles (modelo, fecha_lanzamiento, precio, id_empresa) VALUES
('iPhone 15', '2023-09-01', 799.00, 1),
('iPhone 15 Pro', '2023-09-01', 999.00, 1),
('iPhone 16', '2024-09-01', 899.00, 1),
('Galaxy S24', '2024-01-01', 749.00, 2),
('Galaxy A55', '2024-03-01', 399.00, 2),
('Redmi Note 13', '2024-01-01', 249.00, 3),
('Xiaomi 14', '2024-02-01', 699.00, 3),
('Xperia', '2024-05-01', 849.00, 4);

COMMIT;
