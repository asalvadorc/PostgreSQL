# Ejercicios DML: Juegos

Trabaja sobre tu **juegos local**, con sus datos iniciales cargados. Para cada bloque utiliza `BEGIN` y termina con `ROLLBACK`, de modo que DQL utilice el mismo conjunto de datos. Si quieres conservar un cambio, sustituye `ROLLBACK` por `COMMIT` solo cuando el profesor lo indique.

Consulta el [modelo de Juegos](../BD_PostgreSQL_DQL/juegos.md) y la [carga inicial](1_introducci.md).

**Ex_1.** Inserta las categorías `Realidad virtual` y `Streaming`. Omite sus códigos y recupéralos con `RETURNING`. No adivines los valores de la secuencia.

**Ex_2.** En la categoría Streaming que acabas de crear, inserta `Micrófono: Stream USB`, precio 79.90, stock 8 y stock mínimo 2. Utiliza el código devuelto en el ejercicio anterior.

**Ex_3.** Inserta un jugador llamado `Alex Torres`, dirección `Calle Sol 10`, código postal `28001` y ciudad Madrid. Localiza primero el código de la ciudad.

**Ex_4.** Crea una compra para ese jugador, atendida por el vendedor 2, con fecha actual, IVA 21 y descuento 0. Añade una línea del producto 1 y otra del 5, cada una con cantidad 1 y su precio actual. Recupera el código generado de la compra.

**Ex_5.** Añade una tercera línea con cantidad 2 del producto 10 y descuento de línea 10 %. Comprueba que no repites `(id_compra, num_linea)`.

**Ex_6.** Borra la compra recién creada. Comprueba que desaparecen sus tres líneas por la cascada y que permanecen jugador, vendedor y productos. Revierte todo el bloque con `ROLLBACK`.

**Ex_7.** Dentro de una transacción nueva, intenta borrar el producto 8, cuyo stock mínimo es nulo. Explica por qué falla si tiene líneas que lo referencian. Ejecuta `ROLLBACK` tras el error. Propón marcar un producto como inactivo en lugar de borrar su historial.

**Ex_8.** Quita los códigos postales de todos los jugadores, comprueba el resultado y revierte el cambio.

**Ex_9.** Sube un 5 % los precios de los productos de Periféricos, redondeando a dos decimales. Muestra los valores antes y después y revierte.

**Ex_10.** Cambia el jefe del vendedor 3 al vendedor 2. Comprueba la jerarquía y revierte. Explica por qué una FK reflexiva no impide por sí sola formar ciclos.

**Ex_11.** Modifica a 0 los descuentos nulos de las líneas. Comprueba cuántas filas cambian y revierte.

**Ex_12.** Inserta una compra y sus líneas dentro de una única transacción. Provoca un error usando un producto inexistente y realiza `ROLLBACK`. Comprueba que no quedan filas incompletas.

Al terminar deben seguir existiendo las **12 compras y 28 líneas iniciales**. Guarda las sentencias y las comprobaciones en `03_juegos_dml.sql`.
