-- ==========================================
-- ESCENARIO 3: RECUPERACIÓN PARCIAL (SAVEPOINT)
-- Objetivo: Cancelar únicamente una operación fallida sin perder las válidas.
-- ==========================================

BEGIN;

-- 1. Insertar cabecera de la factura
INSERT INTO invoice (customer_id, invoice_date, billing_address, billing_city, billing_country, total)
VALUES (3, CURRENT_TIMESTAMP, 'Calzada Roosevelt 22-43', 'Guatemala', 'Guatemala', 0.00);

-- 2. Insertar 2 detalles válidos
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES 
    (currval('invoice_invoice_id_seq'), 1, 0.99, 1),
    (currval('invoice_invoice_id_seq'), 2, 0.99, 1);

-- 3. Definir el punto de restauración
SAVEPOINT sp_antes_de_error;

-- 4. Inserción fallida intencionada (track_id = 888888 no existe)
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES (currval('invoice_invoice_id_seq'), 888888, 0.99, 1);

-- 5. Revertir el estado al punto de restauración (Anula solo el error previo)
ROLLBACK TO SAVEPOINT sp_antes_de_error;

-- 6. Insertar el tercer detalle corregido
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES (currval('invoice_invoice_id_seq'), 3, 1.99, 1);

-- 7. Actualizar el total exacto
UPDATE invoice
SET total = (
    SELECT SUM(unit_price * quantity)
    FROM invoice_line
    WHERE invoice_id = currval('invoice_invoice_id_seq')
)
WHERE invoice_id = currval('invoice_invoice_id_seq');

-- 8. Confirmar la transacción
COMMIT;

-- 9. Comprobación final (Verifica conservación de 3 detalles y total de $3.97)
SELECT 
    i.invoice_id, 
    i.customer_id,
    i.total AS total_registrado, 
    COUNT(l.invoice_line_id) AS cantidad_detalles,
    SUM(l.unit_price * l.quantity) AS suma_detalles
FROM invoice i
JOIN invoice_line l ON i.invoice_id = l.invoice_id
WHERE i.invoice_id = currval('invoice_invoice_id_seq')
GROUP BY i.invoice_id, i.customer_id, i.total;