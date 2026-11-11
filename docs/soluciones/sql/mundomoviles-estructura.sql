-- ==========================================
-- BASE DE DATOS: MUNDOMOVILES (Ejemplos)
-- Cadena: paises (1) -> (N) empresas (1) -> (N) moviles
-- Precios y fechas ficticios para practicar SQL.
-- Ejecutar en una base de datos nueva llamada mundomoviles.
-- ==========================================

CREATE TABLE paises (
    id_pais SERIAL PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL
);

CREATE TABLE empresas (
    id_empresa SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    sede VARCHAR(100),
    id_pais INTEGER NOT NULL REFERENCES paises(id_pais)
);

CREATE TABLE moviles (
    id_movil SERIAL PRIMARY KEY,
    modelo VARCHAR(200) NOT NULL,
    fecha_lanzamiento DATE,
    precio DECIMAL(10,2),
    id_empresa INTEGER NOT NULL REFERENCES empresas(id_empresa)
);
