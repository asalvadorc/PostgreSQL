-- ==========================================
-- BASE DE DATOS: MUNDOJUEGOS (Ejemplos)
-- ==========================================

CREATE TABLE estudios (
    id_estudio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    sede VARCHAR(100)
);

CREATE TABLE generos (
    id_genero SERIAL PRIMARY KEY,
    nombre_genero VARCHAR(50) NOT NULL
);

CREATE TABLE juegos (
    id_juego SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    fecha_lanzamiento DATE,
    precio DECIMAL(10,2),
    id_estudio INTEGER REFERENCES estudios(id_estudio),
    id_genero INTEGER REFERENCES generos(id_genero)
);

-- Datos de ejemplo para MundoJuegos
INSERT INTO estudios (nombre, sede) VALUES 
('Valve', 'Bellevue, USA'),
('FromSoftware', 'Tokio, Japón'),
('CD Projekt Red', 'Varsovia, Polonia'),
('Rockstar Games', 'Nueva York, USA');

INSERT INTO generos (nombre_genero) VALUES 
('Acción'), ('RPG'), ('Estrategia'), ('Aventura');

INSERT INTO juegos (titulo, fecha_lanzamiento, precio, id_estudio, id_genero) VALUES
('Half-Life: Alyx', '2020-03-23', 59.99, 1, 1),
('Elden Ring', '2022-02-25', 69.99, 2, 2),
('Cyberpunk 2077', '2020-12-10', 49.99, 3, 2),
('The Witcher 3', '2015-05-19', 29.99, 3, 2),
('Red Dead Redemption 2', '2018-10-26', 59.99, 4, 4);

-- ==========================================
-- BASE DE DATOS: TECNOTIENDA (Ejercicios)
-- ==========================================

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    marca VARCHAR(100),
    precio DECIMAL(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    stock_minimo INTEGER DEFAULT 5,
    id_categoria INTEGER REFERENCES categorias(id_categoria)
);

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    codigo_postal VARCHAR(10),
    poblacion VARCHAR(100),
    provincia VARCHAR(100)
);

CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100),
    puesto VARCHAR(100),
    salario DECIMAL(10,2),
    fecha_contratacion DATE,
    id_jefe INTEGER REFERENCES empleados(id_empleado)
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    fecha DATE DEFAULT CURRENT_DATE,
    id_cliente INTEGER REFERENCES clientes(id_cliente),
    id_empleado INTEGER REFERENCES empleados(id_empleado),
    descuento DECIMAL(5,2) DEFAULT 0
);

CREATE TABLE lineas_pedido (
    id_pedido INTEGER REFERENCES pedidos(id_pedido),
    num_linea INTEGER,
    id_producto INTEGER REFERENCES productos(id_producto),
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento_linea DECIMAL(5,2) DEFAULT 0,
    PRIMARY KEY (id_pedido, num_linea)
);

-- Algunos datos iniciales para TecnoTienda
INSERT INTO categorias (nombre_categoria) VALUES ('Portátiles'), ('Periféricos'), ('Componentes'), ('Gaming');

INSERT INTO productos (nombre, marca, precio, stock, stock_minimo, id_categoria) VALUES
('Razer DeathAdder V3', 'Razer', 79.99, 25, 5, 2),
('MacBook Pro M3', 'Apple', 1999.00, 10, 2, 1),
('RTX 4080 Super', 'NVIDIA', 1149.00, 4, 1, 3),
('Teclado Mecánico G915', 'Logitech', 249.00, 15, 3, 2);

INSERT INTO empleados (nombre, apellidos, puesto, salario, fecha_contratacion, id_jefe) VALUES
('Alicia', 'Damborenea', 'Gerente', 45000, '2010-01-15', NULL),
('Marcos', 'Vidal', 'Vendedor Senior', 32000, '2015-03-20', 1),
('Elena', 'García', 'Vendedor Junior', 24000, '2020-06-10', 1);

INSERT INTO clientes (nombre, apellidos, direccion, codigo_postal, poblacion, provincia) VALUES
('Juan', 'Pérez', 'Calle Mayor 10', '28001', 'Madrid', 'Madrid'),
('Marta', 'Sánchez', 'Avinguda Diagonal 50', '08001', 'Barcelona', 'Barcelona'),
('Luis', 'Villalonga', 'Calle del Mar 5', '12001', 'Castellón', 'Castellón');
