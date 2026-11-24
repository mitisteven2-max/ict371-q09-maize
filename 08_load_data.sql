-- ICT371 Q9 (a): six deliveries, loaded AFTER the trigger (it fills rate and value)
-- All grades, both payment states. Farmer 3 has no unpaid deliveries.
INSERT INTO deliveries (farmer_id, grade, weight_kg, delivered_on, is_paid) VALUES
    (1, 'A', 100.00, DATE '2026-11-20', TRUE),
    (1, 'B', 250.50, DATE '2026-11-21', FALSE),
    (2, 'C', 300.00, DATE '2026-11-21', TRUE),
    (2, 'A',  80.00, DATE '2026-11-22', FALSE),
    (3, 'B', 120.00, DATE '2026-11-22', TRUE),
    (3, 'C',  50.00, DATE '2026-11-23', TRUE);
