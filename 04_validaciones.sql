-- ==========================================
-- ESCENARIO 4: VISIBILIDAD Y AISLAMIENTO (READ COMMITTED)
-- Objetivo: Demostrar que los cambios no confirmados no son visibles para otros usuarios.
-- ==========================================

-- ------------------------------------------
-- PASO 1: Ejecutar en Conexión A
-- ------------------------------------------
BEGIN;

INSERT INTO invoice (customer_id, invoice_date, billing_address, billing_city, billing_country, total)
VALUES (1, CURRENT_TIMESTAMP, 'Prueba Visibilidad A/B', 'Guatemala', 'Guatemala', 9.99);

SELECT currval('invoice_invoice_id_seq') AS id_pendiente_sesion_a;


-- ------------------------------------------
-- PASO 2: Ejecutar en Conexión B (Ventana independiente)
-- Debe retornar 0 filas debido al aislamiento Read Committed.
-- ------------------------------------------
SELECT * FROM invoice WHERE invoice_id = 416;


-- ------------------------------------------
-- PASO 3: Regresar a Conexión A y confirmar
-- ------------------------------------------
COMMIT;


-- ------------------------------------------
-- PASO 4: Volver a ejecutar en Conexión B
-- Ahora retorna 1 fila con los datos de la factura confirmada.
-- ------------------------------------------
SELECT * FROM invoice WHERE invoice_id = 416;