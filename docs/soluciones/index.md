# Soluciones

Este apartado reúne los scripts de referencia. Los materiales de trabajo y el paquete Docker contienen únicamente instrucciones y datos.

## Creación de tablas

- [Estructura de MundoMoviles](sql/mundomoviles-estructura.sql): tres tablas, con claves y restricciones.
- [Estructura de GameHub](sql/gamehub-estructura.sql): ocho tablas, nueve claves ajenas y borrado en cascada de las líneas.

Los scripts anteriores se ejecutan en su base correspondiente, previamente creada y vacía. No contienen `CREATE DATABASE` ni cargan datos.

## Restauración completa de referencia

- [MundoMoviles: estructura y datos](sql/mundomoviles-completa.sql).
- [GameHub: estructura y datos](sql/gamehub-completa.sql).

Estos scripts completos son alternativas de restauración para una base vacía. No los ejecutes sobre las tablas que ya has creado en las prácticas.

## Consultas

- [Soluciones y resultados de DQL básico](../BD_PostgreSQL_DQL/exercicis_de_tot_el_tema_amb_els_resultats.md).
- [Soluciones y resultados de DQL avanzado](../BD_PostgreSQL_DQL_Avancat/exercicis_de_tot_el_tema_amb_els_resultats.md).

Para retirar estas soluciones de una publicación no basta con quitarlas del menú: MkDocs sigue generando las páginas y copiando los archivos. Revisa también `exclude_docs` para el directorio `soluciones/` y las páginas de resultados, y comprueba que no queden enlaces o copias en la salida publicada.
