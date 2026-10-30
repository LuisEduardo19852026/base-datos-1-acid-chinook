-- ==========================================
-- ESCENARIO 1: VENTA EXITOSA (COMMIT)
-- Objetivo: Confirmar una transacción multitabla y recalcular el total exacto.
-- ==========================================

BEGIN;

-- 1. Insertar la cabecera de la factura
INSERT INTO invoice (customer_id, invoice_date, billing_address, billing_city, billing_country, total)
VALUES (1, CURRENT_TIMESTAMP, '5ta Calle 10-20, Zona 1', 'Guatemala', 'Guatemala', 0.00);

-- 2. Insertar 3 detalles de venta con canciones válidas (track_id: 1, 2 y 3)
INSERT INTO invoice_line (invoice_id, track_id, unit_price, quantity)
VALUES 
    (currval('invoice_invoice_id_seq'), 1, 0.99, 2),
    (currval('invoice_invoice_id_seq'), 2, 0.99, 1),
    (currval('invoice_invoice_id_seq'), 3, 1.99, 1);

-- 3. Recalcular y actualizar dinámicamente el total exacto en la cabecera
UPDATE invoice
SET total = (
    SELECT SUM(unit_price * quantity)
    FROM invoice_line
    WHERE invoice_id = currval('invoice_invoice_id_seq')
)
WHERE invoice_id = currval('invoice_invoice_id_seq');

-- 4. Confirmar permanentemente la transacción
COMMIT;

-- 5. Consulta de comprobación final (Verifica total de $4.96 y 3 detalles)
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