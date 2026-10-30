-- ==========================================
-- ESCENARIO 2: ERROR Y REVERSIÓN TOTAL (ROLLBACK)
-- Objetivo: Demostrar la Atomicidad al forzar un error de Foreign Key.
-- ==========================================

BEGIN;

-- 1. Insertar la cabecera de la factura
INSERT INTO invoice (customer_id, invoice_date, billing_address, billing_city, billing_country, total)
VALUES (2, CURRENT_TIMESTAMP, 'Av. Las Américas 15-30', 'Guatemala', 'Guatemala', 0.00);

-- 2. Insertar detalle válido
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES (currval('invoice_invoice_id_seq'), 1, 0.99, 1);

-- 3. Inserción con track_id inexistente (Provoca error obligatorio de FK: SQL state 23503)
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES (currval('invoice_invoice_id_seq'), 999999, 0.99, 1);

-- 4. Revertir totalmente la transacción abortada
ROLLBACK;

-- 5. Comprobar que no quedó ningún registro en la base de datos (Retorna 0 filas)
SELECT * 
FROM invoice 
WHERE invoice_id = currval('invoice_invoice_id_seq');