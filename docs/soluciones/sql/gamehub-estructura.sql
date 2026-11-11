-- ==========================================
-- BASE DE DATOS: GAMEHUB (Ejercicios)
-- Tienda de videojuegos, consolas y accesorios gaming.
-- Misma estructura que FACTURA: ocho tablas y las mismas relaciones.
-- Ejecutar en una base de datos nueva.
-- ==========================================

CREATE TABLE provincias (
    id_provincia SERIAL PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE ciudades (
    id_ciudad SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    id_provincia INTEGER REFERENCES provincias(id_provincia)
);

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    descripcion VARCHAR(100)
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(200),
    precio DECIMAL(10,2),
    stock INTEGER,
    stock_minimo INTEGER,
    id_categoria INTEGER REFERENCES categorias(id_categoria)
);

CREATE TABLE jugadores (
    id_jugador SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    direccion VARCHAR(200),
    codigo_postal VARCHAR(10),
    id_ciudad INTEGER REFERENCES ciudades(id_ciudad)
);

CREATE TABLE vendedores (
    id_vendedor SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    direccion VARCHAR(200),
    codigo_postal VARCHAR(10),
    id_ciudad INTEGER REFERENCES ciudades(id_ciudad),
    id_jefe INTEGER REFERENCES vendedores(id_vendedor)
);

CREATE TABLE compras (
    id_compra SERIAL PRIMARY KEY,
    fecha DATE,
    id_jugador INTEGER NOT NULL REFERENCES jugadores(id_jugador),
    id_vendedor INTEGER NOT NULL REFERENCES vendedores(id_vendedor),
    iva DECIMAL(5,2),
    descuento DECIMAL(5,2)
);

CREATE TABLE lineas_compra (
    id_compra INTEGER REFERENCES compras(id_compra) ON DELETE CASCADE,
    num_linea INTEGER,
    id_producto INTEGER NOT NULL REFERENCES productos(id_producto),
    cantidad INTEGER,
    precio_unitario DECIMAL(10,2),
    descuento_linea DECIMAL(5,2),
    PRIMARY KEY (id_compra, num_linea)
);
